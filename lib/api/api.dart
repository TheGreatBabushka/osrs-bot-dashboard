import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:osrs_bot_dashboard/api/account_activity.dart';
import 'package:osrs_bot_dashboard/api/levels.dart';
import 'package:osrs_bot_dashboard/api/xp.dart';

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
          body: jsonEncode({"id": id, "script": script, "params": args}));
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

  /*
   * Returns the skill levels for a specific account
   */
  Future<Levels?> getLevels(String id) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/levels/$id"));
      if (response.statusCode != HttpStatus.ok) {
        log('Failed to fetch levels: ${response.statusCode}');
        return null;
      }

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return Levels.fromJson(decodedResponse);
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      log('Error fetching levels: $e');
    }

    return null;
  }

  /*
   * Returns the total XP gained for a specific account
   */
  Future<Xp?> getAccountXp(String accountId) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/accounts/$accountId/xp"));
      if (response.statusCode != HttpStatus.ok) {
        log('Failed to fetch account XP: ${response.statusCode}');
        return null;
      }

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      
      // Handle both list and single object responses
      if (decodedResponse is List) {
        if (decodedResponse.isEmpty) {
          return null;
        }
        // Aggregate XP from all records in the list
        return _aggregateXpFromList(decodedResponse);
      } else if (decodedResponse is Map<String, dynamic>) {
        return Xp.fromJson(decodedResponse);
      }
      
      return null;
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      log('Error fetching account XP: $e');
    }

    return null;
  }

  /*
   * Returns the XP gained for a specific activity
   */
  Future<Xp?> getActivityXp(int activityId) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/activity/$activityId/xp"));
      if (response.statusCode != HttpStatus.ok) {
        log('Failed to fetch activity XP: ${response.statusCode}');
        return null;
      }

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      
      // Handle both list and single object responses
      if (decodedResponse is List) {
        if (decodedResponse.isEmpty) {
          return null;
        }
        // Aggregate XP from all records in the list
        return _aggregateXpFromList(decodedResponse);
      } else if (decodedResponse is Map<String, dynamic>) {
        return Xp.fromJson(decodedResponse);
      }
      
      return null;
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      log('Error fetching activity XP: $e');
    }

    return null;
  }

  /// Aggregates XP from a list of XP records by summing all skill values
  Xp _aggregateXpFromList(List<dynamic> xpList) {
    int attack = 0, defence = 0, strength = 0, hitpoints = 0;
    int ranged = 0, prayer = 0, magic = 0, cooking = 0;
    int woodcutting = 0, fletching = 0, fishing = 0, firemaking = 0;
    int crafting = 0, smithing = 0, mining = 0, herblore = 0;
    int agility = 0, thieving = 0, slayer = 0, farming = 0;
    int runecraft = 0, hunter = 0, construction = 0;

    for (var item in xpList) {
      if (item is Map<String, dynamic>) {
        attack += (item['attack'] ?? 0) as int;
        defence += (item['defence'] ?? 0) as int;
        strength += (item['strength'] ?? 0) as int;
        hitpoints += (item['hitpoints'] ?? 0) as int;
        ranged += (item['ranged'] ?? 0) as int;
        prayer += (item['prayer'] ?? 0) as int;
        magic += (item['magic'] ?? 0) as int;
        cooking += (item['cooking'] ?? 0) as int;
        woodcutting += (item['woodcutting'] ?? 0) as int;
        fletching += (item['fletching'] ?? 0) as int;
        fishing += (item['fishing'] ?? 0) as int;
        firemaking += (item['firemaking'] ?? 0) as int;
        crafting += (item['crafting'] ?? 0) as int;
        smithing += (item['smithing'] ?? 0) as int;
        mining += (item['mining'] ?? 0) as int;
        herblore += (item['herblore'] ?? 0) as int;
        agility += (item['agility'] ?? 0) as int;
        thieving += (item['thieving'] ?? 0) as int;
        slayer += (item['slayer'] ?? 0) as int;
        farming += (item['farming'] ?? 0) as int;
        runecraft += (item['runecraft'] ?? 0) as int;
        hunter += (item['hunter'] ?? 0) as int;
        construction += (item['construction'] ?? 0) as int;
      }
    }

    return Xp(
      attack: attack,
      defence: defence,
      strength: strength,
      hitpoints: hitpoints,
      ranged: ranged,
      prayer: prayer,
      magic: magic,
      cooking: cooking,
      woodcutting: woodcutting,
      fletching: fletching,
      fishing: fishing,
      firemaking: firemaking,
      crafting: crafting,
      smithing: smithing,
      mining: mining,
      herblore: herblore,
      agility: agility,
      thieving: thieving,
      slayer: slayer,
      farming: farming,
      runecraft: runecraft,
      hunter: hunter,
      construction: construction,
    );
  }
}
