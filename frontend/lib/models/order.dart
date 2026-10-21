class OrderItem {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedColor: json['selected_color'],
      selectedSize: json['selected_size'],
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class OrderModel {
  final String id;
  final String createdAt;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String fullName;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.fullName,
    required this.paymentMethod,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      createdAt: json['created_at'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shipping_fee'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Processing',
      shippingAddress: json['shipping_address'] ?? '',
      fullName: json['full_name'] ?? '',
      paymentMethod: json['payment_method'] ?? 'Credit Card',
    );
  }
}
