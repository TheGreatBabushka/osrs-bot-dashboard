import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:provider/provider.dart';

class InactiveBotItem extends StatefulWidget {
  final String email;
  final String username;
  final String id;

  const InactiveBotItem({
    super.key,
    required this.username,
    required this.email,
    required this.id,
  });

  @override
  State<InactiveBotItem> createState() => _InactiveBotItemState();
}

class _InactiveBotItemState extends State<InactiveBotItem> {
  bool _launching = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.username),
      subtitle: Text(widget.email),
      trailing: _launching ? _launchingIndicator() : _startButton(),
    );
  }

  Widget _startButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _launching = true;
          _startBot();
        });
      },
      child: const Text("Start"),
    );
  }

  Widget _launchingIndicator() {
    return const CircularProgressIndicator();
  }

  void _startBot() {
    var activities = context.read<AccountActivityModel>();
    var settingsModel = context.read<SettingsModel>();

    var lastActivity =
        activities.activities.where((activity) => '${activity.accountId}' == widget.id).first;

    var args = lastActivity.command.split(' ');
    var script = args.first;
    var params = args.skip(1).toList();
    if (params.first.startsWith('[') && params.first.length > 1) {
      params.first = params.first.substring(1);
    }

    final api = BotAPI(settingsModel.apiIp);
    api.startBot('${lastActivity.accountId}', script, params);
  }
}
