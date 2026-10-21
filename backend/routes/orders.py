from fastapi import APIRouter, HTTPException
from typing import List
import uuid
from datetime import datetime
import database
from models import Order, OrderRequest, OrderItem, Product

router = APIRouter(prefix="/api/orders", tags=["Orders"])

def _get_product(prod_id: str) -> Product:
    for p in database.PRODUCTS:
        if p.id == prod_id:
            return p
    raise HTTPException(status_code=404, detail=f"Product {prod_id} not found")

@router.get("", response_model=List[Order])
def get_orders():
    return database.ORDERS

@router.get("/{order_id}", response_model=Order)
def get_order(order_id: str):
    for order in database.ORDERS:
        if order.id == order_id:
            return order
    raise HTTPException(status_code=404, detail="Order not found")

@router.post("", response_model=Order)
def create_order(request: OrderRequest):
    if not request.items:
        raise HTTPException(status_code=400, detail="Order cannot be empty")

    order_items = []
    subtotal = 0.0

    for item_req in request.items:
        prod = _get_product(item_req.product_id)
        unit_price = prod.price
        subtotal += unit_price * item_req.quantity

        order_items.append(OrderItem(
            product_id=prod.id,
            product_name=prod.name,
            unit_price=unit_price,
            quantity=item_req.quantity,
            selected_color=item_req.selected_color,
            selected_size=item_req.selected_size,
            image_url=prod.images[0] if prod.images else ""
        ))

    shipping_fee = 0.0 if subtotal > 150.0 else 15.0
    tax = round(subtotal * 0.08, 2)
    total_amount = round(subtotal + shipping_fee + tax, 2)

    order_id = f"ORD-{uuid.uuid4().hex[:5].upper()}"
    created_at = datetime.now().strftime("%Y-%m-%d %H:%M")

    new_order = Order(
        id=order_id,
        created_at=created_at,
        items=order_items,
        subtotal=subtotal,
        shipping_fee=shipping_fee,
        tax=tax,
        total_amount=total_amount,
        status="Processing",
        shipping_address=f"{request.address}, {request.city} {request.postal_code}",
        full_name=request.full_name,
        payment_method=request.payment_method
    )

    database.ORDERS.insert(0, new_order)
    # Clear cart after order placement
    database.CART_ITEMS = []

    return new_order
