class Account {
  String id;
  String name;
  String script;
  bool isRunning;

  Account(this.id, this.name, this.script, this.isRunning);
}

class BotRequests {
  static const String BASE_URL = "http://localhost:8080";

  static Future<List<Account>> getAccounts() async {
    List<Account> accounts = [];
    accounts.add(Account("1", "KadKudin", "NewbTrainer", true));
    accounts.add(Account("2", "TheBeazt32", "Fightaholic", false));
    accounts.add(Account("3", "Skeeter144", "Fightaholic", false));
    accounts.add(Account("4", "Skeeter144", "Fightaholic", false));
    accounts.add(Account("5", "Skeeter144", "Fightaholic", false));
    return Future.delayed(const Duration(seconds: 1), () => accounts);
  }
}
