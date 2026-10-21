import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/user_profile.dart';

class ApiService {
  static bool get isTestEnvironment =>
      !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  // Base URL for Python Backend (FastAPI)
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  // Helper method for GET requests with fallback
  static Future<dynamic> _get(String endpoint) async {
    if (isTestEnvironment) {
      return null; // Skip live network call in widget test environment
    }
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(uri).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('ApiService GET $endpoint offline/fallback: $e');
    }
    return null;
  }

  // Fetch Categories
  static Future<List<CategoryItem>> getCategories() async {
    final json = await _get('/api/categories');
    if (json != null && json is List) {
      return json.map((c) => CategoryItem.fromJson(c)).toList();
    }
    // Fallback Mock
    return [
      CategoryItem(id: 'all', name: 'All Items', icon: 'grid_view', itemCount: 9),
      CategoryItem(id: 'apparel', name: 'Apparel', icon: 'checkroom', itemCount: 3),
      CategoryItem(id: 'home', name: 'Home & Living', icon: 'chair', itemCount: 3),
      CategoryItem(id: 'accessories', name: 'Accessories', icon: 'watch', itemCount: 2),
      CategoryItem(id: 'care', name: 'Care & Beauty', icon: 'spa', itemCount: 1),
    ];
  }

  // Fetch Products
  static Future<List<Product>> getProducts({
    String? category,
    String? search,
    bool featuredOnly = false,
  }) async {
    String query = '?';
    if (category != null && category != 'all') query += 'category=$category&';
    if (search != null && search.isNotEmpty) query += 'search=$search&';
    if (featuredOnly) query += 'featured_only=true&';

    final json = await _get('/api/products$query');
    if (json != null && json is List) {
      return json.map((p) => Product.fromJson(p)).toList();
    }

    // Offline Fallback Data
    List<Product> all = mockProducts;
    if (category != null && category != 'all') {
      all = all.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      all = all.where((p) => p.name.toLowerCase().contains(q) || p.subtitle.toLowerCase().contains(q)).toList();
    }
    if (featuredOnly) {
      all = all.where((p) => p.isFeatured).toList();
    }
    return all;
  }

  // Fetch Product by ID
  static Future<Product?> getProductById(String id) async {
    final json = await _get('/api/products/$id');
    if (json != null) {
      return Product.fromJson(json);
    }
    return mockProducts.firstWhere((p) => p.id == id, orElse: () => mockProducts.first);
  }

  // Fetch Cart Items
  static Future<List<CartItem>> getCart() async {
    final json = await _get('/api/cart');
    if (json != null && json is List) {
      return json.map((c) => CartItem.fromJson(c)).toList();
    }
    return [
      CartItem(
        id: 'cart_01',
        product: mockProducts[0],
        quantity: 1,
        selectedColor: '#F5F2EB',
        selectedSize: 'Standard',
      ),
      CartItem(
        id: 'cart_02',
        product: mockProducts[2],
        quantity: 1,
        selectedColor: '#121212',
        selectedSize: 'Standard',
      )
    ];
  }

  // Fetch Wishlist
  static Future<List<Product>> getWishlist() async {
    final json = await _get('/api/user/wishlist');
    if (json != null && json is List) {
      return json.map((p) => Product.fromJson(p)).toList();
    }
    return [mockProducts[0], mockProducts[2]];
  }

  // Toggle Wishlist Item
  static Future<bool> toggleWishlist(String productId) async {
    if (isTestEnvironment) return true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/user/wishlist/toggle'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'product_id': productId}),
      ).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_favorite'] ?? true;
      }
    } catch (e) {
      debugPrint('ApiService toggleWishlist fallback: $e');
    }
    return true;
  }

  // Fetch Orders
  static Future<List<OrderModel>> getOrders() async {
    final json = await _get('/api/orders');
    if (json != null && json is List) {
      return json.map((o) => OrderModel.fromJson(o)).toList();
    }
    return [
      OrderModel(
        id: 'ORD-84920',
        createdAt: '2026-03-01 14:22',
        items: [
          OrderItem(
            productId: 'prod_02',
            productName: 'Cashmere Oversized Knit',
            unitPrice: 240.0,
            quantity: 1,
            selectedColor: '#F5F0E6',
            selectedSize: 'M',
            imageUrl: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&q=80&w=800',
          )
        ],
        subtotal: 240.0,
        shippingFee: 0.0,
        tax: 19.20,
        totalAmount: 259.20,
        status: 'Delivered',
        shippingAddress: '742 Evergreen Terrace, Springfield',
        fullName: 'Alex Morgan',
        paymentMethod: 'Apple Pay',
      )
    ];
  }

  // Create Order
  static Future<OrderModel?> createOrder({
    required List<CartItem> items,
    required String fullName,
    required String address,
    required String city,
    required String postalCode,
    required String phone,
    required String paymentMethod,
  }) async {
    if (!isTestEnvironment) {
      try {
        final body = {
          'items': items.map((i) => {
            'product_id': i.product.id,
            'quantity': i.quantity,
            'selected_color': i.selectedColor,
            'selected_size': i.selectedSize,
          }).toList(),
          'full_name': fullName,
          'address': address,
          'city': city,
          'postal_code': postalCode,
          'phone': phone,
          'payment_method': paymentMethod,
        };

        final response = await http.post(
          Uri.parse('$baseUrl/api/orders'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        ).timeout(const Duration(seconds: 4));

        if (response.statusCode == 200 || response.statusCode == 201) {
          return OrderModel.fromJson(jsonDecode(response.body));
        }
      } catch (e) {
        debugPrint('ApiService createOrder fallback: $e');
      }
    }

    // Local fallback order generation
    double subtotal = items.fold(0, (sum, item) => sum + item.totalPrice);
    double shipping = subtotal > 150 ? 0 : 15.0;
    double tax = (subtotal * 0.08);

    return OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      createdAt: 'Just now',
      items: items.map((i) => OrderItem(
        productId: i.product.id,
        productName: i.product.name,
        unitPrice: i.product.price,
        quantity: i.quantity,
        selectedColor: i.selectedColor,
        selectedSize: i.selectedSize,
        imageUrl: i.product.images.isNotEmpty ? i.product.images[0] : '',
      )).toList(),
      subtotal: subtotal,
      shippingFee: shipping,
      tax: tax,
      totalAmount: subtotal + shipping + tax,
      status: 'Processing',
      shippingAddress: '$address, $city $postalCode',
      fullName: fullName,
      paymentMethod: paymentMethod,
    );
  }

  // Fetch User Profile
  static Future<UserProfile> getUserProfile() async {
    final json = await _get('/api/user/profile');
    if (json != null) {
      return UserProfile.fromJson(json);
    }
    return UserProfile(
      id: 'usr_1',
      name: 'Alex Morgan',
      email: 'alex.morgan@maison.com',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
      phone: '+1 (555) 234-5678',
      defaultAddress: '742 Evergreen Terrace, Springfield',
    );
  }

  // Local Static Mock Dataset
  static final List<Product> mockProducts = [
    Product(
      id: 'prod_01',
      name: 'Minimalist Ceramic Vase',
      subtitle: 'Handmade Stoneware in Oat Cream',
      price: 85.00,
      originalPrice: 110.00,
      rating: 4.9,
      reviewsCount: 42,
      category: 'home',
      description: 'Crafted by hand using coarse stoneware, this sculptural ceramic vase brings organic warmth and quiet elegance to modern living spaces. Matte unglazed exterior with a waterproof glazed interior.',
      details: [
        '100% Sustainable Coarse Stoneware',
        'Height: 28cm | Diameter: 14cm',
        'Waterproof inner glazing',
        'Ethically handmade in Kyoto studio'
      ],
      images: [
        'https://images.unsplash.com/photo-1612196808214-b7e239e5f6b7?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&q=80&w=800'
      ],
      colors: ['#F5F2EB', '#222222', '#C2B29F'],
      sizes: ['Standard'],
      isFeatured: true,
      isNew: true,
      stock: 15,
    ),
    Product(
      id: 'prod_02',
      name: 'Cashmere Oversized Knit',
      subtitle: '100% Grade-A Mongolian Cashmere',
      price: 240.00,
      originalPrice: 290.00,
      rating: 4.8,
      reviewsCount: 88,
      category: 'apparel',
      description: 'Indulgent softness meets timeless design. Our flagship oversized sweater features ribbed cuffs, dropped shoulders, and a relaxed silhouette dyed in warm ecru cream.',
      details: [
        '100% Mongolian Grade-A Cashmere',
        'Seamless 3D knit construction',
        'Natural temperature regulating',
        'Dry clean or hand wash cold'
      ],
      images: [
        'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&q=80&w=800'
      ],
      colors: ['#F5F0E6', '#121212', '#A2988E'],
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      isFeatured: true,
      isNew: false,
      stock: 20,
    ),
    Product(
      id: 'prod_03',
      name: 'Matte Black Arch Desk Lamp',
      subtitle: 'Minimalist LED Task Light',
      price: 160.00,
      originalPrice: null,
      rating: 4.9,
      reviewsCount: 64,
      category: 'home',
      description: 'Engineered with clean architectural lines, this dimmable LED desk lamp combines brushed aluminum and powder-coated matte black steel for warm focused illumination.',
      details: [
        'Powder-coated steel & anodized aluminum',
        '3000K Warm LED continuous dimmer',
        'Touch-sensitive brightness control',
        'USB-C powered with braided linen cord'
      ],
      images: [
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?auto=format&fit=crop&q=80&w=800'
      ],
      colors: ['#121212', '#E2DCD3'],
      sizes: ['Standard'],
      isFeatured: true,
      isNew: true,
      stock: 8,
    ),
    Product(
      id: 'prod_04',
      name: 'Structure Leather Tote',
      subtitle: 'Full Grain Calfskin Leather',
      price: 320.00,
      originalPrice: 380.00,
      rating: 5.0,
      reviewsCount: 112,
      category: 'accessories',
      description: 'Designed for seamlessly transitioning from workday to weekend. Clean unlined interior with a detachable zip pouch and reinforced cream contrast stitching.',
      details: [
        'Italian vegetable-tanned calfskin',
        'Fits up to 15-inch laptop',
        'Magnetic top clasp closure',
        'Protective brass feet at base'
      ],
      images: [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&q=80&w=800'
      ],
      colors: ['#1A1A1A', '#E6DFC8', '#5A4C3E'],
      sizes: ['One Size'],
      isFeatured: false,
      isNew: true,
      stock: 12,
    ),
    Product(
      id: 'prod_05',
      name: 'Linen Tailored Trousers',
      subtitle: '100% Organic French Flax',
      price: 145.00,
      originalPrice: 170.00,
      rating: 4.7,
      reviewsCount: 39,
      category: 'apparel',
      description: 'Relaxed straight-leg trousers woven from premium breathable French flax linen. Elastic waistband with internal drawstring and wide leg hem.',
      details: [
        '100% Organic French Flax Linen',
        'Pre-washed for supple softness',
        'High-waisted tailored fit',
        'Side seam deep pockets'
      ],
      images: [
        'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&q=80&w=800'
      ],
      colors: ['#EBE5D8', '#171717'],
      sizes: ['S', 'M', 'L'],
      isFeatured: false,
      isNew: false,
      stock: 18,
    ),
    Product(
      id: 'prod_06',
      name: 'Monochrome Chronograph',
      subtitle: 'Sapphire Glass & Leather Strap',
      price: 195.00,
      originalPrice: 230.00,
      rating: 4.9,
      reviewsCount: 57,
      category: 'accessories',
      description: 'Stripped of unnecessary ornament, this minimalist timepiece features a stark matte dial, Japanese quartz movement, and a supple cream calfskin band.',
      details: [
        '40mm 316L Stainless Steel Case',
        'Scratch-resistant Sapphire Crystal',
        '5 ATM Water Resistance',
        'Quick-release Italian Leather Strap'
      ],
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=80&w=800',
        'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&q=80&w=800'
      ],
      colors: ['#121212', '#EDE5D8'],
      sizes: ['40mm'],
      isFeatured: true,
      isNew: false,
      stock: 10,
    ),
  ];
}
