import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/account.dart';
import 'package:osrs_bot_dashboard/card/levels_card.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:osrs_bot_dashboard/account_activity_item.dart';
import 'package:provider/provider.dart';

class AccountInfoPage extends StatefulWidget {
  final Account account;

  const AccountInfoPage({super.key, required this.account});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  bool _isActivityExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.username),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                      _buildInfoRow(context, 'Username', widget.account.username),
                      const Divider(),
                      _buildInfoRow(context, 'Email', widget.account.email),
                      const Divider(),
                      _buildInfoRow(context, 'Account ID', widget.account.id),
                      const Divider(),
                      _buildStatusRow(context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LevelsCard(accountId: widget.account.id),
              const SizedBox(height: 16),
              _buildActivityCard(context),
            ],
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (widget.account.status) {
      case AccountStatus.ACTIVE:
        statusColor = colorScheme.primary;
        statusIcon = Icons.check_circle;
        statusText = 'Active';
        break;
      case AccountStatus.INACTIVE:
        statusColor = colorScheme.onSurfaceVariant;
        statusIcon = Icons.pause_circle;
        statusText = 'Inactive';
        break;
      case AccountStatus.BANNED:
        statusColor = colorScheme.error;
        statusIcon = Icons.cancel;
        statusText = 'Banned';
        break;
      default:
        statusColor = colorScheme.onSurfaceVariant;
        statusIcon = Icons.help_outline;
        statusText = 'Unknown';
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

  Widget _buildActivityCard(BuildContext context) {
    final activityModel = Provider.of<AccountActivityModel>(context);

    // Filter activities for this specific account
    final accountActivities = activityModel.activities
        .where((activity) => activity.accountId.toString() == widget.account.id)
        .toList();

    // Sort by started time (most recent first)
    accountActivities.sort((a, b) {
      final aTime = DateTime.tryParse(a.startedAt);
      final bTime = DateTime.tryParse(b.startedAt);

      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;

      return bTime.compareTo(aTime); // Most recent first
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isActivityExpanded = !_isActivityExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isActivityExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Activity History',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => activityModel.fetchActivities(),
                    tooltip: 'Refresh Activities',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
            if (_isActivityExpanded) ...[
              const SizedBox(height: 12),
              if (accountActivities.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No activity history',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: accountActivities.length,
                  itemBuilder: (context, index) {
                    final activity = accountActivities[index];
                    return AccountActivityItem(
                      account: widget.account,
                      activity: activity,
                    );
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
