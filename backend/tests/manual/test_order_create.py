import pytest

from store.models import CartItem, Order, OrderItem


pytestmark = [pytest.mark.django_db, pytest.mark.manual]
ENDPOINT = '/api/orders/create/'
VALID_ORDER = {
    'name': 'Manual Test Customer',
    'address': '1 Verification Avenue',
    'phone': '7095550100',
    'payment_method': 'COD',
}


def test_authentication_is_required(api_client, cart_item):
    response = api_client.post(ENDPOINT, VALID_ORDER, format='json')

    assert response.status_code == 401
    assert Order.objects.count() == 0
    assert CartItem.objects.filter(id=cart_item.id).exists()


def test_valid_order_is_created_from_cart(
    authenticated_client,
    cart_item,
):
    response = authenticated_client.post(
        ENDPOINT,
        VALID_ORDER,
        format='json',
    )

    assert response.status_code == 200
    order = Order.objects.get(id=response.data['order_id'])
    order_item = order.items.get()
    assert order.user == cart_item.cart.user
    assert order.total_amount == cart_item.product.price * 2
    assert order_item.product == cart_item.product
    assert order_item.quantity == 2
    assert not CartItem.objects.filter(id=cart_item.id).exists()


def test_empty_cart_is_rejected(authenticated_client, cart):
    response = authenticated_client.post(
        ENDPOINT,
        VALID_ORDER,
        format='json',
    )

    assert response.status_code == 400
    assert Order.objects.count() == 0


@pytest.mark.parametrize('phone', ['not-a-phone', '123456789'])
def test_invalid_phone_format_is_rejected(
    authenticated_client,
    cart_item,
    phone,
):
    payload = {**VALID_ORDER, 'phone': phone}
    response = authenticated_client.post(
        ENDPOINT,
        payload,
        format='json',
    )

    assert response.status_code == 400
    assert Order.objects.count() == 0
    assert CartItem.objects.filter(id=cart_item.id).exists()


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-009: required checkout fields are not validated',
    strict=True,
)
@pytest.mark.parametrize('required_field', ['name', 'address'])
def test_required_checkout_fields_are_validated(
    authenticated_client,
    cart_item,
    required_field,
):
    payload = VALID_ORDER.copy()
    payload.pop(required_field)
    response = authenticated_client.post(
        ENDPOINT,
        payload,
        format='json',
    )

    assert response.status_code == 400
    assert Order.objects.count() == 0
    assert CartItem.objects.filter(id=cart_item.id).exists()


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-009: payment-method choices are not validated',
    strict=True,
)
def test_unknown_payment_method_is_rejected(
    authenticated_client,
    cart_item,
):
    payload = {**VALID_ORDER, 'payment_method': 'CRYPTO'}
    response = authenticated_client.post(
        ENDPOINT,
        payload,
        format='json',
    )

    assert response.status_code == 400
    assert Order.objects.count() == 0
    assert CartItem.objects.filter(id=cart_item.id).exists()


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-004: missing phone produces an internal server error',
    strict=True,
)
def test_missing_phone_is_a_client_error(
    authenticated_client,
    cart_item,
):
    payload = VALID_ORDER.copy()
    payload.pop('phone')
    response = authenticated_client.post(
        ENDPOINT,
        payload,
        format='json',
    )

    assert response.status_code == 400
    assert Order.objects.count() == 0
    assert CartItem.objects.filter(id=cart_item.id).exists()


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-005: non-string phone produces an internal server error',
    strict=True,
)
def test_non_string_phone_is_a_client_error(
    authenticated_client,
    cart_item,
):
    payload = {**VALID_ORDER, 'phone': ['7095550100']}
    response = authenticated_client.post(
        ENDPOINT,
        payload,
        format='json',
    )

    assert response.status_code == 400
    assert Order.objects.count() == 0
    assert CartItem.objects.filter(id=cart_item.id).exists()


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-006: checkout details are accepted but not persisted',
    strict=True,
)
def test_checkout_details_are_persisted(
    authenticated_client,
    cart_item,
):
    response = authenticated_client.post(
        ENDPOINT,
        VALID_ORDER,
        format='json',
    )

    order = Order.objects.get(id=response.data['order_id'])
    assert order.shipping_name == VALID_ORDER['name']
    assert order.shipping_address == VALID_ORDER['address']
    assert order.phone == VALID_ORDER['phone']
    assert order.payment_method == VALID_ORDER['payment_method']


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-007: order creation is not atomic on an item-write failure',
    strict=True,
)
def test_order_creation_rolls_back_if_an_item_cannot_be_written(
    authenticated_client,
    cart,
    cart_item,
    second_product,
    monkeypatch,
):
    CartItem.objects.create(
        cart=cart,
        product=second_product,
        quantity=1,
    )
    original_create = OrderItem.objects.create
    calls = {'count': 0}

    def fail_second_create(*args, **kwargs):
        calls['count'] += 1
        if calls['count'] == 2:
            raise RuntimeError('controlled item creation failure')
        return original_create(*args, **kwargs)

    monkeypatch.setattr(OrderItem.objects, 'create', fail_second_create)
    response = authenticated_client.post(
        ENDPOINT,
        VALID_ORDER,
        format='json',
    )

    assert response.status_code == 500
    assert Order.objects.count() == 0
    assert OrderItem.objects.count() == 0
    assert cart.items.count() == 2
