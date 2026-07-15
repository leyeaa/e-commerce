from decimal import Decimal

import pytest
from rest_framework.test import APIClient

from store.models import Cart, CartItem, Category, Product


@pytest.fixture
def api_client():
    return APIClient()


@pytest.fixture
def user(django_user_model):
    return django_user_model.objects.create_user(
        username='manual_test_user',
        password='test-password',
    )


@pytest.fixture
def other_user(django_user_model):
    return django_user_model.objects.create_user(
        username='manual_test_other_user',
        password='test-password',
    )


@pytest.fixture
def authenticated_client(api_client, user):
    api_client.force_authenticate(user=user)
    return api_client


@pytest.fixture
def category(db):
    return Category.objects.create(
        name='Manual Test Products',
        slug='manual-test-products',
    )


@pytest.fixture
def product(category):
    return Product.objects.create(
        category=category,
        name='Manual Test Table',
        description='Deterministic test fixture',
        price=Decimal('125.50'),
    )


@pytest.fixture
def second_product(category):
    return Product.objects.create(
        category=category,
        name='Manual Test Lamp',
        description='Second deterministic test fixture',
        price=Decimal('25.00'),
    )


@pytest.fixture
def cart(user):
    return Cart.objects.create(user=user)


@pytest.fixture
def cart_item(cart, product):
    return CartItem.objects.create(
        cart=cart,
        product=product,
        quantity=2,
    )


@pytest.fixture
def other_cart(other_user):
    return Cart.objects.create(user=other_user)


@pytest.fixture
def other_cart_item(other_cart, product):
    return CartItem.objects.create(
        cart=other_cart,
        product=product,
        quantity=1,
    )
