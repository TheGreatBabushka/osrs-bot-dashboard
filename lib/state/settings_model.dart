import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  static const String _apiIpKey = 'api_ip';
  static const String _defaultApiIp = 'http://localhost:8080';

  String _apiIp = _defaultApiIp;
  bool _isLoading = true;

  String get apiIp => _apiIp;
  bool get isLoading => _isLoading;

  SettingsModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _apiIp = prefs.getString(_apiIpKey) ?? _defaultApiIp;
    } catch (e) {
      debugPrint('Error loading settings: $e');
      _apiIp = _defaultApiIp;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setApiIp(String newApiIp) async {
    if (newApiIp.isEmpty) {
      return;
    }

    // Basic URL validation
    if (!newApiIp.startsWith('http://') && !newApiIp.startsWith('https://')) {
      debugPrint('Error: API IP must start with http:// or https://');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_apiIpKey, newApiIp);
      _apiIp = newApiIp;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving API IP: $e');
    }
  }

  Future<void> resetToDefault() async {
    await setApiIp(_defaultApiIp);
  }
}
