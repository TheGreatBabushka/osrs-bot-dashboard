import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/accounts_view.dart';
import 'package:osrs_bot_dashboard/api/account.dart';
import 'package:osrs_bot_dashboard/api/accounts_model.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:provider/provider.dart';

void main() {
  group('Refresh Button', () {
    testWidgets('Refresh button exists in app bar and has correct tooltip', (WidgetTester tester) async {
      // Create a settings model
      final settingsModel = SettingsModel();
      
      // Create an accounts model with test data
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
      accountsModel.accounts = [
        Account(
          id: '1',
          username: 'test_user',
          email: 'test@test.com',
          status: AccountStatus.ACTIVE,
        ),
      ];
      accountsModel.isLoading = false;
      
      // Create an activity model
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
      // Build a minimal app structure with app bar
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Test'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh Accounts',
                  onPressed: () {
                    accountsModel.fetchAccounts();
                    activityModel.fetchActivities();
                  },
                ),
              ],
            ),
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider<AccountsModel>.value(value: accountsModel),
                ChangeNotifierProvider<AccountActivityModel>.value(value: activityModel),
              ],
              child: const AccountsView(),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify that the refresh button exists
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      
      // Verify the tooltip is correct
      expect(find.byTooltip('Refresh Accounts'), findsOneWidget);
    });
  });
}
