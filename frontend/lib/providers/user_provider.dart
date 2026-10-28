import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  UserProvider() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await ApiService.getUserProfile();
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String defaultAddress,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await ApiService.updateUserProfile(
        name: name,
        email: email,
        phone: phone,
        defaultAddress: defaultAddress,
      );
      if (updated != null) {
        _profile = updated;
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
