import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:osrs_bot_dashboard/api/account_activity.dart';

import 'account.dart';

class BotAPI {
  static const String BASE_URL = "http://192.168.1.156:8080";

  /*
   * Returns a list of all currently active accounts (bots currently running)
   */
  static Future<List<Account>> getActiveAccounts() async {
    log('fetching active accounts');
    List<Account> accounts = [];

    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("$BASE_URL/bots/active"));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      for (var account in decodedResponse) {
        accounts.add(Account.fromJson(account));
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      client.close();
    }

    return accounts;
  }

  /*
   * Returns a list of all currently inactive accounts (including banned) 
   */
  static Future<List<Account>> getInactiveAccounts() async {
    log('fetching inactive accounts');
    List<Account> accounts = [];

    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("$BASE_URL/bots/inactive"));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      for (var account in decodedResponse) {
        accounts.add(Account.fromJson(account));
      }
    } finally {
      client.close();
    }

    return accounts;
  }

  /*
  * Returns a list of all account activity
  */
  static Future<List<AccountActivity>> getAccountActivity() async {
    log('fetching all account activity');

    List<AccountActivity> activities = [];

    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("$BASE_URL/bots/activity"));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      for (var account in decodedResponse) {
        activities.add(AccountActivity.fromJson(account));
      }
    } finally {
      client.close();
    }

    return activities;
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

  static Future<List<Account>> getAccounts() {
    // this could be optimized to only make one request, but meh
    return Future.wait([getActiveAccounts(), getInactiveAccounts()])
        .then((value) => value[0] + value[1]);
  }
}
