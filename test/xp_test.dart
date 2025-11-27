import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/api/xp.dart';

void main() {
  group('Xp', () {
    test('fromJson creates Xp correctly', () {
      final json = {
        'attack': 1000,
        'defence': 2000,
        'strength': 3000,
        'hitpoints': 4000,
        'ranged': 5000,
        'prayer': 6000,
        'magic': 7000,
        'cooking': 8000,
        'woodcutting': 9000,
        'fletching': 10000,
        'fishing': 11000,
        'firemaking': 12000,
        'crafting': 13000,
        'smithing': 14000,
        'mining': 15000,
        'herblore': 16000,
        'agility': 17000,
        'thieving': 18000,
        'slayer': 19000,
        'farming': 20000,
        'runecraft': 21000,
        'hunter': 22000,
        'construction': 23000,
      };

      final xp = Xp.fromJson(json);

      expect(xp.attack, equals(1000));
      expect(xp.defence, equals(2000));
      expect(xp.strength, equals(3000));
      expect(xp.hitpoints, equals(4000));
      expect(xp.ranged, equals(5000));
      expect(xp.prayer, equals(6000));
      expect(xp.magic, equals(7000));
      expect(xp.cooking, equals(8000));
      expect(xp.woodcutting, equals(9000));
      expect(xp.fletching, equals(10000));
      expect(xp.fishing, equals(11000));
      expect(xp.firemaking, equals(12000));
      expect(xp.crafting, equals(13000));
      expect(xp.smithing, equals(14000));
      expect(xp.mining, equals(15000));
      expect(xp.herblore, equals(16000));
      expect(xp.agility, equals(17000));
      expect(xp.thieving, equals(18000));
      expect(xp.slayer, equals(19000));
      expect(xp.farming, equals(20000));
      expect(xp.runecraft, equals(21000));
      expect(xp.hunter, equals(22000));
      expect(xp.construction, equals(23000));
    });

    test('toJson converts Xp to correct JSON format', () {
      final xp = Xp(
        attack: 100,
        defence: 200,
        strength: 300,
        hitpoints: 400,
        ranged: 500,
        prayer: 600,
        magic: 700,
        cooking: 800,
        woodcutting: 900,
        fletching: 1000,
        fishing: 1100,
        firemaking: 1200,
        crafting: 1300,
        smithing: 1400,
        mining: 1500,
        herblore: 1600,
        agility: 1700,
        thieving: 1800,
        slayer: 1900,
        farming: 2000,
        runecraft: 2100,
        hunter: 2200,
        construction: 2300,
      );

      final json = xp.toJson();

      expect(json['attack'], equals(100));
      expect(json['defence'], equals(200));
      expect(json['strength'], equals(300));
      expect(json['hitpoints'], equals(400));
      expect(json['ranged'], equals(500));
      expect(json['prayer'], equals(600));
      expect(json['magic'], equals(700));
      expect(json['cooking'], equals(800));
      expect(json['woodcutting'], equals(900));
      expect(json['fletching'], equals(1000));
      expect(json['fishing'], equals(1100));
      expect(json['firemaking'], equals(1200));
      expect(json['crafting'], equals(1300));
      expect(json['smithing'], equals(1400));
      expect(json['mining'], equals(1500));
      expect(json['herblore'], equals(1600));
      expect(json['agility'], equals(1700));
      expect(json['thieving'], equals(1800));
      expect(json['slayer'], equals(1900));
      expect(json['farming'], equals(2000));
      expect(json['runecraft'], equals(2100));
      expect(json['hunter'], equals(2200));
      expect(json['construction'], equals(2300));
    });

    test('fromJson and toJson are symmetric', () {
      final originalJson = {
        'attack': 1000,
        'defence': 2000,
        'strength': 3000,
        'hitpoints': 4000,
        'ranged': 5000,
        'prayer': 6000,
        'magic': 7000,
        'cooking': 8000,
        'woodcutting': 9000,
        'fletching': 10000,
        'fishing': 11000,
        'firemaking': 12000,
        'crafting': 13000,
        'smithing': 14000,
        'mining': 15000,
        'herblore': 16000,
        'agility': 17000,
        'thieving': 18000,
        'slayer': 19000,
        'farming': 20000,
        'runecraft': 21000,
        'hunter': 22000,
        'construction': 23000,
      };

      final xp = Xp.fromJson(originalJson);
      final reconstructedJson = xp.toJson();

      expect(reconstructedJson, equals(originalJson));
    });

    test('totalXp calculates sum of all skills', () {
      final xp = Xp(
        attack: 100,
        defence: 200,
        strength: 300,
        hitpoints: 400,
        ranged: 500,
        prayer: 600,
        magic: 700,
        cooking: 800,
        woodcutting: 900,
        fletching: 1000,
        fishing: 1100,
        firemaking: 1200,
        crafting: 1300,
        smithing: 1400,
        mining: 1500,
        herblore: 1600,
        agility: 1700,
        thieving: 1800,
        slayer: 1900,
        farming: 2000,
        runecraft: 2100,
        hunter: 2200,
        construction: 2300,
      );

      // Sum: 100+200+300+...+2300 = sum of arithmetic sequence
      // n=23, a=100, d=100, sum = n/2 * (2a + (n-1)d) = 23/2 * (200 + 2200) = 23/2 * 2400 = 27600
      expect(xp.totalXp, equals(27600));
    });

    test('skillEntries returns all 23 skills with correct order', () {
      final xp = Xp(
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

      final entries = xp.skillEntries;

      expect(entries.length, equals(23));
      expect(entries[0].key, equals('Attack'));
      expect(entries[0].value, equals(1));
      expect(entries[22].key, equals('Construction'));
      expect(entries[22].value, equals(23));
    });

    test('nonZeroSkillEntries returns only skills with non-zero XP', () {
      final xp = Xp(
        attack: 1000,
        defence: 0,
        strength: 5000,
        hitpoints: 0,
        ranged: 0,
        prayer: 0,
        magic: 0,
        cooking: 0,
        woodcutting: 10000,
        fletching: 0,
        fishing: 0,
        firemaking: 0,
        crafting: 0,
        smithing: 0,
        mining: 0,
        herblore: 0,
        agility: 0,
        thieving: 0,
        slayer: 0,
        farming: 0,
        runecraft: 0,
        hunter: 0,
        construction: 0,
      );

      final nonZeroEntries = xp.nonZeroSkillEntries;

      expect(nonZeroEntries.length, equals(3));
      expect(nonZeroEntries[0].key, equals('Attack'));
      expect(nonZeroEntries[0].value, equals(1000));
      expect(nonZeroEntries[1].key, equals('Strength'));
      expect(nonZeroEntries[1].value, equals(5000));
      expect(nonZeroEntries[2].key, equals('Woodcutting'));
      expect(nonZeroEntries[2].value, equals(10000));
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final xp = Xp.fromJson(json);

      expect(xp.attack, equals(0));
      expect(xp.defence, equals(0));
      expect(xp.strength, equals(0));
      expect(xp.hitpoints, equals(0));
      expect(xp.ranged, equals(0));
      expect(xp.totalXp, equals(0));
    });

    test('toString returns formatted string', () {
      final xp = Xp(
        attack: 1000,
        defence: 0,
        strength: 0,
        hitpoints: 0,
        ranged: 0,
        prayer: 0,
        magic: 0,
        cooking: 0,
        woodcutting: 0,
        fletching: 0,
        fishing: 0,
        firemaking: 0,
        crafting: 0,
        smithing: 0,
        mining: 0,
        herblore: 0,
        agility: 0,
        thieving: 0,
        slayer: 0,
        farming: 0,
        runecraft: 0,
        hunter: 0,
        construction: 0,
      );

      final stringRepresentation = xp.toString();

      expect(stringRepresentation, contains('totalXp: 1000'));
    });
  });
}
