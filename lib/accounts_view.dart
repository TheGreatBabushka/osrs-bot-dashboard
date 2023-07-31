import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            onPressed: () {},
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
}
