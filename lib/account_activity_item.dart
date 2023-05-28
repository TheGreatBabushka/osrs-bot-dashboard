import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/account.dart';
import 'package:osrs_bot_dashboard/api/account_activity.dart';

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
  @override
  Widget build(BuildContext context) {
    var activity = widget.activity;

    var command = activity.command;
    var commandParts = command.split(' ');

    var startedTime = DateTime.tryParse(activity.startedAt);
    var endedTime = DateTime.tryParse(activity.stoppedAt);

    return ExpansionTile(
      title: Text(widget.account.username),
      subtitle: Text(commandParts.first),
      leading: _buildLeading(startedTime, endedTime),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Parameters:'),
        Text(commandParts.skip(1).join(' ')),
      ],
    );
  }
}

Widget _buildLeading(DateTime? startedTime, DateTime? endedTime) {
  if (startedTime == null) {
    return const Icon(Icons.error);
  }

  if (endedTime == null ||
      endedTime.isBefore(startedTime) ||
      endedTime.isAtSameMomentAs(startedTime)) {
    return const Text('Running');
  }

  var currentTime = DateTime.now();
  var deltaTime = currentTime.difference(endedTime);

  if (deltaTime.inSeconds < 60) {
    return Text("${deltaTime.inSeconds} seconds ago");
  }

  if (deltaTime.inMinutes < 60) {
    return Text("${deltaTime.inMinutes} minutes ago");
  }

  if (deltaTime.inHours < 24) {
    return Text("${deltaTime.inHours} hours ago");
  }

  return Text("${deltaTime.inDays} days ago");
}
