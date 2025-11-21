import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/model/script.dart';
import 'package:osrs_bot_dashboard/state/scripts_model.dart';
import 'package:provider/provider.dart';

class ScriptsDialog extends StatefulWidget {
  const ScriptsDialog({Key? key}) : super(key: key);

  @override
  _ScriptsDialogState createState() => _ScriptsDialogState();
}

class _ScriptsDialogState extends State<ScriptsDialog> {
  @override
  Widget build(BuildContext context) {
    final scriptsModel = Provider.of<ScriptsModel>(context);

    return AlertDialog(
      title: const Text('Manage Scripts'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: scriptsModel.scripts.isEmpty
                  ? const Center(child: Text('No scripts defined'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: scriptsModel.scripts.length,
                      itemBuilder: (context, index) {
                        final script = scriptsModel.scripts[index];
                        return ListTile(
                          title: Text(script.name),
                          subtitle: script.parameters != null
                              ? Text('Parameters: ${script.parameters}')
                              : const Text('No default parameters'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditScriptDialog(context, script),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmDelete(context, script.name),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showAddScriptDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Script'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _showAddScriptDialog(BuildContext context) {
    final nameController = TextEditingController();
    final parametersController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Script'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Script Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: parametersController,
              decoration: const InputDecoration(
                labelText: 'Default Parameters (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Script name cannot be empty')),
                );
                return;
              }

              final parameters = parametersController.text.trim();
              final script = Script(
                name: name,
                parameters: parameters.isEmpty ? null : parameters,
              );

              Provider.of<ScriptsModel>(context, listen: false).addScript(script);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditScriptDialog(BuildContext context, Script script) {
    final nameController = TextEditingController(text: script.name);
    final parametersController = TextEditingController(text: script.parameters ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Script'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Script Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: parametersController,
              decoration: const InputDecoration(
                labelText: 'Default Parameters (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Script name cannot be empty')),
                );
                return;
              }

              final parameters = parametersController.text.trim();
              final newScript = Script(
                name: name,
                parameters: parameters.isEmpty ? null : parameters,
              );

              Provider.of<ScriptsModel>(context, listen: false)
                  .updateScript(script.name, newScript);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String scriptName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Script'),
        content: Text('Are you sure you want to delete "$scriptName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ScriptsModel>(context, listen: false)
                  .deleteScript(scriptName);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
