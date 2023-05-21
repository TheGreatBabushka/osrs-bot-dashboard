import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget _child;
  final Widget _title;

  const DashboardCard({super.key, required Widget child, required Widget title})
      : _child = child,
        _title = title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _title,
              ],
            ),
            const Divider(height: 5),
            _child,
          ],
        ),
      ),
    );
  }
}
