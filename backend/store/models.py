from django.db import models
import uuid

class Category(models.Model):
    id = models.CharField(max_length=50, primary_key=True)
    name = models.CharField(max_length=100)
    icon = models.CharField(max_length=50, default='grid_view')
    item_count = models.IntegerField(default=0)

    class Meta:
        verbose_name_plural = "Categories"

    def __str__(self):
        return self.name

class Product(models.Model):
    id = models.CharField(max_length=50, primary_key=True)
    name = models.CharField(max_length=200)
    subtitle = models.CharField(max_length=200, blank=True, default='')
    price = models.FloatField()
    original_price = models.FloatField(null=True, blank=True)
    rating = models.FloatField(default=5.0)
    reviews_count = models.IntegerField(default=0)
    category = models.CharField(max_length=50, default='all')
    description = models.TextField(blank=True, default='')
    details = models.JSONField(default=list, blank=True)
    images = models.JSONField(default=list, blank=True)
    colors = models.JSONField(default=list, blank=True)
    sizes = models.JSONField(default=list, blank=True)
    is_featured = models.BooleanField(default=False)
    is_new = models.BooleanField(default=False)
    stock = models.IntegerField(default=10)

    def __str__(self):
        return self.name

class CartItem(models.Model):
    id = models.CharField(max_length=50, primary_key=True, default=uuid.uuid4)
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='cart_items')
    quantity = models.IntegerField(default=1)
    selected_color = models.CharField(max_length=50, null=True, blank=True)
    selected_size = models.CharField(max_length=50, null=True, blank=True)

    def __str__(self):
        return f"{self.quantity} x {self.product.name}"

class Order(models.Model):
    id = models.CharField(max_length=50, primary_key=True)
    created_at = models.DateTimeField(auto_now_add=True)
    subtotal = models.FloatField()
    shipping_fee = models.FloatField(default=0.0)
    tax = models.FloatField(default=0.0)
    total_amount = models.FloatField()
    status = models.CharField(max_length=50, default='Processing')
    shipping_address = models.TextField()
    full_name = models.CharField(max_length=200)
    payment_method = models.CharField(max_length=100, default='Credit Card')

    def __str__(self):
        return f"Order {self.id} - {self.full_name}"

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product_id = models.CharField(max_length=50)
    product_name = models.CharField(max_length=200)
    unit_price = models.FloatField()
    quantity = models.IntegerField(default=1)
    selected_color = models.CharField(max_length=50, null=True, blank=True)
    selected_size = models.CharField(max_length=50, null=True, blank=True)
    image_url = models.URLField(max_length=500, blank=True, default='')

    def __str__(self):
        return f"{self.quantity} x {self.product_name}"

class UserProfile(models.Model):
    id = models.CharField(max_length=50, primary_key=True, default='usr_1')
    name = models.CharField(max_length=200, default='Alex Morgan')
    email = models.EmailField(default='alex.morgan@maison.com')
    avatar_url = models.URLField(max_length=500, default='https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400')
    phone = models.CharField(max_length=50, default='+1 (555) 234-5678')
    default_address = models.TextField(default='742 Evergreen Terrace, Springfield')

    def __str__(self):
        return self.name

class Wishlist(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='wishlisted_by')

    def __str__(self):
        return self.product.name
