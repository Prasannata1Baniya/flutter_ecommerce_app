from django.urls import path
from . import views

urlpatterns = [
    path('categories', views.get_categories, name='categories'),
    path('products', views.get_products, name='products'),
    path('products/<str:product_id>', views.get_product_detail, name='product_detail'),

    path('cart', views.get_cart, name='get_cart'),
    path('cart/add', views.add_to_cart, name='add_to_cart'),
    path('cart/item/<str:item_id>', views.cart_item_detail, name='cart_item_detail'),
    path('cart/clear', views.clear_cart, name='clear_cart'),

    path('orders', views.orders_view, name='orders'),
    path('orders/<str:order_id>', views.get_order_detail, name='order_detail'),

    path('user/profile', views.get_user_profile, name='user_profile'),
    path('user/wishlist', views.get_wishlist, name='get_wishlist'),
    path('user/wishlist/toggle', views.toggle_wishlist, name='toggle_wishlist'),
]
