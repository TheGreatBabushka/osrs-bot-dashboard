import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsModel', () {
    setUp(() {
      // Initialize shared preferences with empty values for each test
      SharedPreferences.setMockInitialValues({});
    });

    test('initial API IP is default value', () async {
      final model = SettingsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(model.apiIp, equals('http://localhost:8080'));
      expect(model.isLoading, isFalse);
    });

    test('can set and persist API IP', () async {
      final model = SettingsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Set a new API IP
      await model.setApiIp('http://192.168.1.100:8080');
      
      expect(model.apiIp, equals('http://192.168.1.100:8080'));
      
      // Create a new model instance to verify persistence
      final newModel = SettingsModel();
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(newModel.apiIp, equals('http://192.168.1.100:8080'));
    });

    test('can reset to default', () async {
      final model = SettingsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Set a custom API IP
      await model.setApiIp('http://custom.server:8080');
      expect(model.apiIp, equals('http://custom.server:8080'));
      
      // Reset to default
      await model.resetToDefault();
      expect(model.apiIp, equals('http://localhost:8080'));
    });

    test('ignores empty API IP', () async {
      final model = SettingsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final originalIp = model.apiIp;
      
      // Try to set empty API IP
      await model.setApiIp('');
      
      // Verify it was not changed
      expect(model.apiIp, equals(originalIp));
    });
  });
}
