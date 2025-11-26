/// Represents the skill levels for an OSRS account.
///
/// OSRS has 23 skills, each with a level (1-99+) and experience points.
class Levels {
  final int accountId;
  final int attack;
  final int defence;
  final int strength;
  final int hitpoints;
  final int ranged;
  final int prayer;
  final int magic;
  final int cooking;
  final int woodcutting;
  final int fletching;
  final int fishing;
  final int firemaking;
  final int crafting;
  final int smithing;
  final int mining;
  final int herblore;
  final int agility;
  final int thieving;
  final int slayer;
  final int farming;
  final int runecraft;
  final int hunter;
  final int construction;

  Levels({
    required this.accountId,
    required this.attack,
    required this.defence,
    required this.strength,
    required this.hitpoints,
    required this.ranged,
    required this.prayer,
    required this.magic,
    required this.cooking,
    required this.woodcutting,
    required this.fletching,
    required this.fishing,
    required this.firemaking,
    required this.crafting,
    required this.smithing,
    required this.mining,
    required this.herblore,
    required this.agility,
    required this.thieving,
    required this.slayer,
    required this.farming,
    required this.runecraft,
    required this.hunter,
    required this.construction,
  });

  factory Levels.fromJson(Map<String, dynamic> json) {
    return Levels(
      accountId: json['account_id'] ?? 0,
      attack: json['attack'] ?? 1,
      defence: json['defence'] ?? 1,
      strength: json['strength'] ?? 1,
      hitpoints: json['hitpoints'] ?? 10,
      ranged: json['ranged'] ?? 1,
      prayer: json['prayer'] ?? 1,
      magic: json['magic'] ?? 1,
      cooking: json['cooking'] ?? 1,
      woodcutting: json['woodcutting'] ?? 1,
      fletching: json['fletching'] ?? 1,
      fishing: json['fishing'] ?? 1,
      firemaking: json['firemaking'] ?? 1,
      crafting: json['crafting'] ?? 1,
      smithing: json['smithing'] ?? 1,
      mining: json['mining'] ?? 1,
      herblore: json['herblore'] ?? 1,
      agility: json['agility'] ?? 1,
      thieving: json['thieving'] ?? 1,
      slayer: json['slayer'] ?? 1,
      farming: json['farming'] ?? 1,
      runecraft: json['runecraft'] ?? 1,
      hunter: json['hunter'] ?? 1,
      construction: json['construction'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'attack': attack,
      'defence': defence,
      'strength': strength,
      'hitpoints': hitpoints,
      'ranged': ranged,
      'prayer': prayer,
      'magic': magic,
      'cooking': cooking,
      'woodcutting': woodcutting,
      'fletching': fletching,
      'fishing': fishing,
      'firemaking': firemaking,
      'crafting': crafting,
      'smithing': smithing,
      'mining': mining,
      'herblore': herblore,
      'agility': agility,
      'thieving': thieving,
      'slayer': slayer,
      'farming': farming,
      'runecraft': runecraft,
      'hunter': hunter,
      'construction': construction,
    };
  }

  /// Returns the total level (sum of all skills).
  int get totalLevel =>
      attack +
      defence +
      strength +
      hitpoints +
      ranged +
      prayer +
      magic +
      cooking +
      woodcutting +
      fletching +
      fishing +
      firemaking +
      crafting +
      smithing +
      mining +
      herblore +
      agility +
      thieving +
      slayer +
      farming +
      runecraft +
      hunter +
      construction;

  /// Returns a list of skill entries as (name, level) pairs.
  List<MapEntry<String, int>> get skillEntries => [
        MapEntry('Attack', attack),
        MapEntry('Defence', defence),
        MapEntry('Strength', strength),
        MapEntry('Hitpoints', hitpoints),
        MapEntry('Ranged', ranged),
        MapEntry('Prayer', prayer),
        MapEntry('Magic', magic),
        MapEntry('Cooking', cooking),
        MapEntry('Woodcutting', woodcutting),
        MapEntry('Fletching', fletching),
        MapEntry('Fishing', fishing),
        MapEntry('Firemaking', firemaking),
        MapEntry('Crafting', crafting),
        MapEntry('Smithing', smithing),
        MapEntry('Mining', mining),
        MapEntry('Herblore', herblore),
        MapEntry('Agility', agility),
        MapEntry('Thieving', thieving),
        MapEntry('Slayer', slayer),
        MapEntry('Farming', farming),
        MapEntry('Runecraft', runecraft),
        MapEntry('Hunter', hunter),
        MapEntry('Construction', construction),
      ];

  @override
  String toString() {
    return 'Levels{accountId: $accountId, totalLevel: $totalLevel}';
  }
}
