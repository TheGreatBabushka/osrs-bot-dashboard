class AccountActivity {
  int accountId;
  String command;
  String startedAt;
  String stoppedAt;
  int processId;

  AccountActivity({
    required this.accountId,
    required this.command,
    required this.startedAt,
    required this.stoppedAt,
    required this.processId,
  });

  factory AccountActivity.fromJson(Map<String, dynamic> json) {
    return AccountActivity(
      accountId: json['account_id'],
      command: json['command'],
      startedAt: json['started_at'],
      stoppedAt: json['stopped_at'],
      processId: json['pid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'command': command,
      'started_at': startedAt,
      'stopped_at': stoppedAt,
      'pid': processId,
    };
  }

  @override
  String toString() {
    return 'AccountActivity{account_id: $accountId, command: $command, started_at: $startedAt, stopped_at: $stoppedAt, process_id: $processId}';
  }
}
