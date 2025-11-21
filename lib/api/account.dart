enum AccountStatus {
  ACTIVE,
  INACTIVE,
  BANNED,
}

extension AccountStatusExtension on AccountStatus {
  String get label {
    switch (this) {
      case AccountStatus.ACTIVE:
        return 'Active';
      case AccountStatus.INACTIVE:
        return 'Inactive';
      case AccountStatus.BANNED:
        return 'Banned';
    }
  }
}

class Account {
  String id;
  String username;
  String email;
  AccountStatus status = AccountStatus.ACTIVE;

  Account({required this.id, required this.username, required this.email, required this.status});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'].toString(),
      username: json['username'],
      email: json['email'],
      status: AccountStatus.values.firstWhere(
        (element) => element.name.toLowerCase() == json['status']?.toString().toLowerCase(),
        orElse: () => AccountStatus.ACTIVE,
      ),
    );
  }
}
