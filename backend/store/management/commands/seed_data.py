from django.core.management.base import BaseCommand
from store.models import Category, Product, CartItem, Order, OrderItem, UserProfile, Wishlist

class Command(BaseCommand):
    help = 'Seeds the database with minimalist luxury cream & black e-commerce sample data'

    def handle(self, *args, **kwargs):
        self.stdout.write('Seeding database...')

        # Categories
        categories_data = [
            {"id": "all", "name": "All Items", "icon": "grid_view", "item_count": 9},
            {"id": "apparel", "name": "Apparel", "icon": "checkroom", "item_count": 3},
            {"id": "home", "name": "Home & Living", "icon": "chair", "item_count": 3},
            {"id": "accessories", "name": "Accessories", "icon": "watch", "item_count": 2},
            {"id": "care", "name": "Care & Beauty", "icon": "spa", "item_count": 1},
        ]

        for cat in categories_data:
            Category.objects.update_or_create(id=cat["id"], defaults=cat)

        # Products
        products_data = [
            {
                "id": "prod_01",
                "name": "Minimalist Ceramic Vase",
                "subtitle": "Handmade Stoneware in Oat Cream",
                "price": 85.00,
                "original_price": 110.00,
                "rating": 4.9,
                "reviews_count": 42,
                "category": "home",
                "description": "Crafted by hand using coarse stoneware, this sculptural ceramic vase brings organic warmth and quiet elegance to modern living spaces. Matte unglazed exterior with a waterproof glazed interior.",
                "details": [
                    "100% Sustainable Coarse Stoneware",
                    "Height: 28cm | Diameter: 14cm",
                    "Waterproof inner glazing",
                    "Ethically handmade in Kyoto studio"
                ],
                "images": [
                    "https://images.unsplash.com/photo-1677761640321-b80251be00ca?q=80&w=687&auto=format&fit=crop&q=80&w=800,
                    "https://images.unsplash.com/photo-1677761640321-b80251be00ca?q=80&w=687&auto=format&fit=crop&q=80&w=800"
                ],
                "colors": ["#F5F2EB", "#222222", "#C2B29F"],
                "sizes": ["Standard"],
                "is_featured": True,
                "is_new": True,
                "stock": 15
            },
            {
                "id": "prod_02",
                "name": "Cashmere Oversized Knit",
                "subtitle": "100% Grade-A Mongolian Cashmere",
                "price": 240.00,
                "original_price": 290.00,
                "rating": 4.8,
                "reviews_count": 88,
                "category": "apparel",
                "description": "Indulgent softness meets timeless design. Our flagship oversized sweater features ribbed cuffs, dropped shoulders, and a relaxed silhouette dyed in warm ecru cream.",
                "details": [
                    "100% Mongolian Grade-A Cashmere",
                    "Seamless 3D knit construction",
                    "Natural temperature regulating",
                    "Dry clean or hand wash cold"
                ],
                "images": [
                    "https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&q=80&w=800",
                    "https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&q=80&w=800"
                ],
                "colors": ["#F5F0E6", "#121212", "#A2988E"],
                "sizes": ["XS", "S", "M", "L", "XL"],
                "is_featured": True,
                "is_new": False,
                "stock": 20
            },
            {
                "id": "prod_03",
                "name": "Matte Black Arch Desk Lamp",
                "subtitle": "Minimalist LED Task Light",
                "price": 160.00,
                "original_price": None,
                "rating": 4.9,
                "reviews_count": 64,
                "category": "home",
                "description": "Engineered with clean architectural lines, this dimmable LED desk lamp combines brushed aluminum and powder-coated matte black steel for warm focused illumination.",
                "details": [
                    "Powder-coated steel & anodized aluminum",
                    "3000K Warm LED continuous dimmer",
                    "Touch-sensitive brightness control",
                    "USB-C powered with braided linen cord"
                ],
                "images": [
                    "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&q=80&w=800",
                    "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&q=80&w=800"
                ],
                "colors": ["#121212", "#E2DCD3"],
                "sizes": ["Standard"],
                "is_featured": True,
                "is_new": True,
                "stock": 8
            },
            {
                "id": "prod_04",
                "name": "Structure Leather Tote",
                "subtitle": "Full Grain Calfskin Leather",
                "price": 320.00,
                "original_price": 380.00,
                "rating": 5.0,
                "reviews_count": 112,
                "category": "accessories",
                "description": "Designed for seamlessly transitioning from workday to weekend. Clean unlined interior with a detachable zip pouch and reinforced cream contrast stitching.",
                "details": [
                    "Italian vegetable-tanned calfskin",
                    "Fits up to 15-inch laptop",
                    "Magnetic top clasp closure",
                    "Protective brass feet at base"
                ],
                "images": [
                    "https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&q=80&w=800",
                    "https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&q=80&w=800"
                ],
                "colors": ["#1A1A1A", "#E6DFC8", "#5A4C3E"],
                "sizes": ["One Size"],
                "is_featured": False,
                "is_new": True,
                "stock": 12
            },
            {
                "id": "prod_05",
                "name": "Linen Tailored Trousers",
                "subtitle": "100% Organic French Flax",
                "price": 145.00,
                "original_price": 170.00,
                "rating": 4.7,
                "reviews_count": 39,
                "category": "apparel",
                "description": "Relaxed straight-leg trousers woven from premium breathable French flax linen. Elastic waistband with internal drawstring and wide leg hem.",
                "details": [
                    "100% Organic French Flax Linen",
                    "Pre-washed for supple softness",
                    "High-waisted tailored fit",
                    "Side seam deep pockets"
                ],
                "images": [
                    "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&q=80&w=800",
                    "https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&q=80&w=800"
                ],
                "colors": ["#EBE5D8", "#171717"],
                "sizes": ["S", "M", "L"],
                "is_featured": False,
                "is_new": False,
                "stock": 18
            },
            {
                "id": "prod_06",
                "name": "Monochrome Chronograph",
                "subtitle": "Sapphire Glass & Leather Strap",
                "price": 195.00,
                "original_price": 230.00,
                "rating": 4.9,
                "reviews_count": 57,
                "category": "accessories",
                "description": "Stripped of unnecessary ornament, this minimalist timepiece features a stark matte dial, Japanese quartz movement, and a supple cream calfskin band.",
                "details": [
                    "40mm 316L Stainless Steel Case",
                    "Scratch-resistant Sapphire Crystal",
                    "5 ATM Water Resistance",
                    "Quick-release Italian Leather Strap"
                ],
                "images": [
                    "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=800",
                    "https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&q=80&w=800"
                ],
                "colors": ["#121212", "#EDE5D8"],
                "sizes": ["40mm"],
                "is_featured": True,
                "is_new": False,
                "stock": 10
            }
        ]

        for p in products_data:
            Product.objects.update_or_create(id=p["id"], defaults=p)

        # Profile
        UserProfile.objects.update_or_create(
            id='usr_1',
            defaults={
                'name': 'Aarav Sharma',
                'email': 'aarav.sharma@maison.np',
                'avatar_url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
                'phone': '+977 9801234567',
                'default_address': 'Lazimpat, Kathmandu'
            }
        )

        # Wishlist Initial
        prod_01 = Product.objects.get(id="prod_01")
        prod_03 = Product.objects.get(id="prod_03")
        Wishlist.objects.get_or_create(product=prod_01)
        Wishlist.objects.get_or_create(product=prod_03)

        # Cart Initial
        CartItem.objects.update_or_create(
            id="cart_01",
            defaults={
                "product": prod_01,
                "quantity": 1,
                "selected_color": "#F5F2EB",
                "selected_size": "Standard"
            }
        )

        # Initial Order
        order_01, created = Order.objects.update_or_create(
            id="ORD-84920",
            defaults={
                "subtotal": 240.00,
                "shipping_fee": 0.00,
                "tax": 19.20,
                "total_amount": 259.20,
                "status": "Delivered",
                "shipping_address": "Lazimpat, Kathmandu",
                "full_name": "Aarav Sharma",
                "payment_method": "eSewa Digital Wallet"
            }
        )
        if created:
            OrderItem.objects.create(
                order=order_01,
                product_id="prod_02",
                product_name="Cashmere Oversized Knit",
                unit_price=240.00,
                quantity=1,
                selected_color="#F5F0E6",
                selected_size="M",
                image_url="https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&q=80&w=800"
            )

        self.stdout.write(self.style.SUCCESS('Successfully seeded Django e-commerce database!'))
