from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional
import database
from models import Product, Category

router = APIRouter(prefix="/api", tags=["Products"])

@router.get("/categories", response_model=List[Category])
def get_categories():
    return database.CATEGORIES

@router.get("/products", response_model=List[Product])
def get_products(
    category: Optional[str] = None,
    search: Optional[str] = None,
    featured_only: bool = False,
    sort_by: Optional[str] = None
):
    results = database.PRODUCTS.copy()

    if category and category != "all":
        results = [p for p in results if p.category.lower() == category.lower()]

    if search:
        query = search.lower()
        results = [
            p for p in results
            if query in p.name.lower() or query in p.subtitle.lower() or query in p.description.lower()
        ]

    if featured_only:
        results = [p for p in results if p.is_featured]

    if sort_by == "price_low":
        results.sort(key=lambda x: x.price)
    elif sort_by == "price_high":
        results.sort(key=lambda x: x.price, reverse=True)
    elif sort_by == "rating":
        results.sort(key=lambda x: x.rating, reverse=True)

    return results

@router.get("/products/{product_id}", response_model=Product)
def get_product(product_id: str):
    for product in database.PRODUCTS:
        if product.id == product_id:
            return product
    raise HTTPException(status_code=404, detail="Product not found")
