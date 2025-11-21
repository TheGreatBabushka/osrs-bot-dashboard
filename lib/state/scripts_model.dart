import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/script.dart';

class ScriptsModel extends ChangeNotifier {
  static const String _scriptsKey = 'scripts';
  
  final List<Script> _scripts = [];
  bool _isLoading = true;

  List<Script> get scripts => List.unmodifiable(_scripts);
  bool get isLoading => _isLoading;

  ScriptsModel() {
    _loadScripts();
  }

  Future<void> _loadScripts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final scriptsJson = prefs.getString(_scriptsKey);
      
      if (scriptsJson != null) {
        final List<dynamic> scriptsList = jsonDecode(scriptsJson);
        _scripts.clear();
        _scripts.addAll(scriptsList.map((json) => Script.fromJson(json)));
      } else {
        // Initialize with default scripts if none exist
        _scripts.addAll([
          Script(name: 'NewbTrainer'),
          Script(name: 'KillerCowhideTanner'),
        ]);
        await _saveScripts();
      }
    } catch (e) {
      debugPrint('Error loading scripts: $e');
      // Initialize with default scripts on error
      _scripts.clear();
      _scripts.addAll([
        Script(name: 'NewbTrainer'),
        Script(name: 'KillerCowhideTanner'),
      ]);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scriptsJson = jsonEncode(_scripts.map((s) => s.toJson()).toList());
      await prefs.setString(_scriptsKey, scriptsJson);
    } catch (e) {
      debugPrint('Error saving scripts: $e');
    }
  }

  Future<void> addScript(Script script) async {
    // Check for duplicate names
    if (_scripts.any((s) => s.name == script.name)) {
      debugPrint('Script with name "${script.name}" already exists');
      return;
    }

    _scripts.add(script);
    await _saveScripts();
    notifyListeners();
  }

  Future<void> updateScript(String oldName, Script newScript) async {
    final index = _scripts.indexWhere((s) => s.name == oldName);
    if (index == -1) {
      debugPrint('Script with name "$oldName" not found');
      return;
    }

    // Check if new name conflicts with existing script (excluding the one being updated)
    if (oldName != newScript.name && 
        _scripts.any((s) => s.name == newScript.name)) {
      debugPrint('Script with name "${newScript.name}" already exists');
      return;
    }

    _scripts[index] = newScript;
    await _saveScripts();
    notifyListeners();
  }

  Future<void> deleteScript(String name) async {
    _scripts.removeWhere((s) => s.name == name);
    await _saveScripts();
    notifyListeners();
  }

  Script? getScript(String name) {
    try {
      return _scripts.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }
}
