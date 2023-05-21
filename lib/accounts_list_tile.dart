import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    super.key,
    required String name,
    required String script,
  }) : _name = name, _script = script;

  final String _name;
  final String _script;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(icon: const Icon(Icons.play_circle), onPressed: (){}),
      trailing: IconButton(icon: const Icon(Icons.edit), onPressed: (){},),
      title: Text(_name),
      subtitle: Text(_script)
    );
  }
}
