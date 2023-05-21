import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/dashboard.dart';
import 'package:provider/provider.dart';

import 'accounts_list_tile.dart';
import 'api/bot_provider.dart';
import 'bots_overview_widget.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final String _selectedPanel = "";

  ExpansionPanel _createPanel(String title, Widget body, Icon icon) {
    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            leading: icon,
            title: Text(title),
          );
        },
        body: body,
        isExpanded: _selectedPanel == title);
  }

  @override
  Widget build(BuildContext context) {
    // List panels = [
    //   _createPanel(
    //       "Bots", const BotsOverviewWidget(), const Icon(Icons.android)),
    //   _createPanel(
    //       "Accounts", const Text("Accounts"), const Icon(Icons.account_circle)),
    //   _createPanel("Scripts", const Text("Scripts"), const Icon(Icons.code)),
    //   _createPanel(
    //       "Settings", const Text("Settings"), const Icon(Icons.settings)),
    // ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ChangeNotifierProvider(
          create: (BuildContext context) => BotProvider(),
          child: const BotDashboard()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
