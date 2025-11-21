import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/dialog/start_bot_dialog.dart';
import 'package:provider/provider.dart';

import 'api/account.dart';
import 'api/bot_provider.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountsModel>(
      builder: (context, accountsModel, child) {
        // Show loading indicator when fetching data
        if (accountsModel.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading accounts...'),
              ],
            ),
          );
        }

        // Show error state with retry option
        if (accountsModel.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Accounts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    accountsModel.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => accountsModel.fetchAccounts(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty state when no accounts are available
        if (accountsModel.accounts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Accounts Available',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'There are no accounts configured yet.\nAdd accounts to get started.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => accountsModel.fetchAccounts(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show list of accounts with pull-to-refresh
        return RefreshIndicator(
          onRefresh: () => accountsModel.fetchAccounts(),
          child: ListView.builder(
            itemCount: accountsModel.accounts.length,
            itemBuilder: (context, index) {
              var account = accountsModel.accounts[index];
              return ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.play_circle),
                  onPressed: () => _showStartBotDialog(context, account),
                  tooltip: 'Start Bot',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                  tooltip: 'Edit Account',
                ),
                title: Text(account.username),
                subtitle: Text(account.id),
              );
            },
          ),
        );
      },
    );
  }

  void _showStartBotDialog(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (context) {
        return StartBotDialog(account: account);
      },
    );
  }
}
