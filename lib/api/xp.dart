/// Represents XP data for an account or activity.
///
/// This class stores the XP gained per skill and provides utilities
/// to access and display the data.
class Xp {
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

  Xp({
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

  factory Xp.fromJson(Map<String, dynamic> json) {
    return Xp(
      attack: json['attack'] ?? 0,
      defence: json['defence'] ?? 0,
      strength: json['strength'] ?? 0,
      hitpoints: json['hitpoints'] ?? 0,
      ranged: json['ranged'] ?? 0,
      prayer: json['prayer'] ?? 0,
      magic: json['magic'] ?? 0,
      cooking: json['cooking'] ?? 0,
      woodcutting: json['woodcutting'] ?? 0,
      fletching: json['fletching'] ?? 0,
      fishing: json['fishing'] ?? 0,
      firemaking: json['firemaking'] ?? 0,
      crafting: json['crafting'] ?? 0,
      smithing: json['smithing'] ?? 0,
      mining: json['mining'] ?? 0,
      herblore: json['herblore'] ?? 0,
      agility: json['agility'] ?? 0,
      thieving: json['thieving'] ?? 0,
      slayer: json['slayer'] ?? 0,
      farming: json['farming'] ?? 0,
      runecraft: json['runecraft'] ?? 0,
      hunter: json['hunter'] ?? 0,
      construction: json['construction'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  /// Returns the total XP (sum of all skills).
  int get totalXp =>
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

  /// Returns a list of skill entries as (name, xp) pairs.
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

  /// Returns only skill entries with non-zero XP.
  List<MapEntry<String, int>> get nonZeroSkillEntries =>
      skillEntries.where((entry) => entry.value > 0).toList();

  @override
  String toString() {
    return 'Xp{totalXp: $totalXp}';
  }
}
