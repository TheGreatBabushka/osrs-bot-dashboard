import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/api/levels.dart';

void main() {
  group('Levels', () {
    test('fromJson creates Levels correctly', () {
      final json = {
        'account_id': 123,
        'attack': 50,
        'defence': 45,
        'strength': 60,
        'hitpoints': 55,
        'ranged': 40,
        'prayer': 35,
        'magic': 70,
        'cooking': 30,
        'woodcutting': 25,
        'fletching': 20,
        'fishing': 15,
        'firemaking': 10,
        'crafting': 5,
        'smithing': 1,
        'mining': 42,
        'herblore': 38,
        'agility': 33,
        'thieving': 28,
        'slayer': 23,
        'farming': 18,
        'runecraft': 13,
        'hunter': 8,
        'construction': 3,
      };

      final levels = Levels.fromJson(json);

      expect(levels.accountId, 123);
      expect(levels.attack, 50);
      expect(levels.defence, 45);
      expect(levels.strength, 60);
      expect(levels.hitpoints, 55);
      expect(levels.ranged, 40);
      expect(levels.prayer, 35);
      expect(levels.magic, 70);
      expect(levels.cooking, 30);
      expect(levels.woodcutting, 25);
      expect(levels.fletching, 20);
      expect(levels.fishing, 15);
      expect(levels.firemaking, 10);
      expect(levels.crafting, 5);
      expect(levels.smithing, 1);
      expect(levels.mining, 42);
      expect(levels.herblore, 38);
      expect(levels.agility, 33);
      expect(levels.thieving, 28);
      expect(levels.slayer, 23);
      expect(levels.farming, 18);
      expect(levels.runecraft, 13);
      expect(levels.hunter, 8);
      expect(levels.construction, 3);
    });

    test('toJson converts Levels to correct JSON format', () {
      final levels = Levels(
        accountId: 456,
        attack: 99,
        defence: 99,
        strength: 99,
        hitpoints: 99,
        ranged: 99,
        prayer: 99,
        magic: 99,
        cooking: 99,
        woodcutting: 99,
        fletching: 99,
        fishing: 99,
        firemaking: 99,
        crafting: 99,
        smithing: 99,
        mining: 99,
        herblore: 99,
        agility: 99,
        thieving: 99,
        slayer: 99,
        farming: 99,
        runecraft: 99,
        hunter: 99,
        construction: 99,
      );

      final json = levels.toJson();

      expect(json['account_id'], 456);
      expect(json['attack'], 99);
      expect(json['defence'], 99);
      expect(json['strength'], 99);
      expect(json['hitpoints'], 99);
      expect(json['ranged'], 99);
      expect(json['prayer'], 99);
      expect(json['magic'], 99);
      expect(json['cooking'], 99);
      expect(json['woodcutting'], 99);
      expect(json['fletching'], 99);
      expect(json['fishing'], 99);
      expect(json['firemaking'], 99);
      expect(json['crafting'], 99);
      expect(json['smithing'], 99);
      expect(json['mining'], 99);
      expect(json['herblore'], 99);
      expect(json['agility'], 99);
      expect(json['thieving'], 99);
      expect(json['slayer'], 99);
      expect(json['farming'], 99);
      expect(json['runecraft'], 99);
      expect(json['hunter'], 99);
      expect(json['construction'], 99);
    });

    test('fromJson and toJson are symmetric', () {
      final originalJson = {
        'account_id': 789,
        'attack': 75,
        'defence': 65,
        'strength': 85,
        'hitpoints': 80,
        'ranged': 55,
        'prayer': 45,
        'magic': 90,
        'cooking': 40,
        'woodcutting': 35,
        'fletching': 30,
        'fishing': 25,
        'firemaking': 20,
        'crafting': 15,
        'smithing': 10,
        'mining': 50,
        'herblore': 48,
        'agility': 43,
        'thieving': 38,
        'slayer': 33,
        'farming': 28,
        'runecraft': 23,
        'hunter': 18,
        'construction': 13,
      };

      final levels = Levels.fromJson(originalJson);
      final convertedJson = levels.toJson();

      expect(convertedJson, equals(originalJson));
    });

    test('totalLevel calculates sum of all skills', () {
      final levels = Levels(
        accountId: 1,
        attack: 10,
        defence: 10,
        strength: 10,
        hitpoints: 10,
        ranged: 10,
        prayer: 10,
        magic: 10,
        cooking: 10,
        woodcutting: 10,
        fletching: 10,
        fishing: 10,
        firemaking: 10,
        crafting: 10,
        smithing: 10,
        mining: 10,
        herblore: 10,
        agility: 10,
        thieving: 10,
        slayer: 10,
        farming: 10,
        runecraft: 10,
        hunter: 10,
        construction: 10,
      );

      // 23 skills * 10 = 230
      expect(levels.totalLevel, 230);
    });

    test('skillEntries returns all 23 skills with correct order', () {
      final levels = Levels(
        accountId: 1,
        attack: 1,
        defence: 2,
        strength: 3,
        hitpoints: 4,
        ranged: 5,
        prayer: 6,
        magic: 7,
        cooking: 8,
        woodcutting: 9,
        fletching: 10,
        fishing: 11,
        firemaking: 12,
        crafting: 13,
        smithing: 14,
        mining: 15,
        herblore: 16,
        agility: 17,
        thieving: 18,
        slayer: 19,
        farming: 20,
        runecraft: 21,
        hunter: 22,
        construction: 23,
      );

      final entries = levels.skillEntries;

      expect(entries.length, 23);
      expect(entries[0].key, 'Attack');
      expect(entries[0].value, 1);
      expect(entries[22].key, 'Construction');
      expect(entries[22].value, 23);
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{
        'account_id': 100,
        // All other fields missing
      };

      final levels = Levels.fromJson(json);

      expect(levels.accountId, 100);
      expect(levels.attack, 1);
      expect(levels.hitpoints, 10); // Hitpoints defaults to 10
      expect(levels.defence, 1);
    });

    test('toString returns formatted string', () {
      final levels = Levels(
        accountId: 999,
        attack: 50,
        defence: 50,
        strength: 50,
        hitpoints: 50,
        ranged: 50,
        prayer: 50,
        magic: 50,
        cooking: 50,
        woodcutting: 50,
        fletching: 50,
        fishing: 50,
        firemaking: 50,
        crafting: 50,
        smithing: 50,
        mining: 50,
        herblore: 50,
        agility: 50,
        thieving: 50,
        slayer: 50,
        farming: 50,
        runecraft: 50,
        hunter: 50,
        construction: 50,
      );

      final str = levels.toString();

      expect(str, contains('accountId: 999'));
      expect(str, contains('totalLevel: 1150'));
    });
  });
}
