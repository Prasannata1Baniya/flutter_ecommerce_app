import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class WishlistProvider extends ChangeNotifier {
  List<Product> _wishlist = [];
  bool _isLoading = false;

  List<Product> get wishlist => _wishlist;
  bool get isLoading => _isLoading;
  int get count => _wishlist.length;

  WishlistProvider() {
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      _wishlist = await ApiService.getWishlist();
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String productId) {
    return _wishlist.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
    ApiService.toggleWishlist(product.id);
  }
}
