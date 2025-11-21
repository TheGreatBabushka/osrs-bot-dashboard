import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/accounts_model.dart';
import 'package:provider/provider.dart';

import 'dashboard_card.dart';

class BotSummaryCard extends StatefulWidget {
  const BotSummaryCard({Key? key}) : super(key: key);

  @override
  State<BotSummaryCard> createState() => _BotSummaryCardState();
}

class _BotSummaryCardState extends State<BotSummaryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountsModel>(builder: (context, botsModel, child) {
      var running = botsModel.activeAccounts.length;
      // var inactive = botsModel.inactiveAccounts.length;
      // var available = running - inactive;
      return DashboardCard(
        title: const Text("Summary", textScaleFactor: 2),
        child: Table(
          children: [
            TableRow(
              children: [const Text("Running:"), Text(running.toString())],
            ),
            // TableRow(
            //   children: [const Text("Available:"), Text(inactive.toString())],
            // ),
          ],
        ),
      );
    });
  }
}
