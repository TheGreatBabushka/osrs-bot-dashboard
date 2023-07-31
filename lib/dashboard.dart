import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/card/bots_activity_view.dart';
import 'package:osrs_bot_dashboard/card/inactive_bots_view.dart';
import 'package:osrs_bot_dashboard/dashboard_card.dart';

import 'bots_overview_widget.dart';

class BotDashboard extends StatelessWidget {
  static const String BASE_URL = "http://192.168.1.156:8080";

  const BotDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        BotSummaryCard(),
        BotsActivityView(),
        DashboardCard(
          title: Text("Recent Bot Activity", textScaleFactor: 2),
          child: BotsActivityView(),
        ),
        DashboardCard(
          title: Text("Inactive", textScaleFactor: 2),
          child: _accountsView(),
        ),
        // DashboardCard(
        //   title: Text("Available", textScaleFactor: 2),
        //   child: InactiveBotsView(),
        // ),
      ],
    );
  }

  Widget _accountsView() {
    return Placeholder();
  }
}
