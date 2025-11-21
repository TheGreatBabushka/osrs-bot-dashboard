import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/model/script.dart';
import 'package:osrs_bot_dashboard/state/scripts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ScriptsModel', () {
    setUp(() {
      // Initialize shared preferences with empty values for each test
      SharedPreferences.setMockInitialValues({});
    });

    test('initializes with default scripts when no saved data exists', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(model.scripts.length, equals(2));
      expect(model.scripts[0].name, equals('NewbTrainer'));
      expect(model.scripts[1].name, equals('KillerCowhideTanner'));
      expect(model.isLoading, isFalse);
    });

    test('can add a new script', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final initialCount = model.scripts.length;
      
      // Add a new script
      final newScript = Script(name: 'TestScript', parameters: 'param1 param2');
      await model.addScript(newScript);
      
      expect(model.scripts.length, equals(initialCount + 1));
      expect(model.scripts.last.name, equals('TestScript'));
      expect(model.scripts.last.parameters, equals('param1 param2'));
    });

    test('can add a script without parameters', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final newScript = Script(name: 'SimpleScript');
      await model.addScript(newScript);
      
      final addedScript = model.getScript('SimpleScript');
      expect(addedScript, isNotNull);
      expect(addedScript!.name, equals('SimpleScript'));
      expect(addedScript.parameters, isNull);
    });

    test('prevents duplicate script names', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final initialCount = model.scripts.length;
      
      // Try to add a script with a duplicate name
      final duplicateScript = Script(name: 'NewbTrainer', parameters: 'test');
      await model.addScript(duplicateScript);
      
      // Count should not change
      expect(model.scripts.length, equals(initialCount));
    });

    test('can update an existing script', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Update the first script
      final updatedScript = Script(
        name: 'NewbTrainerV2',
        parameters: 'updated params',
      );
      await model.updateScript('NewbTrainer', updatedScript);
      
      final script = model.getScript('NewbTrainerV2');
      expect(script, isNotNull);
      expect(script!.name, equals('NewbTrainerV2'));
      expect(script.parameters, equals('updated params'));
      
      // Old name should not exist
      expect(model.getScript('NewbTrainer'), isNull);
    });

    test('can delete a script', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final initialCount = model.scripts.length;
      
      await model.deleteScript('NewbTrainer');
      
      expect(model.scripts.length, equals(initialCount - 1));
      expect(model.getScript('NewbTrainer'), isNull);
    });

    test('can retrieve a script by name', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final script = model.getScript('NewbTrainer');
      expect(script, isNotNull);
      expect(script!.name, equals('NewbTrainer'));
    });

    test('returns null for non-existent script', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final script = model.getScript('NonExistent');
      expect(script, isNull);
    });

    test('persists scripts across model instances', () async {
      final model = ScriptsModel();
      
      // Wait for the model to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Add a custom script
      final customScript = Script(name: 'CustomScript', parameters: 'test params');
      await model.addScript(customScript);
      
      // Create a new model instance
      final newModel = ScriptsModel();
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify the custom script persisted
      final script = newModel.getScript('CustomScript');
      expect(script, isNotNull);
      expect(script!.name, equals('CustomScript'));
      expect(script.parameters, equals('test params'));
    });
  });

  group('Script', () {
    test('can serialize to JSON', () {
      final script = Script(name: 'TestScript', parameters: 'param1 param2');
      final json = script.toJson();
      
      expect(json['name'], equals('TestScript'));
      expect(json['parameters'], equals('param1 param2'));
    });

    test('can deserialize from JSON', () {
      final json = {
        'name': 'TestScript',
        'parameters': 'param1 param2',
      };
      
      final script = Script.fromJson(json);
      
      expect(script.name, equals('TestScript'));
      expect(script.parameters, equals('param1 param2'));
    });

    test('handles null parameters in JSON', () {
      final json = {
        'name': 'TestScript',
        'parameters': null,
      };
      
      final script = Script.fromJson(json);
      
      expect(script.name, equals('TestScript'));
      expect(script.parameters, isNull);
    });
  });
}
