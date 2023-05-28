import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/dashboard_card.dart';

import 'api/account.dart';
import 'bots_overview_widget.dart';

import 'package:http/http.dart' as http;

class BotDashboard extends StatelessWidget {
  static const String BASE_URL = "http://192.168.1.156:8080";

  const BotDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Wrap(
          children: [
            const BotSummaryCard(),
            DashboardCard(
              title: const Text("Available", textScaleFactor: 2),
              child: SizedBox(
                height: 250,
                child: ListView(
                  children: const [],
                ),
              ),
            ),
            DashboardCard(
              title: const Text("Active", textScaleFactor: 2),
              child: SizedBox(
                height: 250,
                child: ListView(
                  children: const [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
