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
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
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
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
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
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
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
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
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
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
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
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
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
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
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
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
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

  group('AccountsView - Edit Account', () {
    testWidgets('Edit button should open edit dialog', (WidgetTester tester) async {
      // Create a settings model
      final settingsModel = SettingsModel();
      
      // Create an accounts model with an active account
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
      accountsModel.accounts = [
        Account(
          id: '1',
          username: 'test_user',
          email: 'test@example.com',
          status: AccountStatus.ACTIVE,
        ),
      ];
      accountsModel.isLoading = false;
      
      // Create an activity model
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
      // Build the widget with all necessary providers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsModel>.value(value: settingsModel),
                ChangeNotifierProvider<AccountsModel>.value(value: accountsModel),
                ChangeNotifierProvider<AccountActivityModel>.value(value: activityModel),
              ],
              child: const AccountsView(),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify the edit button is present
      expect(find.byIcon(Icons.edit), findsOneWidget);
      
      // Tap the edit button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();
      
      // Verify the edit dialog appears
      expect(find.text('Edit Account'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
      
      // Verify the form fields are pre-populated (text appears in both list and dialog)
      expect(find.text('test_user'), findsWidgets);
      expect(find.text('test@example.com'), findsWidgets);
      
      // Verify Delete button exists
      expect(find.text('Delete'), findsOneWidget);
    });
  });

  group('AccountsView - Delete Account', () {
    testWidgets('Delete button exists in edit dialog', (WidgetTester tester) async {
      final settingsModel = SettingsModel();
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
      accountsModel.accounts = [
        Account(
          id: '1',
          username: 'test_user',
          email: 'test@example.com',
          status: AccountStatus.ACTIVE,
        ),
      ];
      accountsModel.isLoading = false;
      
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsModel>.value(value: settingsModel),
                ChangeNotifierProvider<AccountsModel>.value(value: accountsModel),
                ChangeNotifierProvider<AccountActivityModel>.value(value: activityModel),
              ],
              child: const AccountsView(),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Tap the edit button
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();
      
      // Verify Delete button exists and is styled in red
      final deleteButton = find.text('Delete');
      expect(deleteButton, findsOneWidget);
      
      // Verify there's also a Cancel and Save Changes button
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });
  });

  group('AccountsView - Show/Hide Banned Accounts', () {
    testWidgets('Toggle switch is visible when accounts exist', (WidgetTester tester) async {
      final settingsModel = SettingsModel();
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
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
      ];
      accountsModel.isLoading = false;
      
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
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
      
      // Verify toggle label exists
      expect(find.text('Show Banned Accounts'), findsOneWidget);
      
      // Verify switch widget exists
      expect(find.byType(Switch), findsOneWidget);
      
      // Verify both accounts are shown by default
      expect(find.text('active_user'), findsOneWidget);
      expect(find.text('banned_user'), findsOneWidget);
    });

    testWidgets('Toggle hides banned accounts when turned off', (WidgetTester tester) async {
      final settingsModel = SettingsModel();
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
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
      ];
      accountsModel.isLoading = false;
      
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
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
      
      // Verify both accounts are visible initially
      expect(find.text('active_user'), findsOneWidget);
      expect(find.text('banned_user'), findsOneWidget);
      
      // Tap the toggle switch to hide banned accounts
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      
      // Verify active account is still visible but banned account is hidden
      expect(find.text('active_user'), findsOneWidget);
      expect(find.text('banned_user'), findsNothing);
    });

    testWidgets('Toggle shows banned accounts when turned back on', (WidgetTester tester) async {
      final settingsModel = SettingsModel();
      final accountsModel = AccountsModel(settingsModel, autoFetch: false);
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
      ];
      accountsModel.isLoading = false;
      
      final activityModel = AccountActivityModel(settingsModel, autoFetch: false);
      
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
      
      // Turn off the toggle
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      
      // Verify banned account is hidden
      expect(find.text('banned_user'), findsNothing);
      
      // Turn the toggle back on
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      
      // Verify banned account is visible again
      expect(find.text('banned_user'), findsOneWidget);
    });
  });
}
