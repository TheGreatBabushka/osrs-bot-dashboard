import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/account_info_page.dart';
import 'package:osrs_bot_dashboard/dialog/start_bot_dialog.dart';
import 'package:provider/provider.dart';

import 'api/account.dart';
import 'api/account_activity.dart';
import 'api/accounts_model.dart';
import 'model/activity_model.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountsModel, AccountActivityModel>(
      builder: (context, accountsModel, activityModel, child) {
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
          onRefresh: () async {
            await accountsModel.fetchAccounts();
            activityModel.fetchActivities();
          },
          child: ListView.builder(
            itemCount: accountsModel.accounts.length,
            itemBuilder: (context, index) {
              var account = accountsModel.accounts[index];
              var activity = _getActivityForAccount(activityModel, account);
              var isRunning = _isAccountRunning(activity);

              return ListTile(
                leading: account.status == AccountStatus.BANNED
                    ? const IconButton(onPressed: null, icon: Icon(Icons.block, color: Colors.red))
                    : IconButton(
                        icon: Icon(
                          isRunning ? Icons.stop_circle : Icons.play_circle,
                          color: isRunning ? Colors.red : Colors.green,
                        ),
                        onPressed: isRunning ? null : () => _showStartBotDialog(context, account),
                        tooltip: isRunning ? 'Bot Running' : 'Start Bot',
                      ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                  tooltip: 'Edit Account',
                ),
                title: Text(account.username),
                subtitle: _buildAccountSubtitle(account, activity),
                onTap: () => _navigateToAccountInfo(context, account),
              );
            },
          ),
        );
      },
    );
  }

  String _getStatusLabel(AccountStatus status) {
    switch (status) {
      case AccountStatus.ACTIVE:
        return 'Active';
      case AccountStatus.INACTIVE:
        return 'Inactive';
      case AccountStatus.BANNED:
        return 'Banned';
      default:
        return 'Unknown';
    }
  }

  AccountActivity? _getActivityForAccount(AccountActivityModel activityModel, Account account) {
    try {
      return activityModel.activities.firstWhere(
        (activity) => activity.accountId.toString() == account.id,
      );
    } catch (e) {
      return null;
    }
  }

  bool _isAccountRunning(AccountActivity? activity) {
    if (activity == null) return false;

    var startedTime = DateTime.tryParse(activity.startedAt);
    var endedTime = DateTime.tryParse(activity.stoppedAt);

    if (startedTime == null) return false;

    // If stopped time is null or before/same as started time, it's running
    if (endedTime == null ||
        endedTime.isBefore(startedTime) ||
        endedTime.isAtSameMomentAs(startedTime)) {
      return true;
    }

    return false;
  }

  Widget _buildAccountSubtitle(Account account, AccountActivity? activity) {
    var statusText = '${account.id} • ${_getStatusLabel(account.status)}';

    if (activity != null && _isAccountRunning(activity)) {
      var command = activity.command;
      var commandParts = command.split(' ');
      var scriptName = commandParts.isNotEmpty ? commandParts.first : 'Unknown';

      var startedTime = DateTime.tryParse(activity.startedAt);
      var runtimeText = '';
      if (startedTime != null) {
        var runtime = DateTime.now().difference(startedTime);
        runtimeText = _formatRuntime(runtime);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(statusText),
          Text(
            '🟢 Running: $scriptName${runtimeText.isNotEmpty ? ' • $runtimeText' : ''}',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (activity != null) {
      var command = activity.command;
      var commandParts = command.split(' ');
      var scriptName = commandParts.isNotEmpty ? commandParts.first : 'Unknown';

      var endedTime = DateTime.tryParse(activity.stoppedAt);
      var stoppedText = '';
      if (endedTime != null) {
        var timeSince = DateTime.now().difference(endedTime);
        stoppedText = _formatTimeSince(timeSince);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(statusText),
          Text(
            '⚫ Last ran: $scriptName${stoppedText.isNotEmpty ? ' • $stoppedText' : ''}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      );
    }

    return Text(statusText);
  }

  String _formatRuntime(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  String _formatTimeSince(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  void _showStartBotDialog(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (context) {
        return StartBotDialog(account: account);
      },
    );
  }

  void _navigateToAccountInfo(BuildContext context, Account account) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccountInfoPage(account: account),
      ),
    );
  }
}
