import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:osrs_bot_dashboard/api/account_activity.dart';

import 'account.dart';

class BotAPI {
  final String baseUrl;

  BotAPI(this.baseUrl);

  /*
   * Returns a list of all currently active accounts (bots currently running)
   */
  Future<List<Account>?> getActiveAccounts() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/bots/active"));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      var accounts = <Account>[];
      for (var account in decodedResponse) {
        accounts.add(Account.fromJson(account));
      }

      return accounts;
    } on SocketException catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  /*
  * Returns a list of all accounts
  */
  Future<List<Account>?> getAccounts() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/accounts"));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      var accounts = <Account>[];
      for (var account in decodedResponse) {
        accounts.add(Account.fromJson(account));
      }

      return accounts;
    } on SocketException catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<List<AccountActivity>?> fetchAccountActivity() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/bots/activity"));
      if (response.statusCode != 200) {
        throw Exception("Failed to fetch account activity");
      }

      var data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      var activities = <AccountActivity>[];
      for (var account in data) {
        activities.add(AccountActivity.fromJson(account));
      }
      return activities;
    } on SocketException catch (_) {
      log('failed to connect to host');
    } catch (e) {
      log('error fetching account activity: $e');
    }

    return null;
  }

  /*
   * Starts a bot with the given username
   */
  Future<void> startBot(String id, String script, List<String> args) async {
    log('starting bot $id with script $script and args $args');
    var client = http.Client();
    try {
      await client.post(Uri.parse("$baseUrl/bots"),
          body: jsonEncode({"id": id, "script": script, "args": args}));
    } finally {
      client.close();
    }
  }

  /*
   * Stops a running bot with the given account id
   */
  Future<bool> stopBot(String id) async {
    log('stopping bot $id');
    try {
      var response = await http.delete(
        Uri.parse("$baseUrl/bots/$id"),
        headers: {"Content-Type": "application/json"},
      );

      return response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent;
    } on SocketException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint('Error stopping bot: $e');
      return false;
    }
  }

  /*
   * Creates a new account
   */
  Future<bool> createAccount(String username, String email, AccountStatus status) async {
    try {
      // Convert status enum to string format expected by backend (e.g., 'active', 'inactive', 'banned')
      String statusString = status.name.toLowerCase();

      var response = await http.post(
        Uri.parse("$baseUrl/accounts"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "status": statusString,
        }),
      );

      return response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created;
    } on SocketException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint('Error creating account: $e');
      return false;
    }
  }

  /*
   * Updates an existing account
   */
  Future<bool> updateAccount(String id, String username, String email, AccountStatus status) async {
    try {
      // Convert status enum to string format expected by backend (e.g., 'active', 'inactive', 'banned')
      String statusString = status.name.toLowerCase();

      var response = await http.put(
        Uri.parse("$baseUrl/accounts/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "status": statusString,
        }),
      );

      return response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent;
    } on SocketException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint('Error updating account: $e');
      return false;
    }
  }

  /*
   * Deletes an account
   */
  Future<bool> deleteAccount(String id) async {
    try {
      var response = await http.delete(
        Uri.parse("$baseUrl/accounts/$id"),
        headers: {"Content-Type": "application/json"},
      );

      return response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent;
    } on SocketException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint('Error deleting account: $e');
      return false;
    }
  }
}
