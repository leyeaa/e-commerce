from rest_framework import serializers
from .models import Product, Category, Cart, CartItem
from django.contrib.auth.models import User
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer(read_only=True)

    class Meta:
        model = Product
        fields = '__all__'

class CartItemSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.name', read_only=True)
    product_price = serializers.DecimalField(source='product.price', max_digits=10, decimal_places=2, read_only=True)
    product_image = serializers.ImageField(source='product.image', read_only=True)
    class Meta:
        model = CartItem
        fields = '__all__'
    
class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    total = serializers.ReadOnlyField()
    class Meta:
        model = Cart
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email']

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'password2']

    def validate(self, data):
        if data['password'] != data['password2']:
            raise serializers.ValidationError("Passwords do not match.")
        return data
    
    def create(self, validated_data):
        username = validated_data['username']
        email = validated_data.get('email', '')
        password = validated_data['password']
        user = User.objects.create_user(username=username, email=email, password=password)
        return user


class CartUpdateRequestSerializer(serializers.Serializer):
    item_id = serializers.IntegerField(min_value=1)
    quantity = serializers.IntegerField(min_value=1)


class OrderCreateRequestSerializer(serializers.Serializer):
    name = serializers.CharField(min_length=1, max_length=200)
    address = serializers.CharField(min_length=1, max_length=500)
    phone = serializers.RegexField(regex=r'^\d{10,15}$')
    payment_method = serializers.ChoiceField(
        choices=['COD', 'ONLINE'],
        default='COD',
    )


class ErrorResponseSerializer(serializers.Serializer):
    error = serializers.CharField()


class DetailResponseSerializer(serializers.Serializer):
    detail = serializers.CharField()


class ClientErrorResponseSerializer(serializers.Serializer):
    error = serializers.CharField(required=False)
    detail = serializers.CharField(required=False)


class OrderCreatedResponseSerializer(serializers.Serializer):
    message = serializers.CharField()
    order_id = serializers.IntegerField(min_value=1)
