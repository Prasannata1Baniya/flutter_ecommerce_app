import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _appliedPromoCode;
  double _discountPercentage = 0.0;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  String? get appliedPromoCode => _appliedPromoCode;

  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.totalPrice);
  double get discountAmount => subtotal * _discountPercentage;
  double get shippingFee => (subtotal > 150.0 || _items.isEmpty) ? 0.0 : 15.0;
  double get tax => (subtotal - discountAmount) * 0.08;
  double get total => (subtotal - discountAmount) + shippingFee + tax;

  CartProvider() {
    loadCart();
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await ApiService.getCart();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(Product product, {int quantity = 1, String? selectedColor, String? selectedSize}) {
    // Check if item already exists
    final index = _items.indexWhere((i) =>
      i.product.id == product.id &&
      i.selectedColor == selectedColor &&
      i.selectedSize == selectedSize
    );

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        quantity: quantity,
        selectedColor: selectedColor ?? (product.colors.isNotEmpty ? product.colors.first : null),
        selectedSize: selectedSize ?? (product.sizes.isNotEmpty ? product.sizes.first : null),
      ));
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'MINIMAL10' || cleanCode == 'CREAM10') {
      _appliedPromoCode = cleanCode;
      _discountPercentage = 0.10; // 10% OFF
      notifyListeners();
      return true;
    } else if (cleanCode == 'MAISON20') {
      _appliedPromoCode = cleanCode;
      _discountPercentage = 0.20; // 20% OFF
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }
}
