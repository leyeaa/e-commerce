'''State isolation hooks for the formal Schemathesis comparison.'''

import os

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings_fuzz')

import django

django.setup()

import schemathesis
from django.contrib.auth.models import User
from django.db import transaction

from store.management.commands.seed_experiment import (
    CATEGORY_SLUG,
    DEFAULT_USERNAME,
)
from store.models import Cart, CartItem, Category, Order, Product


@schemathesis.hook
def before_call(ctx, case, kwargs):
    '''Restore identical user, cart, and order state before every request.'''
    username = os.getenv('EXPERIMENT_USERNAME', DEFAULT_USERNAME)

    with transaction.atomic():
        user = User.objects.select_for_update().get(username=username)
        category = Category.objects.get(slug=CATEGORY_SLUG)
        product = Product.objects.get(
            category=category,
            name='Experiment Table',
        )
        Order.objects.filter(user=user).delete()
        cart, _ = Cart.objects.get_or_create(user=user)
        Cart.objects.filter(user=user).exclude(id=cart.id).delete()
        cart.items.all().delete()
        item = CartItem.objects.create(
            cart=cart,
            product=product,
            quantity=2,
        )

    # Preserve malformed or missing identifiers. Replace only schema-valid
    # integer identifiers so positive cases reach the quantity business logic.
    if case.path == '/api/cart/update/' and isinstance(case.body, dict):
        item_id = case.body.get('item_id')
        if type(item_id) is int and item_id >= 1:
            case.body['item_id'] = item.id
