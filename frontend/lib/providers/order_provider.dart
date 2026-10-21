import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await ApiService.getOrders();
    } catch (e) {
      debugPrint('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderModel?> placeOrder({
    required List<CartItem> items,
    required String fullName,
    required String address,
    required String city,
    required String postalCode,
    required String phone,
    required String paymentMethod,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newOrder = await ApiService.createOrder(
        items: items,
        fullName: fullName,
        address: address,
        city: city,
        postalCode: postalCode,
        phone: phone,
        paymentMethod: paymentMethod,
      );

      if (newOrder != null) {
        _orders.insert(0, newOrder);
        notifyListeners();
        return newOrder;
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
