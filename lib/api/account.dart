enum AccountStatus {
  ACTIVE,
  INACTIVE,
  BANNED,
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
        (element) => element.toString().toLowerCase() == json['status'],
        orElse: () => AccountStatus.ACTIVE,
      ),
    );
  }
}
