from typing import List, Dict, Optional
import uuid
from datetime import datetime
from models import Product, Category, Order, UserProfile

CATEGORIES: List[Category] = [
    Category(id="all", name="All Items", icon="grid_view", item_count=9),
    Category(id="apparel", name="Apparel", icon="checkroom", item_count=3),
    Category(id="home", name="Home & Living", icon="chair", item_count=3),
    Category(id="accessories", name="Accessories", icon="watch", item_count=2),
    Category(id="care", name="Care & Beauty", icon="spa", item_count=1),
]

PRODUCTS: List[Product] = [
    Product(
        id="prod_01",
        name="Minimalist Ceramic Vase",
        subtitle="Handmade Stoneware in Oat Cream",
        price=85.00,
        original_price=110.00,
        rating=4.9,
        reviews_count=42,
        category="home",
        description="Crafted by hand using coarse stoneware, this sculptural ceramic vase brings organic warmth and quiet elegance to modern living spaces. Matte unglazed exterior with a waterproof glazed interior.",
        details=[
            "100% Sustainable Coarse Stoneware",
            "Height: 28cm | Diameter: 14cm",
            "Waterproof inner glazing",
            "Ethically handmade in Kyoto studio"
        ],
        images=[
            "https://images.unsplash.com/photo-1612196808214-b7e239e5f6b7?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#F5F2EB", "#222222", "#C2B29F"],
        sizes=["Standard"],
        is_featured=True,
        is_new=True,
        stock=15
    ),
    Product(
        id="prod_02",
        name="Cashmere Oversized Knit",
        subtitle="100% Grade-A Mongolian Cashmere",
        price=240.00,
        original_price=290.00,
        rating=4.8,
        reviews_count=88,
        category="apparel",
        description="Indulgent softness meets timeless design. Our flagship oversized sweater features ribbed cuffs, dropped shoulders, and a relaxed silhouette dyed in warm ecru cream.",
        details=[
            "100% Mongolian Grade-A Cashmere",
            "Seamless 3D knit construction",
            "Natural temperature regulating",
            "Dry clean or hand wash cold"
        ],
        images=[
            "https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#F5F0E6", "#121212", "#A2988E"],
        sizes=["XS", "S", "M", "L", "XL"],
        is_featured=True,
        is_new=False,
        stock=20
    ),
    Product(
        id="prod_03",
        name="Matte Black Arch Desk Lamp",
        subtitle="Minimalist LED Task Light",
        price=160.00,
        original_price=None,
        rating=4.9,
        reviews_count=64,
        category="home",
        description="Engineered with clean architectural lines, this dimmable LED desk lamp combines brushed aluminum and powder-coated matte black steel for warm focused illumination.",
        details=[
            "Powder-coated steel & anodized aluminum",
            "3000K Warm LED continuous dimmer",
            "Touch-sensitive brightness control",
            "USB-C powered with braided linen cord"
        ],
        images=[
            "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#121212", "#E2DCD3"],
        sizes=["Standard"],
        is_featured=True,
        is_new=True,
        stock=8
    ),
    Product(
        id="prod_04",
        name="Structure Leather Tote",
        subtitle="Full Grain Calfskin Leather",
        price=320.00,
        original_price=380.00,
        rating=5.0,
        reviews_count=112,
        category="accessories",
        description="Designed for seamlessly transitioning from workday to weekend. Clean unlined interior with a detachable zip pouch and reinforced cream contrast stitching.",
        details=[
            "Italian vegetable-tanned calfskin",
            "Fits up to 15-inch laptop",
            "Magnetic top clasp closure",
            "Protective brass feet at base"
        ],
        images=[
            "https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#1A1A1A", "#E6DFC8", "#5A4C3E"],
        sizes=["One Size"],
        is_featured=False,
        is_new=True,
        stock=12
    ),
    Product(
        id="prod_05",
        name="Linen Tailored Trousers",
        subtitle="100% Organic French Flax",
        price=145.00,
        original_price=170.00,
        rating=4.7,
        reviews_count=39,
        category="apparel",
        description="Relaxed straight-leg trousers woven from premium breathable French flax linen. Elastic waistband with internal drawstring and wide leg hem.",
        details=[
            "100% Organic French Flax Linen",
            "Pre-washed for supple softness",
            "High-waisted tailored fit",
            "Side seam deep pockets"
        ],
        images=[
            "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#EBE5D8", "#171717"],
        sizes=["S", "M", "L"],
        is_featured=False,
        is_new=False,
        stock=18
    ),
    Product(
        id="prod_06",
        name="Monochrome Chronograph",
        subtitle="Sapphire Glass & Leather Strap",
        price=195.00,
        original_price=230.00,
        rating=4.9,
        reviews_count=57,
        category="accessories",
        description="Stripped of unnecessary ornament, this minimalist timepiece features a stark matte dial, Japanese quartz movement, and a supple cream calfskin band.",
        details=[
            "40mm 316L Stainless Steel Case",
            "Scratch-resistant Sapphire Crystal",
            "5 ATM Water Resistance",
            "Quick-release Italian Leather Strap"
        ],
        images=[
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#121212", "#EDE5D8"],
        sizes=["40mm"],
        is_featured=True,
        is_new=False,
        stock=10
    ),
    Product(
        id="prod_07",
        name="Artisan Ceramic Pour Pitcher",
        subtitle="Speckled Cream Matte Stoneware",
        price=65.00,
        original_price=None,
        rating=4.8,
        reviews_count=23,
        category="home",
        description="Perfect for slow morning rituals. Designed with an ergonomic spout and tactile satin glaze that feels smooth in hand.",
        details=[
            "Dishwasher & microwave safe stoneware",
            "Capacity: 650ml / 22 oz",
            "Speckled cream glaze with unglazed base"
        ],
        images=[
            "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1577968897966-3d4325b36b61?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#F0EAD6"],
        sizes=["650ml"],
        is_featured=False,
        is_new=True,
        stock=25
    ),
    Product(
        id="prod_08",
        name="Botanical Cleansing Elixir",
        subtitle="Cedarwood & Bergamot Essential Oils",
        price=48.00,
        original_price=None,
        rating=4.9,
        reviews_count=91,
        category="care",
        description="Nourishing botanical body gel infused with cold-pressed jojoba, cedarwood, and wild bergamot. Housed in a reusable glass dispenser.",
        details=[
            "100% Vegan & Cruelty-Free",
            "Free from parabens & synthetic fragrance",
            "Amber UV-protective amber glass bottle",
            "Made in small batches"
        ],
        images=[
            "https://images.unsplash.com/photo-1608248597263-00079996576b?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["# Amber Glass"],
        sizes=["500ml"],
        is_featured=False,
        is_new=False,
        stock=30
    ),
    Product(
        id="prod_09",
        name="Relaxed Cotton Poplin Shirt",
        subtitle="Crisp Organic Crisp Cotton",
        price=110.00,
        original_price=135.00,
        rating=4.6,
        reviews_count=45,
        category="apparel",
        description="Essential classic button-down constructed from crisp, lightweight organic cotton poplin. Designed with mother-of-pearl buttons and curved hemline.",
        details=[
            "100% GOTS Certified Organic Cotton",
            "Natural Mother-of-Pearl buttons",
            "Tailored collar & barrel cuffs",
            "Pre-shrunk fabric finish"
        ],
        images=[
            "https://images.unsplash.com/photo-1598033129183-c4f50c736f10?auto=format&fit=crop&q=80&w=800",
            "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&q=80&w=800"
        ],
        colors=["#F7F5F0", "#181818"],
        sizes=["S", "M", "L", "XL"],
        is_featured=False,
        is_new=True,
        stock=14
    )
]

# Initial State
WISHLIST_IDS: List[str] = ["prod_01", "prod_03"]
CART_ITEMS: List[Dict] = [
    {
        "id": "cart_01",
        "product_id": "prod_01",
        "quantity": 1,
        "selected_color": "#F5F2EB",
        "selected_size": "Standard"
    },
    {
        "id": "cart_02",
        "product_id": "prod_03",
        "quantity": 1,
        "selected_color": "#121212",
        "selected_size": "Standard"
    }
]

ORDERS: List[Order] = [
    Order(
        id="ORD-84920",
        created_at="2026-03-01 14:22",
        items=[
            {
                "product_id": "prod_02",
                "product_name": "Cashmere Oversized Knit",
                "unit_price": 240.00,
                "quantity": 1,
                "selected_color": "#F5F0E6",
                "selected_size": "M",
                "image_url": "https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&q=80&w=800"
            }
        ],
        subtotal=240.00,
        shipping_fee=0.00,
        tax=19.20,
        total_amount=259.20,
        status="Delivered",
        shipping_address="742 Evergreen Terrace, Springfield",
        full_name="Alex Morgan",
        payment_method="Apple Pay"
    )
]

USER_PROFILE = UserProfile(
    id="usr_1",
    name="Alex Morgan",
    email="alex.morgan@maison.com",
    avatar_url="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400",
    phone="+1 (555) 234-5678",
    default_address="742 Evergreen Terrace, Suite 4B, Springfield"
)
