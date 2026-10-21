from fastapi import APIRouter
from typing import List
import database
from models import UserProfile, Product, WishlistToggleRequest

router = APIRouter(prefix="/api/user", tags=["User & Wishlist"])

@router.get("/profile", response_model=UserProfile)
def get_user_profile():
    return database.USER_PROFILE

@router.get("/wishlist", response_model=List[Product])
def get_wishlist():
    wishlist_products = [
        p for p in database.PRODUCTS
        if p.id in database.WISHLIST_IDS
    ]
    return wishlist_products

@router.post("/wishlist/toggle")
def toggle_wishlist(request: WishlistToggleRequest):
    prod_id = request.product_id
    if prod_id in database.WISHLIST_IDS:
        database.WISHLIST_IDS.remove(prod_id)
        is_favorite = False
    else:
        database.WISHLIST_IDS.append(prod_id)
        is_favorite = True

    return {
        "product_id": prod_id,
        "is_favorite": is_favorite,
        "wishlist_count": len(database.WISHLIST_IDS)
    }
