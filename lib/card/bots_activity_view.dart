import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/account_activity_item.dart';
import 'package:osrs_bot_dashboard/api/bot_provider.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:provider/provider.dart';

class BotsActivityView extends StatelessWidget {
  const BotsActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    var activityModel = Provider.of<AccountActivityModel>(context);
    var accountsModel = Provider.of<AccountsModel>(context);

    var accounts = accountsModel.accounts;
    if (accounts.isEmpty) {
      return const Text("No accounts");
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: activityModel.activities.length,
          itemBuilder: (context, index) {
            var activity = activityModel.activities[index];
            // var account = accounts
            //     .where((acc) => acc.id == '${activity.accountId}')
            //     .first;
            print(activity);
            return AccountActivityItem(
              account: accounts.first,
              activity: activity,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    activityModel.fetchActivities();
                  },
                  child: const Text("Refresh")),
            ],
          ),
        ),
      ],
    );
  }
}
