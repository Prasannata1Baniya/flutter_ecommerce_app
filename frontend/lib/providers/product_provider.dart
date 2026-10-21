import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<CategoryItem> _categories = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String _sortBy = 'featured'; // 'featured', 'price_low', 'price_high', 'rating'
  bool _isLoading = false;

  List<Product> get products => _filteredAndSortedProducts();
  List<Product> get featuredProducts => _featuredProducts;
  List<CategoryItem> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get isLoading => _isLoading;

  ProductProvider() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await ApiService.getCategories();
      _products = await ApiService.getProducts();
      _featuredProducts = _products.where((p) => p.isFeatured).toList();
    } catch (e) {
      debugPrint('Error loading initial product data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  List<Product> _filteredAndSortedProducts() {
    List<Product> list = List.from(_products);

    // Filter by Category
    if (_selectedCategoryId != 'all') {
      list = list.where((p) => p.category.toLowerCase() == _selectedCategoryId.toLowerCase()).toList();
    }

    // Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.subtitle.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q)
      ).toList();
    }

    // Sort
    if (_sortBy == 'price_low') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price_high') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }
}
