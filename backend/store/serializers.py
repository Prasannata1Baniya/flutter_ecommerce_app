from rest_framework import serializers
from .models import Category, Product, CartItem, Order, OrderItem, UserProfile, Wishlist

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name', 'icon', 'item_count']

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = [
            'id', 'name', 'subtitle', 'price', 'original_price',
            'rating', 'reviews_count', 'category', 'description',
            'details', 'images', 'colors', 'sizes', 'is_featured',
            'is_new', 'stock'
        ]

class CartItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    product_id = serializers.CharField(write_only=True)

    class Meta:
        model = CartItem
        fields = ['id', 'product', 'product_id', 'quantity', 'selected_color', 'selected_size']

class OrderItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItem
        fields = [
            'product_id', 'product_name', 'unit_price', 'quantity',
            'selected_color', 'selected_size', 'image_url'
        ]

class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    created_at = serializers.DateTimeField(format="%Y-%m-%d %H:%M", read_only=True)

    class Meta:
        model = Order
        fields = [
            'id', 'created_at', 'items', 'subtotal', 'shipping_fee',
            'tax', 'total_amount', 'status', 'shipping_address',
            'full_name', 'payment_method'
        ]

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['id', 'name', 'email', 'avatar_url', 'phone', 'default_address']
