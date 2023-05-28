import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/bot_provider.dart';
import 'package:osrs_bot_dashboard/inactive_bot_item.dart';
import 'package:provider/provider.dart';

class InactiveBotsView extends StatelessWidget {
  const InactiveBotsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BotsModel>(builder: (context, botsModel, child) {
      return Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: botsModel.inactiveAccounts.length,
              itemBuilder: (context, index) {
                var account = botsModel.inactiveAccounts[index];
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
                      botsModel.fetchInactiveAccounts();
                      botsModel.fetchActiveAccounts();
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
