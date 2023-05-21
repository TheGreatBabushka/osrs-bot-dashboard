class Account {
  String id;
  String username;
  String email;

  Account({required this.id, required this.username, required this.email});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
