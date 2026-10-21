class Product {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final String category;
  final String description;
  final List<String> details;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;
  final bool isFeatured;
  final bool isNew;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    required this.description,
    required this.details,
    required this.images,
    required this.colors,
    required this.sizes,
    this.isFeatured = false,
    this.isNew = false,
    this.stock = 10,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
      category: json['category'] ?? 'all',
      description: json['description'] ?? '',
      details: List<String>.from(json['details'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      isFeatured: json['is_featured'] ?? false,
      isNew: json['is_new'] ?? false,
      stock: (json['stock'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'price': price,
      'original_price': originalPrice,
      'rating': rating,
      'reviews_count': reviewsCount,
      'category': category,
      'description': description,
      'details': details,
      'images': images,
      'colors': colors,
      'sizes': sizes,
      'is_featured': isFeatured,
      'is_new': isNew,
      'stock': stock,
    };
  }
}

class CategoryItem {
  final String id;
  final String name;
  final String icon;
  final int itemCount;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.itemCount,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'grid_view',
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );
  }
}
