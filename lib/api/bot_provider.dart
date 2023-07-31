import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/bot_api.dart';

import 'account.dart';

class AccountsModel extends ChangeNotifier {
  final List<Account> _activeAccounts = [];
  final List<Account> _accounts = [];

  List<Account> get activeAccounts => _activeAccounts;
  List<Account> get accounts => _accounts;

  AccountsModel() {
    fetchAccounts();
  }

  void addActiveAccount(Account account) {
    _activeAccounts.add(account);
    notifyListeners();
  }

  void removeActiveAccount(Account account) {
    _activeAccounts.remove(account);
    notifyListeners();
  }

  void clearActiveAccounts() {
    _activeAccounts.clear();
    notifyListeners();
  }

  void fetchAccounts() async {
    var accounts = await BotAPI.getActiveAccounts();
    if (accounts == null) {
      log("Failed to fetch active accounts");
      return;
    }

    _activeAccounts.clear();
    _activeAccounts.addAll(accounts);

    accounts = await BotAPI.getAccounts();
    if (accounts == null) {
      log("Failed to fetch accounts");
      return;
    }

    _accounts.clear();
    _accounts.addAll(accounts);

    notifyListeners();
  }
}
