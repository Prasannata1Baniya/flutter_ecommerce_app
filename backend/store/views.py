import uuid
from datetime import datetime
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Category, Product, CartItem, Order, OrderItem, UserProfile, Wishlist
from .serializers import (
    CategorySerializer, ProductSerializer, CartItemSerializer,
    OrderSerializer, OrderItemSerializer, UserProfileSerializer
)

@api_view(['GET'])
def get_categories(request):
    categories = Category.objects.all()
    serializer = CategorySerializer(categories, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def get_products(request):
    category = request.GET.get('category')
    search = request.GET.get('search')
    featured_only = request.GET.get('featured_only')
    sort_by = request.GET.get('sort_by')

    products = Product.objects.all()

    if category and category != 'all':
        products = products.filter(category__iexact=category)

    if search:
        products = products.filter(
            name__icontains=search
        ) | products.filter(
            subtitle__icontains=search
        ) | products.filter(
            description__icontains=search
        )

    if featured_only == 'true':
        products = products.filter(is_featured=True)

    products = list(products)

    if sort_by == 'price_low':
        products.sort(key=lambda x: x.price)
    elif sort_by == 'price_high':
        products.sort(key=lambda x: x.price, reverse=True)
    elif sort_by == 'rating':
        products.sort(key=lambda x: x.rating, reverse=True)

    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def get_product_detail(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
        serializer = ProductSerializer(product)
        return Response(serializer.data)
    except Product.DoesNotExist:
        return Response({"detail": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def get_cart(request):
    items = CartItem.objects.all()
    serializer = CartItemSerializer(items, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def add_to_cart(request):
    product_id = request.data.get('product_id')
    quantity = int(request.data.get('quantity', 1))
    color = request.data.get('selected_color')
    size = request.data.get('selected_size')

    try:
        product = Product.objects.get(id=product_id)
    except Product.DoesNotExist:
        return Response({"detail": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

    # Check if item exists in cart with same specs
    existing = CartItem.objects.filter(
        product=product,
        selected_color=color,
        selected_size=size
    ).first()

    if existing:
        existing.quantity += quantity
        existing.save()
    else:
        CartItem.objects.create(
            id=f"cart_{uuid.uuid4().hex[:6]}",
            product=product,
            quantity=quantity,
            selected_color=color,
            selected_size=size
        )

    items = CartItem.objects.all()
    serializer = CartItemSerializer(items, many=True)
    return Response(serializer.data)

@api_view(['PUT', 'DELETE'])
def cart_item_detail(request, item_id):
    try:
        item = CartItem.objects.get(id=item_id)
    except CartItem.DoesNotExist:
        return Response({"detail": "Cart item not found"}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'DELETE':
        item.delete()
    elif request.method == 'PUT':
        qty = int(request.data.get('quantity', 1))
        if qty <= 0:
            item.delete()
        else:
            item.quantity = qty
            item.save()

    items = CartItem.objects.all()
    serializer = CartItemSerializer(items, many=True)
    return Response(serializer.data)

@api_view(['DELETE'])
def clear_cart(request):
    CartItem.objects.all().delete()
    return Response([])

@api_view(['GET', 'POST'])
def orders_view(request):
    if request.method == 'GET':
        orders = Order.objects.all().order_by('-created_at')
        serializer = OrderSerializer(orders, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        items_data = request.data.get('items', [])
        if not items_data:
            return Response({"detail": "Order cannot be empty"}, status=status.HTTP_400_BAD_REQUEST)

        subtotal = 0.0
        order_items_to_create = []

        for item_req in items_data:
            prod_id = item_req.get('product_id')
            qty = int(item_req.get('quantity', 1))
            try:
                prod = Product.objects.get(id=prod_id)
            except Product.DoesNotExist:
                return Response({"detail": f"Product {prod_id} not found"}, status=status.HTTP_404_NOT_FOUND)

            unit_price = prod.price
            subtotal += unit_price * qty

            order_items_to_create.append({
                'product_id': prod.id,
                'product_name': prod.name,
                'unit_price': unit_price,
                'quantity': qty,
                'selected_color': item_req.get('selected_color'),
                'selected_size': item_req.get('selected_size'),
                'image_url': prod.images[0] if prod.images else ''
            })

        shipping_fee = 0.0 if subtotal > 150.0 else 15.0
        tax = round(subtotal * 0.08, 2)
        total_amount = round(subtotal + shipping_fee + tax, 2)

        order_id = f"ORD-{uuid.uuid4().hex[:5].upper()}"

        new_order = Order.objects.create(
            id=order_id,
            subtotal=subtotal,
            shipping_fee=shipping_fee,
            tax=tax,
            total_amount=total_amount,
            status="Processing",
            shipping_address=f"{request.data.get('address')}, {request.data.get('city')} {request.data.get('postal_code')}",
            full_name=request.data.get('full_name', ''),
            payment_method=request.data.get('payment_method', 'eSewa')
        )

        for oi in order_items_to_create:
            OrderItem.objects.create(order=new_order, **oi)

        # Clear cart
        CartItem.objects.all().delete()

        serializer = OrderSerializer(new_order)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

@api_view(['POST'])
def esewa_verify_payment(request):
    """
    Simulates eSewa payment verification on Django backend.
    """
    amount = request.data.get('amount')
    reference_id = request.data.get('reference_id', f"ESEWA-{uuid.uuid4().hex[:8].upper()}")
    esewa_phone = request.data.get('esewa_phone')

    return Response({
        "status": "SUCCESS",
        "message": "eSewa Payment Verified Successfully",
        "reference_id": reference_id,
        "amount": amount,
        "esewa_phone": esewa_phone,
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }, status=status.HTTP_200_OK)

@api_view(['GET'])
def get_order_detail(request, order_id):
    try:
        order = Order.objects.get(id=order_id)
        serializer = OrderSerializer(order)
        return Response(serializer.data)
    except Order.DoesNotExist:
        return Response({"detail": "Order not found"}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def get_user_profile(request):
    profile, _ = UserProfile.objects.get_or_create(id='usr_1')
    serializer = UserProfileSerializer(profile)
    return Response(serializer.data)

@api_view(['GET'])
def get_wishlist(request):
    wishlisted = Wishlist.objects.all().select_related('product')
    products = [w.product for w in wishlisted]
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['POST'])
def toggle_wishlist(request):
    prod_id = request.data.get('product_id')
    try:
        prod = Product.objects.get(id=prod_id)
    except Product.DoesNotExist:
        return Response({"detail": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

    existing = Wishlist.objects.filter(product=prod).first()
    if existing:
        existing.delete()
        is_fav = False
    else:
        Wishlist.objects.create(product=prod)
        is_fav = True

    return Response({
        "product_id": prod_id,
        "is_favorite": is_fav,
        "wishlist_count": Wishlist.objects.count()
    })
