import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/bot_api.dart';

import 'account.dart';

class BotProvider extends ChangeNotifier {
  final List<Account> _activeAccounts = [];
  final List<Account> _inactiveAccounts = [];

  List<Account> get activeAccounts => _activeAccounts;
  List<Account> get inactiveAccounts => _inactiveAccounts;

  void addActiveAccount(Account account) {
    _activeAccounts.add(account);
    notifyListeners();
  }

  void addInactiveAccount(Account account) {
    _inactiveAccounts.add(account);
    notifyListeners();
  }

  void removeActiveAccount(Account account) {
    _activeAccounts.remove(account);
    notifyListeners();
  }

  void removeInactiveAccount(Account account) {
    _inactiveAccounts.remove(account);
    notifyListeners();
  }

  void clearActiveAccounts() {
    _activeAccounts.clear();
    notifyListeners();
  }

  void fetchActiveAccounts() async {
    var accounts = await BotAPI.getActiveAccounts();
    _activeAccounts.clear();
    _activeAccounts.addAll(accounts);
  }

  void fetchInactiveAccounts() async {
    var accounts = await BotAPI.getInactiveAccounts();
    _inactiveAccounts.clear();
    _inactiveAccounts.addAll(accounts);
  }
}
