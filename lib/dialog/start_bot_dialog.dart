import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:provider/provider.dart';

import '../api/account.dart';

class StartBotDialog extends StatefulWidget {
  final Account account;

  const StartBotDialog({Key? key, required this.account}) : super(key: key);

  @override
  _StartBotDialogState createState() => _StartBotDialogState();
}

class _StartBotDialogState extends State<StartBotDialog> {
  String selectedScript = "";
  TextEditingController parametersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.account.username),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: selectedScript,
            hint: Text('Select a script'),
            items: <String>[
              '',
              'NewbTrainer',
              'KillerCowhideTanner',
              'Script 3',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedScript = value ?? "";
              });
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: parametersController,
            decoration: InputDecoration(
              labelText: 'Optional Parameters',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _startBot();
            Navigator.of(context).pop();
          },
          child: Text('Run'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _startBot() {
    // Implement your bot start/run logic here.
    // This function will be called when the "Start/Run" button is pressed.
    // For this example, it's left empty as you requested.

    final settingsModel = Provider.of<SettingsModel>(context, listen: false);
    final api = BotAPI(settingsModel.apiIp);

    api.startBot(
      widget.account.id,
      selectedScript,
      parametersController.text.split(' '),
    );
  }
}
