from pydantic import BaseModel, Field
from typing import List, Optional

class Product(BaseModel):
    id: str
    name: str
    subtitle: str
    price: float
    original_price: Optional[float] = None
    rating: float
    reviews_count: int
    category: str
    description: str
    details: List[str]
    images: List[str]
    colors: List[str]
    sizes: List[str]
    is_featured: bool = False
    is_new: bool = False
    stock: int = 10

class Category(BaseModel):
    id: str
    name: str
    icon: str
    item_count: int

class CartItemRequest(BaseModel):
    product_id: str
    quantity: int = 1
    selected_color: Optional[str] = None
    selected_size: Optional[str] = None

class CartItem(BaseModel):
    id: str
    product: Product
    quantity: int
    selected_color: Optional[str] = None
    selected_size: Optional[str] = None

class OrderRequest(BaseModel):
    items: List[CartItemRequest]
    full_name: str
    address: str
    city: str
    postal_code: str
    phone: str
    payment_method: str
    notes: Optional[str] = None

class OrderItem(BaseModel):
    product_id: str
    product_name: str
    unit_price: float
    quantity: int
    selected_color: Optional[str] = None
    selected_size: Optional[str] = None
    image_url: str

class Order(BaseModel):
    id: str
    created_at: str
    items: List[OrderItem]
    subtotal: float
    shipping_fee: float
    tax: float
    total_amount: float
    status: str  # "Processing", "Shipped", "Delivered"
    shipping_address: str
    full_name: str
    payment_method: str

class UserProfile(BaseModel):
    id: str
    name: str
    email: str
    avatar_url: str
    phone: str
    default_address: str

class WishlistToggleRequest(BaseModel):
    product_id: str
