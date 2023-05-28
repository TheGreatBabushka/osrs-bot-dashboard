import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/dashboard.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:provider/provider.dart';

import 'accounts_list_card.dart';
import 'api/bot_provider.dart';

void main() {
  runApp(const MyApp());
}

// widget with two list views beside each other - one for inactive accounts
// and one for active accounts / bots. the items in the list view have buttons
// to start / stop the bot and to edit the account. the list view items also
// have a text field to display the script name.
class AccountListWidget extends StatefulWidget {
  const AccountListWidget({super.key});

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: const [
              AccountListTile(name: "KadKudin", script: "NewbTrainer"),
              AccountListTile(name: "TheBeazt32", script: "Fightaholic"),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: const [
              AccountListTile(name: "KadKudin", script: "NewbTrainer"),
              AccountListTile(name: "TheBeazt32", script: "Fightaholic"),
            ],
          ),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSRS Bot Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'OSRS Bot Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BotsModel()),
          ChangeNotifierProvider(create: (context) => AccountActivityModel()),
        ],
        child: const BotDashboard(),
      ),
    );
  }
}
