import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/dialog/start_bot_dialog.dart';
import 'package:provider/provider.dart';

import 'api/account.dart';
import 'api/bot_provider.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    // list view of accounts
    var accounts = Provider.of<AccountsModel>(context).accounts;
    print(accounts.length);

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        var account = accounts[index];
        return ListTile(
          leading: IconButton(
            icon: const Icon(Icons.play_circle),
            onPressed: () => _showStartBotDialog(context, account),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          title: Text(account.username),
          subtitle: Text(account.id),
        );
      },
    );
  }

  void _showStartBotDialog(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (context) {
        return StartBotDialog(account: account);
      },
    );
  }
}
