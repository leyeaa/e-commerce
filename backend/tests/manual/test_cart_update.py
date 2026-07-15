import pytest

from store.models import CartItem


pytestmark = [pytest.mark.django_db, pytest.mark.manual]
ENDPOINT = '/api/cart/update/'


def test_authentication_is_required(api_client, cart_item):
    response = api_client.post(
        ENDPOINT,
        {'item_id': cart_item.id, 'quantity': 3},
        format='json',
    )

    assert response.status_code == 401
    cart_item.refresh_from_db()
    assert cart_item.quantity == 2


def test_owner_can_update_quantity(authenticated_client, cart_item):
    response = authenticated_client.post(
        ENDPOINT,
        {'item_id': cart_item.id, 'quantity': 3},
        format='json',
    )

    assert response.status_code == 200
    cart_item.refresh_from_db()
    assert cart_item.quantity == 3


def test_missing_quantity_is_rejected_without_state_change(
    authenticated_client,
    cart_item,
):
    response = authenticated_client.post(
        ENDPOINT,
        {'item_id': cart_item.id},
        format='json',
    )

    assert response.status_code == 400
    cart_item.refresh_from_db()
    assert cart_item.quantity == 2


def test_unknown_item_is_reported_as_not_found(authenticated_client):
    response = authenticated_client.post(
        ENDPOINT,
        {'item_id': 999999, 'quantity': 2},
        format='json',
    )

    assert response.status_code == 404


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-001: cart updates do not enforce item ownership',
    strict=True,
)
def test_user_cannot_update_another_users_item(
    authenticated_client,
    other_cart_item,
):
    response = authenticated_client.post(
        ENDPOINT,
        {'item_id': other_cart_item.id, 'quantity': 9},
        format='json',
    )

    assert response.status_code in {403, 404}
    other_cart_item.refresh_from_db()
    assert other_cart_item.quantity == 1


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-002: malformed quantities cause an internal server error',
    strict=True,
)
def test_non_integer_quantity_is_a_client_error(
    authenticated_client,
    cart_item,
):
    authenticated_client.raise_request_exception = False
    response = authenticated_client.post(
        ENDPOINT,
        {'item_id': cart_item.id, 'quantity': 'not-an-integer'},
        format='json',
    )

    assert response.status_code == 400
    cart_item.refresh_from_db()
    assert cart_item.quantity == 2


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-003: an invalid zero quantity deletes persistent state',
    strict=True,
)
def test_zero_quantity_is_rejected_without_deleting_item(
    authenticated_client,
    cart_item,
):
    response = authenticated_client.post(
        ENDPOINT,
        {'item_id': cart_item.id, 'quantity': 0},
        format='json',
    )

    assert response.status_code == 400
    assert CartItem.objects.filter(id=cart_item.id).exists()


@pytest.mark.known_defect
@pytest.mark.xfail(
    reason='K-008: a malformed item identifier causes a server error',
    strict=True,
)
def test_malformed_item_id_is_a_client_error(
    authenticated_client,
    cart_item,
):
    authenticated_client.raise_request_exception = False
    response = authenticated_client.post(
        ENDPOINT,
        {'item_id': {}, 'quantity': 2},
        format='json',
    )

    assert response.status_code == 400
    cart_item.refresh_from_db()
    assert cart_item.quantity == 2
