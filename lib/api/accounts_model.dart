import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';

import 'account.dart';

class AccountsModel extends ChangeNotifier {
  final SettingsModel settingsModel;
  final List<Account> _activeAccounts = [];
  final List<Account> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Account> get activeAccounts => _activeAccounts;
  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AccountsModel(this.settingsModel) {
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

  Future<void> fetchAccounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final api = BotAPI(settingsModel.apiIp);

      var accounts = await api.getActiveAccounts();
      if (accounts == null) {
        log("Failed to fetch active accounts");
        _errorMessage = "Failed to load accounts. Please try again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _activeAccounts.clear();
      _activeAccounts.addAll(accounts);

      accounts = await api.getAccounts();
      if (accounts == null) {
        log("Failed to fetch accounts");
        _errorMessage = "Failed to load accounts. Please try again.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _accounts.clear();
      _accounts.addAll(accounts);
    } catch (e) {
      log("Error fetching accounts: $e");
      _errorMessage = "An unexpected error occurred. Please try again later.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
