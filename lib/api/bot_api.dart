import 'dart:convert';

import 'package:http/http.dart' as http;

import 'account.dart';

class BotAPI {
  static const String BASE_URL = "http://192.168.1.156:8080";

  /*
   * Returns a list of all currently active accounts (bots currently running)
   */
  static Future<List<Account>> getActiveAccounts() async {
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
   * Returns a list of all currently inactive accounts (including banned) 
   */
  static Future<List<Account>> getInactiveAccounts() async {
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
}
