import 'package:flutter/material.dart';

/// Provides icons for OSRS skills using Material icons as representations.
///
/// These icons are visual representations that match the theme of each skill.
class SkillIcons {
  static IconData getIcon(String skillName) {
    switch (skillName.toLowerCase()) {
      case 'attack':
        return Icons.gps_fixed; // Crosshair for attack
      case 'defence':
        return Icons.shield; // Shield for defense
      case 'strength':
        return Icons.fitness_center; // Dumbbell for strength
      case 'hitpoints':
        return Icons.favorite; // Heart for hitpoints
      case 'ranged':
        return Icons.arrow_forward; // Arrow for ranged
      case 'prayer':
        return Icons.auto_awesome; // Star for prayer
      case 'magic':
        return Icons.auto_fix_high; // Magic wand
      case 'cooking':
        return Icons.restaurant; // Fork and knife for cooking
      case 'woodcutting':
        return Icons.park; // Tree for woodcutting
      case 'fletching':
        return Icons.arrow_upward; // Arrow for fletching
      case 'fishing':
        return Icons.set_meal; // Fish for fishing
      case 'firemaking':
        return Icons.local_fire_department; // Fire
      case 'crafting':
        return Icons.handyman; // Tools for crafting
      case 'smithing':
        return Icons.hardware; // Hammer for smithing
      case 'mining':
        return Icons.landscape; // Mountain for mining
      case 'herblore':
        return Icons.eco; // Leaf for herblore
      case 'agility':
        return Icons.directions_run; // Running for agility
      case 'thieving':
        return Icons.visibility_off; // Hidden eye for thieving
      case 'slayer':
        return Icons.dangerous; // Skull for slayer
      case 'farming':
        return Icons.grass; // Plant for farming
      case 'runecraft':
        return Icons.grain; // Rune-like for runecraft
      case 'hunter':
        return Icons.pest_control; // Trap for hunter
      case 'construction':
        return Icons.construction; // Construction icon
      default:
        return Icons.star; // Default star
    }
  }

  /// Returns the color associated with a skill category.
  static Color getColor(String skillName) {
    switch (skillName.toLowerCase()) {
      // Combat skills - red/orange tones
      case 'attack':
        return const Color(0xFFB71C1C);
      case 'strength':
        return const Color(0xFF1B5E20);
      case 'defence':
        return const Color(0xFF0D47A1);
      case 'hitpoints':
        return const Color(0xFFC62828);
      case 'ranged':
        return const Color(0xFF33691E);
      case 'prayer':
        return const Color(0xFFF9A825);
      case 'magic':
        return const Color(0xFF4A148C);
      // Gathering skills - green/brown tones
      case 'woodcutting':
        return const Color(0xFF4E342E);
      case 'fishing':
        return const Color(0xFF0277BD);
      case 'mining':
        return const Color(0xFF5D4037);
      case 'hunter':
        return const Color(0xFF795548);
      case 'farming':
        return const Color(0xFF558B2F);
      // Artisan skills - mixed tones
      case 'cooking':
        return const Color(0xFF6D4C41);
      case 'firemaking':
        return const Color(0xFFFF6F00);
      case 'fletching':
        return const Color(0xFF00695C);
      case 'crafting':
        return const Color(0xFF6A1B9A);
      case 'smithing':
        return const Color(0xFF37474F);
      case 'herblore':
        return const Color(0xFF2E7D32);
      case 'runecraft':
        return const Color(0xFF311B92);
      case 'construction':
        return const Color(0xFFBF360C);
      // Support skills
      case 'agility':
        return const Color(0xFF00838F);
      case 'thieving':
        return const Color(0xFF424242);
      case 'slayer':
        return const Color(0xFF212121);
      default:
        return const Color(0xFF455A64);
    }
  }
}
