import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:osrs_bot_dashboard/api/account_activity.dart';

import 'account.dart';

class BotAPI {
  static const String BASE_URL = "http://localhost:8080";

  /*
   * Returns a list of all currently active accounts (bots currently running)
   */
  static Future<List<Account>?> getActiveAccounts() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/bots/active"));
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
  static Future<List<Account>?> getAccounts() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/accounts"));
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

  static Future<List<AccountActivity>?> fetchAccountActivity() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/bots/activity"));
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
    }

    return null;
  }

  /*
   * Starts a bot with the given username
   */
  static void startBot(String id, String script, List<String> args) {
    log('starting bot $id with script $script and args $args');
    var client = http.Client();
    try {
      client.post(Uri.parse("$BASE_URL/bots"),
          body: jsonEncode({"id": id, "script": script, "args": args}));
    } finally {
      client.close();
    }
  }

  // Returns a future response from a GET request made to the given url string
  static Future<Response> _get(String url) async {
    try {
      return await http.get(Uri.parse(url)).then((response) {
        return response;
      });
    } on SocketException catch (_) {
      log('failed to connect to host');
      return Future.error("Failed to connect to host");
    }
  }
}
