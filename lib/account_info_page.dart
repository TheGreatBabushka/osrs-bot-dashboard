import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/account.dart';

class AccountInfoPage extends StatelessWidget {
  final Account account;

  const AccountInfoPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.username),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(context, 'Username', account.username),
                    const Divider(),
                    _buildInfoRow(context, 'Email', account.email),
                    const Divider(),
                    _buildInfoRow(context, 'Account ID', account.id),
                    const Divider(),
                    _buildStatusRow(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (account.status) {
      case AccountStatus.ACTIVE:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Active';
        break;
      case AccountStatus.INACTIVE:
        statusColor = Colors.grey;
        statusIcon = Icons.pause_circle;
        statusText = 'Inactive';
        break;
      case AccountStatus.BANNED:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Banned';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Status',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
