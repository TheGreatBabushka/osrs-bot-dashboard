import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _apiIpController;
  bool _hasChanges = false;
  String _initialApiIp = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_apiIpController.text.isEmpty) {
      final settingsModel = Provider.of<SettingsModel>(context, listen: false);
      _initialApiIp = settingsModel.apiIp;
      _apiIpController.text = _initialApiIp;
    }
  }

  @override
  void initState() {
    super.initState();
    _apiIpController = TextEditingController();
    _apiIpController.addListener(() {
      setState(() {
        _hasChanges = _apiIpController.text != _initialApiIp;
      });
    });
  }

  @override
  void dispose() {
    _apiIpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settingsModel, child) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'API Server Configuration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _apiIpController,
                decoration: const InputDecoration(
                  labelText: 'API IP Address',
                  hintText: 'http://localhost:8080',
                  border: OutlineInputBorder(),
                  helperText: 'Enter the full URL including protocol and port',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 8),
              Text(
                'Current: ${settingsModel.apiIp}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await settingsModel.resetToDefault();
                if (mounted) {
                  setState(() {
                    _apiIpController.text = settingsModel.apiIp;
                    _initialApiIp = settingsModel.apiIp;
                    _hasChanges = false;
                  });
                }
              },
              child: const Text('Reset to Default'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _hasChanges
                  ? () async {
                      final newApiIp = _apiIpController.text.trim();
                      
                      // Validate URL format
                      if (!newApiIp.startsWith('http://') && !newApiIp.startsWith('https://')) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL must start with http:// or https://'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                        return;
                      }
                      
                      await settingsModel.setApiIp(newApiIp);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('API IP updated successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
