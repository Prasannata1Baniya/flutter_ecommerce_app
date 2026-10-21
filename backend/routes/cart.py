from fastapi import APIRouter, HTTPException
from typing import List, Dict
import uuid
import database
from models import CartItem, CartItemRequest, Product

router = APIRouter(prefix="/api/cart", tags=["Cart"])

def _get_product_by_id(prod_id: str) -> Product:
    for p in database.PRODUCTS:
        if p.id == prod_id:
            return p
    raise HTTPException(status_code=404, detail=f"Product {prod_id} not found")

@router.get("", response_model=List[CartItem])
def get_cart():
    cart_items = []
    for raw in database.CART_ITEMS:
        prod = _get_product_by_id(raw["product_id"])
        cart_items.append(CartItem(
            id=raw["id"],
            product=prod,
            quantity=raw["quantity"],
            selected_color=raw.get("selected_color"),
            selected_size=raw.get("selected_size")
        ))
    return cart_items

@router.post("/add", response_model=List[CartItem])
def add_to_cart(request: CartItemRequest):
    prod = _get_product_by_id(request.product_id)

    # Check if existing item in cart matches product_id, color, size
    for item in database.CART_ITEMS:
        if (item["product_id"] == request.product_id and
            item.get("selected_color") == request.selected_color and
            item.get("selected_size") == request.selected_size):
            item["quantity"] += request.quantity
            return get_cart()

    # Otherwise add new item
    new_cart_item = {
        "id": f"cart_{uuid.uuid4().hex[:6]}",
        "product_id": request.product_id,
        "quantity": request.quantity,
        "selected_color": request.selected_color,
        "selected_size": request.selected_size
    }
    database.CART_ITEMS.append(new_cart_item)
    return get_cart()

@router.put("/item/{item_id}", response_model=List[CartItem])
def update_cart_item_quantity(item_id: str, quantity: int):
    if quantity <= 0:
        database.CART_ITEMS = [i for i in database.CART_ITEMS if i["id"] != item_id]
    else:
        for item in database.CART_ITEMS:
            if item["id"] == item_id:
                item["quantity"] = quantity
                break
    return get_cart()

@router.delete("/item/{item_id}", response_model=List[CartItem])
def remove_from_cart(item_id: str):
    database.CART_ITEMS = [i for i in database.CART_ITEMS if i["id"] != item_id]
    return get_cart()

@router.delete("/clear", response_model=List[CartItem])
def clear_cart():
    database.CART_ITEMS = []
    return []
