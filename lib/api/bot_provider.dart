import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/bot_api.dart';

import 'account.dart';

class AccountsModel extends ChangeNotifier {
  final List<Account> _activeAccounts = [];
  final List<Account> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Account> get activeAccounts => _activeAccounts;
  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var accounts = await BotAPI.getActiveAccounts();
      if (accounts == null) {
        log("Failed to fetch active accounts");
        _errorMessage = "Failed to fetch active accounts. Please check your connection.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _activeAccounts.clear();
      _activeAccounts.addAll(accounts);

      accounts = await BotAPI.getAccounts();
      if (accounts == null) {
        log("Failed to fetch accounts");
        _errorMessage = "Failed to fetch accounts. Please check your connection.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _accounts.clear();
      _accounts.addAll(accounts);
      _errorMessage = null;
    } catch (e) {
      log("Error fetching accounts: $e");
      _errorMessage = "An unexpected error occurred: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
