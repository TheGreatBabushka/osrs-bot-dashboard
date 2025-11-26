import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/account_activity.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';

/// Refresh interval for auto-updating activity data
const Duration kActivityRefreshInterval = Duration(seconds: 5);

/// Model class for the most recent activity a bot has performed
///
/// Stores the account activities for all known bots retrieved from the API
/// Stores the command (script) and arguments used to start the bot, the time
/// it was started, and the time it was stopped, as well as the process id of
/// the bot's current client
class AccountActivityModel extends ChangeNotifier {
  final SettingsModel settingsModel;
  final List<AccountActivity> _activities = [];
  Timer? _refreshTimer;
  bool _disposed = false;

  List<AccountActivity> get activities => _activities;

  AccountActivityModel(this.settingsModel, {bool autoFetch = true}) {
    if (autoFetch) {
      fetchActivities();
      _startAutoRefresh();
    }
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(kActivityRefreshInterval, (timer) {
      fetchActivities();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _refreshTimer?.cancel();
    super.dispose();
  }

  void addActivity(AccountActivity activity) {
    _activities.add(activity);
    if (!_disposed) {
      notifyListeners();
    }
  }

  void removeActivity(AccountActivity activity) {
    _activities.remove(activity);
    if (!_disposed) {
      notifyListeners();
    }
  }

  void clearActivities() {
    _activities.clear();
    if (!_disposed) {
      notifyListeners();
    }
  }

  void fetchActivities() async {
    if (_disposed) return;
    
    final api = BotAPI(settingsModel.apiIp);
    var activities = await api.fetchAccountActivity();
    if (_disposed) return;
    
    if (activities == null) {
      log("Failed to fetch activities");
      return;
    }

    _activities.clear();
    _activities.addAll(activities);
    if (!_disposed) {
      notifyListeners();
    }
  }
}
