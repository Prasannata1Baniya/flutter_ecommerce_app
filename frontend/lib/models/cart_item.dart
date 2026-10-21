import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  final String? selectedColor;
  final String? selectedSize;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
  });

  double get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedColor: json['selected_color'],
      selectedSize: json['selected_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
    };
  }
}
