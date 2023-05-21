import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/bot_api.dart';

import 'dashboard_card.dart';

class BotSummaryCard extends StatefulWidget {
  const BotSummaryCard({Key? key}) : super(key: key);

  @override
  State<BotSummaryCard> createState() => _BotSummaryCardState();
}

class _BotSummaryCardState extends State<BotSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: const Text("Summary", textScaleFactor: 2),
      footer: TextButton(
        onPressed: () {
          BotAPI.getActiveAccounts();
        },
        child: const Text("Refresh"),
      ),
      child: Table(
        children: const [
          TableRow(
            children: [Text("Running:"), Text("3")],
          ),
          TableRow(
            children: [Text("Banned:"), Text("0")],
          ),
          TableRow(
            children: [Text("Available:"), Text("5")],
          ),
        ],
      ),
    );
  }
}
