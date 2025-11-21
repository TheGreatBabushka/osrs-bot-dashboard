import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/accounts_view.dart';
import 'package:osrs_bot_dashboard/api/account.dart';
import 'package:osrs_bot_dashboard/api/accounts_model.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:provider/provider.dart';

void main() {
  group('AccountsView - Banned Accounts', () {
    testWidgets('Play button should not be shown for banned accounts', (WidgetTester tester) async {
      // Create a settings model
      final settingsModel = SettingsModel();
      
      // Create an accounts model with a banned account
      final accountsModel = AccountsModel(settingsModel);
      accountsModel.accounts = [
        Account(
          id: '1',
          username: 'banned_user',
          email: 'banned@test.com',
          status: AccountStatus.BANNED,
        ),
      ];
      accountsModel.isLoading = false;
      
      // Create an activity model
      final activityModel = AccountActivityModel(settingsModel);
      
      // Build the widget with providers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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
      
      // Verify that the account is displayed
      expect(find.text('banned_user'), findsOneWidget);
      
      // Verify that the play button is NOT shown
      expect(find.byIcon(Icons.play_circle), findsNothing);
      expect(find.byIcon(Icons.stop_circle), findsNothing);
      
      // Verify that the edit button is still shown
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('Play button should be shown for active accounts', (WidgetTester tester) async {
      // Create a settings model
      final settingsModel = SettingsModel();
      
      // Create an accounts model with an active account
      final accountsModel = AccountsModel(settingsModel);
      accountsModel.accounts = [
        Account(
          id: '2',
          username: 'active_user',
          email: 'active@test.com',
          status: AccountStatus.ACTIVE,
        ),
      ];
      accountsModel.isLoading = false;
      
      // Create an activity model
      final activityModel = AccountActivityModel(settingsModel);
      
      // Build the widget with providers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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
      
      // Verify that the account is displayed
      expect(find.text('active_user'), findsOneWidget);
      
      // Verify that the play button IS shown
      expect(find.byIcon(Icons.play_circle), findsOneWidget);
      
      // Verify that the edit button is shown
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('Play button should be shown for inactive accounts', (WidgetTester tester) async {
      // Create a settings model
      final settingsModel = SettingsModel();
      
      // Create an accounts model with an inactive account
      final accountsModel = AccountsModel(settingsModel);
      accountsModel.accounts = [
        Account(
          id: '3',
          username: 'inactive_user',
          email: 'inactive@test.com',
          status: AccountStatus.INACTIVE,
        ),
      ];
      accountsModel.isLoading = false;
      
      // Create an activity model
      final activityModel = AccountActivityModel(settingsModel);
      
      // Build the widget with providers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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
      
      // Verify that the account is displayed
      expect(find.text('inactive_user'), findsOneWidget);
      
      // Verify that the play button IS shown
      expect(find.byIcon(Icons.play_circle), findsOneWidget);
      
      // Verify that the edit button is shown
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('Multiple accounts with mixed statuses', (WidgetTester tester) async {
      // Create a settings model
      final settingsModel = SettingsModel();
      
      // Create an accounts model with mixed status accounts
      final accountsModel = AccountsModel(settingsModel);
      accountsModel.accounts = [
        Account(
          id: '1',
          username: 'active_user',
          email: 'active@test.com',
          status: AccountStatus.ACTIVE,
        ),
        Account(
          id: '2',
          username: 'banned_user',
          email: 'banned@test.com',
          status: AccountStatus.BANNED,
        ),
        Account(
          id: '3',
          username: 'inactive_user',
          email: 'inactive@test.com',
          status: AccountStatus.INACTIVE,
        ),
      ];
      accountsModel.isLoading = false;
      
      // Create an activity model
      final activityModel = AccountActivityModel(settingsModel);
      
      // Build the widget with providers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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
      
      // Verify all accounts are displayed
      expect(find.text('active_user'), findsOneWidget);
      expect(find.text('banned_user'), findsOneWidget);
      expect(find.text('inactive_user'), findsOneWidget);
      
      // Should have 2 play buttons (active and inactive, not banned)
      expect(find.byIcon(Icons.play_circle), findsNWidgets(2));
      
      // All accounts should have edit buttons
      expect(find.byIcon(Icons.edit), findsNWidgets(3));
    });
  });
}
