import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osrs_bot_dashboard/api/account.dart';
import 'package:osrs_bot_dashboard/api/account_activity.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/api/xp.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:provider/provider.dart';

class AccountActivityItem extends StatefulWidget {
  final Account account;
  final AccountActivity activity;

  const AccountActivityItem({
    super.key,
    required this.account,
    required this.activity,
  });

  @override
  State<AccountActivityItem> createState() => _AccountActivityItemState();
}

class _AccountActivityItemState extends State<AccountActivityItem> {
  Xp? _activityXp;
  bool _isLoadingXp = false;
  bool _xpFetched = false;

  Future<void> _fetchActivityXp() async {
    if (_xpFetched || widget.activity.id == null) return;

    setState(() {
      _isLoadingXp = true;
    });

    try {
      final settingsModel = Provider.of<SettingsModel>(context, listen: false);
      final api = BotAPI(settingsModel.apiIp);
      final xp = await api.getActivityXp(widget.activity.id!);

      if (mounted) {
        setState(() {
          _activityXp = xp;
          _isLoadingXp = false;
          _xpFetched = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingXp = false;
          _xpFetched = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var activity = widget.activity;

    var command = activity.command;
    var commandParts = command.split(' ');

    // Extract parameters (everything after the first part)
    var params = commandParts.length > 1 ? commandParts.skip(1).join(' ').trim() : '';
    // Check if params is actually empty or just "[]"
    var hasParams = params.isNotEmpty && params != '[]';

    var startedTime = DateTime.tryParse(activity.startedAt);
    var endedTime = DateTime.tryParse(activity.stoppedAt ?? '');

    return ExpansionTile(
      title: Text(widget.account.username),
      subtitle: Text(commandParts.first),
      leading: _buildLeading(startedTime, endedTime),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      onExpansionChanged: (expanded) {
        if (expanded) {
          _fetchActivityXp();
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, 'Script:', commandParts.first),
              const SizedBox(height: 8),
              _buildDetailRow(context, 'Started:', _formatDateTime(startedTime)),
              const SizedBox(height: 8),
              if (endedTime != null && startedTime != null && endedTime.isAfter(startedTime)) ...[
                _buildDetailRow(context, 'Stopped:', _formatDateTime(endedTime)),
                const SizedBox(height: 8),
                _buildDetailRow(context, 'Runtime:', _formatRuntime(startedTime, endedTime)),
                const SizedBox(height: 8),
              ] else if (startedTime != null) ...[
                _buildDetailRow(context, 'Status:', 'Currently Running'),
                const SizedBox(height: 8),
                _buildDetailRow(context, 'Runtime:', _formatCurrentRuntime(startedTime)),
                const SizedBox(height: 8),
              ],
              // XP Gained Section
              _buildXpSection(context),
              if (hasParams) ...[
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parameters:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            params,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy Parameters to Clipboard',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: params));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Parameters copied to clipboard'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildXpSection(BuildContext context) {
    if (widget.activity.id == null) {
      return const SizedBox.shrink();
    }

    if (_isLoadingXp) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'XP Gained:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(width: 8),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
    }

    if (_activityXp == null || _activityXp!.totalXp == 0) {
      return const SizedBox.shrink();
    }

    final nonZeroSkills = _activityXp!.nonZeroSkillEntries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          'XP Gained:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: nonZeroSkills.map((entry) {
            return Chip(
              label: Text(
                '${entry.key}: ${_formatXp(entry.value)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
        Text(
          'Total: ${_formatXp(_activityXp!.totalXp)} XP',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000000) {
      return '${(xp / 1000000).toStringAsFixed(1)}M';
    } else if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}K';
    }
    return xp.toString();
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
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
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A';
    }

    // Format: Dec 24, 2025 at 3:45 PM
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour =
        dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year at $hour:$minute $period';
  }

  String _formatRuntime(DateTime? startTime, DateTime? endTime) {
    if (startTime == null || endTime == null) {
      return 'N/A';
    }

    final duration = endTime.difference(startTime);
    return _formatDuration(duration);
  }

  String _formatCurrentRuntime(DateTime? startTime) {
    if (startTime == null) {
      return 'N/A';
    }

    final duration = DateTime.now().difference(startTime);
    return _formatDuration(duration);
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      final hours = duration.inHours % 24;
      final minutes = duration.inMinutes % 60;
      return '${duration.inDays}d ${hours}h ${minutes}m';
    } else if (duration.inHours > 0) {
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;
      return '${duration.inHours}h ${minutes}m ${seconds}s';
    } else if (duration.inMinutes > 0) {
      final seconds = duration.inSeconds % 60;
      return '${duration.inMinutes}m ${seconds}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

Widget _buildLeading(DateTime? startedTime, DateTime? endedTime) {
  Widget content;

  if (startedTime == null) {
    content = const Icon(Icons.error);
  } else if (endedTime == null ||
      endedTime.isBefore(startedTime) ||
      endedTime.isAtSameMomentAs(startedTime)) {
    content = const Text('Running');
  } else {
    var currentTime = DateTime.now();
    var deltaTime = currentTime.difference(endedTime);

    if (deltaTime.inSeconds < 60) {
      content = Text("${deltaTime.inSeconds}s ago");
    } else if (deltaTime.inMinutes < 60) {
      content = Text("${deltaTime.inMinutes}m ago");
    } else if (deltaTime.inHours < 24) {
      content = Text("${deltaTime.inHours}h ago");
    } else {
      content = Text("${deltaTime.inDays}d ago");
    }
  }

  return SizedBox(
    width: 80,
    child: content,
  );
}
