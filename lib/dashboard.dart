import 'package:flutter/material.dart';

import 'accounts_list_tile.dart';
import 'bots_overview_widget.dart';

class BotDashboard extends StatelessWidget {
  const BotDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const BotSummaryCard(),
        SizedBox(
          height: 300,
          width: 300,
          child: Card(
            elevation: 10,
            child: ListView(
              children: const [
                AccountListTile(name: "KadKudin", script: "NewbTrainer"),
                AccountListTile(name: "TheBeazt32", script: "Fightaholic"),
                AccountListTile(name: "Skeeter144", script: "Fightaholic"),
                AccountListTile(name: "Skeeter144", script: "Fightaholic"),
                AccountListTile(name: "Skeeter144", script: "Fightaholic"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
