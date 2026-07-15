'''Create deterministic data for isolated manual and fuzzing runs.'''

import os
from decimal import Decimal

from django.contrib.auth.models import User
from django.core.management.base import BaseCommand
from django.db import transaction

from store.models import Cart, CartItem, Category, Product


DEFAULT_USERNAME = 'experiment_user'
DEFAULT_OTHER_USERNAME = 'experiment_other_user'
DEFAULT_PASSWORD = 'CourseProject-Only-Password-Change-Me'
CATEGORY_SLUG = 'experiment-products'


class Command(BaseCommand):
    help = 'Seed deterministic users, products, and carts for the experiment.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--reset',
            action='store_true',
            help='Delete and recreate only records owned by the experiment seed.',
        )

    @transaction.atomic
    def handle(self, *args, **options):
        username = os.getenv('EXPERIMENT_USERNAME', DEFAULT_USERNAME)
        password = os.getenv('EXPERIMENT_PASSWORD', DEFAULT_PASSWORD)
        other_username = os.getenv(
            'EXPERIMENT_OTHER_USERNAME',
            DEFAULT_OTHER_USERNAME,
        )

        if options['reset']:
            User.objects.filter(
                username__in=[username, other_username]
            ).delete()
            Category.objects.filter(slug=CATEGORY_SLUG).delete()

        category, _ = Category.objects.update_or_create(
            slug=CATEGORY_SLUG,
            defaults={'name': 'Experiment Products'},
        )
        product, _ = Product.objects.update_or_create(
            category=category,
            name='Experiment Table',
            defaults={
                'description': 'Deterministic fixture product',
                'price': Decimal('125.50'),
            },
        )
        Product.objects.update_or_create(
            category=category,
            name='Experiment Lamp',
            defaults={
                'description': 'Second deterministic fixture product',
                'price': Decimal('25.00'),
            },
        )

        user = self._upsert_user(username, password)
        other_user = self._upsert_user(other_username, password)
        cart, _ = Cart.objects.get_or_create(user=user)
        other_cart, _ = Cart.objects.get_or_create(user=other_user)
        CartItem.objects.update_or_create(
            cart=cart,
            product=product,
            defaults={'quantity': 2},
        )
        CartItem.objects.update_or_create(
            cart=other_cart,
            product=product,
            defaults={'quantity': 1},
        )

        self.stdout.write(
            self.style.SUCCESS(
                f'Experiment data ready for {username} and {other_username}.'
            )
        )

    @staticmethod
    def _upsert_user(username, password):
        user, _ = User.objects.get_or_create(
            username=username,
            defaults={'email': f'{username}@example.test'},
        )
        user.set_password(password)
        user.save(update_fields=['password'])
        return user
