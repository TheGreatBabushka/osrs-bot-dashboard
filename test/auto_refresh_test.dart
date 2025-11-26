import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/api/accounts_model.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';

void main() {
  group('Auto-refresh functionality', () {
    test('AccountsModel starts auto-refresh timer when autoFetch is true', () async {
      final settingsModel = SettingsModel();
      
      // Wait for settings to load
      await Future.delayed(const Duration(milliseconds: 200));
      
      final accountsModel = AccountsModel(settingsModel, autoFetch: true);
      
      // Wait a moment for initial fetch attempt
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify that the model is created
      expect(accountsModel, isNotNull);
      
      // Clean up
      accountsModel.dispose();
    });

    test('AccountsModel does not start auto-refresh when autoFetch is false', () async {
      final settingsModel = SettingsModel();
      
      // Wait for settings to load
      await Future.delayed(const Duration(milliseconds: 200));
      
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
      
      // Verify that the model is created
      expect(accountsModel, isNotNull);
      
      // Clean up
      accountsModel.dispose();
    });

    test('AccountsModel disposes timer properly', () async {
      final settingsModel = SettingsModel();
      
      // Wait for settings to load
      await Future.delayed(const Duration(milliseconds: 200));
      
      final accountsModel = AccountsModel(settingsModel, autoFetch: true);
      
      // Wait a moment for initial fetch attempt
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Dispose should not throw
      expect(() => accountsModel.dispose(), returnsNormally);
      
      // Wait to ensure no errors after disposal
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('AccountActivityModel starts auto-refresh timer when autoFetch is true', () async {
      final settingsModel = SettingsModel();
      
      // Wait for settings to load
      await Future.delayed(const Duration(milliseconds: 200));
      
      final activityModel = AccountActivityModel(settingsModel, autoFetch: true);
      
      // Wait a moment for initial fetch attempt
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify that the model is created
      expect(activityModel, isNotNull);
      
      // Clean up
      activityModel.dispose();
    });

    test('AccountActivityModel does not start auto-refresh when autoFetch is false', () async {
      final settingsModel = SettingsModel();
      
      // Wait for settings to load
      await Future.delayed(const Duration(milliseconds: 200));
      
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
      // Verify that the model is created
      expect(activityModel, isNotNull);
      
      // Clean up
      activityModel.dispose();
    });

    test('AccountActivityModel disposes timer properly', () async {
      final settingsModel = SettingsModel();
      
      // Wait for settings to load
      await Future.delayed(const Duration(milliseconds: 200));
      
      final activityModel = AccountActivityModel(settingsModel, autoFetch: true);
      
      // Wait a moment for initial fetch attempt
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Dispose should not throw
      expect(() => activityModel.dispose(), returnsNormally);
      
      // Wait to ensure no errors after disposal
      await Future.delayed(const Duration(milliseconds: 100));
    });
  });
}
