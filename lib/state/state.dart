import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:osrs_bot_dashboard/state/app_state.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  const _InheritedStateContainer({
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(covariant _InheritedStateContainer oldWidget) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;

  const StateContainer({
    super.key,
    required this.child,
  });

  static StateContainerState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()!
        .data;
  }

  @override
  State<StateContainer> createState() => StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  AppState current = AppState();

  void setAppState(AppState appState) {
    setState(() {
      current = appState;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("DashboardStateState.build");
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
