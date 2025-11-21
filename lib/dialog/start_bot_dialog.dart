import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/state/scripts_model.dart';
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
    final scriptsModel = Provider.of<ScriptsModel>(context);
    
    // Create list of script names with empty option first
    final scriptNames = ['', ...scriptsModel.scripts.map((s) => s.name)];
    
    return AlertDialog(
      title: Text(widget.account.username),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: selectedScript,
            hint: Text('Select a script'),
            items: scriptNames.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.isEmpty ? '(none)' : value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedScript = value ?? "";
                
                // Auto-populate parameters if script has default parameters
                if (value != null && value.isNotEmpty) {
                  final script = scriptsModel.getScript(value);
                  if (script != null && script.parameters != null) {
                    parametersController.text = script.parameters!;
                  }
                }
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
            if (_startBot()) {
              Navigator.of(context).pop();
            }
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

  bool _startBot() {
    // Validate that a script is selected
    if (selectedScript.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a script before starting the bot'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    final settingsModel = Provider.of<SettingsModel>(context, listen: false);
    final api = BotAPI(settingsModel.apiIp);

    api.startBot(
      widget.account.id,
      selectedScript,
      parametersController.text.split(' '),
    );
    
    return true;
  }
}
