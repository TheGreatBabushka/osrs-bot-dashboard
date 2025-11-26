import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/api/api.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';

import 'account.dart';

/// Refresh interval for auto-updating account data
const Duration kAccountsRefreshInterval = Duration(seconds: 5);

class AccountsModel extends ChangeNotifier {
  final SettingsModel settingsModel;
  final List<Account> _activeAccounts = [];
  final List<Account> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _showBannedAccounts = true;
  Timer? _refreshTimer;
  bool _disposed = false;

  List<Account> get activeAccounts => _activeAccounts;
  List<Account> get accounts => _showBannedAccounts 
      ? _accounts 
      : _accounts.where((account) => account.status != AccountStatus.BANNED).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get showBannedAccounts => _showBannedAccounts;

  // Test-only setters (used by unit tests)
  @visibleForTesting
  set accounts(List<Account> value) {
    _accounts.clear();
    _accounts.addAll(value);
    _errorMessage = null; // Clear error when setting test data
  }

  @visibleForTesting
  set isLoading(bool value) {
    _isLoading = value;
    if (!value) {
      _errorMessage = null; // Clear error when loading completes in tests
    }
  }

  void setShowBannedAccounts(bool value) {
    _showBannedAccounts = value;
    notifyListeners();
  }

  AccountsModel(this.settingsModel, {bool autoFetch = true}) {
    if (autoFetch) {
      fetchAccounts();
      _startAutoRefresh();
    }
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(kAccountsRefreshInterval, (timer) {
      fetchAccounts();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _refreshTimer?.cancel();
    super.dispose();
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
    if (_disposed) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final api = BotAPI(settingsModel.apiIp);

      var accounts = await api.getActiveAccounts();
      if (_disposed) return;
      
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
      if (_disposed) return;
      
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
      if (_disposed) return;
      log("Error fetching accounts: $e");
      _errorMessage = "An unexpected error occurred. Please try again later.";
    } finally {
      if (!_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
