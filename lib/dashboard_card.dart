import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget _child;
  final Widget _title;
  final Widget? _footer;

  const DashboardCard({
    super.key,
    required Widget child,
    required Widget title,
    Widget? footer,
  })  : _child = child,
        _title = title,
        _footer = footer;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
      child: Card(
        elevation: 3,
        child: Center(
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _title,
                ],
              ),
              const Divider(height: 5),
              Expanded(child: _child),
              if (_footer != null) const Divider(height: 5),
              if (_footer != null) _footer!,
            ],
          ),
        ),
      ),
    );
  }
}
