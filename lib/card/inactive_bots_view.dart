import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/bot_provider.dart';
import 'package:osrs_bot_dashboard/inactive_bot_item.dart';
import 'package:provider/provider.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountsModel>(builder: (context, botsModel, child) {
      return Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                var account = botsModel.accounts[index];
                return InactiveBotItem(
                  username: account.username,
                  email: account.email,
                  id: account.id,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      botsModel.fetchAccounts();
                    },
                    child: const Text("Refresh")),
              ],
            ),
          ),
        ],
      );
    });
  }
}
