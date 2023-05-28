import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/account_activity.dart';
import 'package:osrs_bot_dashboard/api/bot_api.dart';

/// Model class for the most recent activity a bot has performed
///
/// Stores the account activities for all known bots retrieved from the API
/// Stores the command (script) and arguments used to start the bot, the time
/// it was started, and the time it was stopped, as well as the process id of
/// the bot's current client
class AccountActivityModel extends ChangeNotifier {
  final List<AccountActivity> _activities = [];

  List<AccountActivity> get activities => _activities;

  AccountActivityModel() {
    fetchActivities();
  }

  void addActivity(AccountActivity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void removeActivity(AccountActivity activity) {
    _activities.remove(activity);
    notifyListeners();
  }

  void clearActivities() {
    _activities.clear();
    notifyListeners();
  }

  void fetchActivities() async {
    var activities = await BotAPI.getAccountActivity();
    _activities.clear();
    _activities.addAll(activities);
    notifyListeners();
  }
}
