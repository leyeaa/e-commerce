'''Emit a JSON snapshot of records owned by the deterministic experiment users.'''

import json
import os

from django.contrib.auth.models import User
from django.core.management.base import BaseCommand
from django.utils import timezone

from store.management.commands.seed_experiment import (
    DEFAULT_OTHER_USERNAME,
    DEFAULT_USERNAME,
)
from store.models import Order


class Command(BaseCommand):
    help = 'Print deterministic experiment-user cart and order state as JSON.'

    def handle(self, *args, **options):
        usernames = [
            os.getenv('EXPERIMENT_USERNAME', DEFAULT_USERNAME),
            os.getenv('EXPERIMENT_OTHER_USERNAME', DEFAULT_OTHER_USERNAME),
        ]
        users = User.objects.filter(username__in=usernames).order_by('username')
        payload = {
            'captured_at': timezone.now().isoformat(),
            'database': os.getenv(
                'FUZZ_DB_NAME',
                'ecommerce_course_project_fuzz',
            ),
            'users': [self._user_state(user) for user in users],
        }
        self.stdout.write(json.dumps(payload, indent=2, sort_keys=True))

    @staticmethod
    def _user_state(user):
        carts = []
        for cart in user.cart_set.prefetch_related('items__product').order_by('id'):
            carts.append(
                {
                    'id': cart.id,
                    'total': str(cart.total),
                    'items': [
                        {
                            'id': item.id,
                            'product_id': item.product_id,
                            'product_name': item.product.name,
                            'quantity': item.quantity,
                            'unit_price': str(item.product.price),
                        }
                        for item in cart.items.order_by('id')
                    ],
                }
            )

        orders = []
        queryset = Order.objects.filter(user=user).prefetch_related(
            'items__product'
        ).order_by('id')
        for order in queryset:
            orders.append(
                {
                    'id': order.id,
                    'created_at': order.created_at.isoformat(),
                    'total_amount': str(order.total_amount),
                    'items': [
                        {
                            'id': item.id,
                            'product_id': item.product_id,
                            'product_name': item.product.name,
                            'quantity': item.quantity,
                            'price': str(item.price),
                        }
                        for item in order.items.order_by('id')
                    ],
                }
            )

        return {
            'id': user.id,
            'username': user.username,
            'carts': carts,
            'orders': orders,
        }
