import 'package:flutter_test/flutter_test.dart';
import 'package:osrs_bot_dashboard/api/account_activity.dart';

void main() {
  group('AccountActivity', () {
    test('fromJson creates AccountActivity correctly', () {
      final json = {
        'id': 1,
        'account_id': 123,
        'command': 'woodcutting',
        'started_at': '2024-01-01T10:00:00Z',
        'stopped_at': '2024-01-01T12:00:00Z',
        'pid': 4567,
      };

      final activity = AccountActivity.fromJson(json);

      expect(activity.id, equals(1));
      expect(activity.accountId, equals(123));
      expect(activity.command, equals('woodcutting'));
      expect(activity.startedAt, equals('2024-01-01T10:00:00Z'));
      expect(activity.stoppedAt, equals('2024-01-01T12:00:00Z'));
      expect(activity.processId, equals(4567));
    });

    test('fromJson handles missing id field', () {
      final json = {
        'account_id': 123,
        'command': 'woodcutting',
        'started_at': '2024-01-01T10:00:00Z',
        'stopped_at': '2024-01-01T12:00:00Z',
        'pid': 4567,
      };

      final activity = AccountActivity.fromJson(json);

      expect(activity.id, isNull);
      expect(activity.accountId, equals(123));
      expect(activity.command, equals('woodcutting'));
    });

    test('toJson converts AccountActivity to correct JSON format', () {
      final activity = AccountActivity(
        id: 1,
        accountId: 456,
        command: 'fishing',
        startedAt: '2024-01-02T14:30:00Z',
        stoppedAt: '2024-01-02T16:30:00Z',
        processId: 8910,
      );

      final json = activity.toJson();

      expect(json['id'], equals(1));
      expect(json['account_id'], equals(456));
      expect(json['command'], equals('fishing'));
      expect(json['started_at'], equals('2024-01-02T14:30:00Z'));
      expect(json['stopped_at'], equals('2024-01-02T16:30:00Z'));
      expect(json['pid'], equals(8910));
    });

    test('fromJson and toJson are symmetric', () {
      final originalJson = {
        'id': 1,
        'account_id': 789,
        'command': 'mining',
        'started_at': '2024-01-03T08:00:00Z',
        'stopped_at': '2024-01-03T10:00:00Z',
        'pid': 1112,
      };

      final activity = AccountActivity.fromJson(originalJson);
      final reconstructedJson = activity.toJson();

      expect(reconstructedJson, equals(originalJson));
    });

    test('toString returns formatted string', () {
      final activity = AccountActivity(
        id: 1,
        accountId: 111,
        command: 'combat',
        startedAt: '2024-01-04T12:00:00Z',
        stoppedAt: '2024-01-04T13:00:00Z',
        processId: 2222,
      );

      final stringRepresentation = activity.toString();

      expect(stringRepresentation, contains('id: 1'));
      expect(stringRepresentation, contains('account_id: 111'));
      expect(stringRepresentation, contains('command: combat'));
      expect(stringRepresentation, contains('started_at: 2024-01-04T12:00:00Z'));
      expect(stringRepresentation, contains('stopped_at: 2024-01-04T13:00:00Z'));
      expect(stringRepresentation, contains('process_id: 2222'));
    });
  });
}
