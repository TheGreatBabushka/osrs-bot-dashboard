import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/accounts_view.dart';
import 'package:osrs_bot_dashboard/dashboard.dart';
import 'package:osrs_bot_dashboard/dialog/add_account_dialog.dart';
import 'package:osrs_bot_dashboard/dialog/scripts_dialog.dart';
import 'package:osrs_bot_dashboard/dialog/settings_dialog.dart';
import 'package:osrs_bot_dashboard/model/activity_model.dart';
import 'package:osrs_bot_dashboard/state/scripts_model.dart';
import 'package:osrs_bot_dashboard/state/settings_model.dart';
import 'package:provider/provider.dart';

import 'accounts_list_card.dart';
import 'api/accounts_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsModel(),
      child: Consumer<SettingsModel>(
        builder: (context, settingsModel, child) {
          if (settingsModel.isLoading) {
            return MaterialApp(
              title: 'OSRS Bot Dashboard',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.green.shade500,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: const Text('OSRS Bot Dashboard'),
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => ScriptsModel()),
              ChangeNotifierProvider(create: (context) => AccountsModel(settingsModel)),
              ChangeNotifierProvider(create: (context) => AccountActivityModel(settingsModel)),
            ],
            child: MaterialApp(
              title: 'OSRS Bot Dashboard',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.green.shade500,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              home: const MyHomePage(title: 'OSRS Bot Dashboard'),
            ),
          );
        },
      ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Manage Scripts',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ScriptsDialog(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
          ),
        ],
      ),
      body: const AccountsView(),
      floatingActionButton: Builder(
        builder: (BuildContext scaffoldContext) {
          return FloatingActionButton(
            onPressed: () {
              final settingsModel = Provider.of<SettingsModel>(scaffoldContext, listen: false);
              final accountsModel = Provider.of<AccountsModel>(scaffoldContext, listen: false);
              showDialog(
                context: scaffoldContext,
                builder: (_) => AddAccountDialog(
                  apiIp: settingsModel.apiIp,
                  onAccountAdded: () {
                    accountsModel.fetchAccounts();
                  },
                ),
              );
            },
            tooltip: 'Add Account',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
