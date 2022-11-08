import 'package:flutter/material.dart';

/// Stops the default pop and instead pops with the specified value
class CatchPop extends StatelessWidget {
  const CatchPop({
    super.key,
    this.popValue,
    this.withConfirmExit = false,
    required this.child,
  });

  final Widget child;
  final dynamic popValue;
  final bool withConfirmExit;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (withConfirmExit) {
          var res = await _showExitWithoutSaveDialog(context);
          if (!res) return false;
        }
        // This will pop the stateless widget:
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(popValue);
        return false;
      },
      child: child,
    );
  }

  static Future<bool> _showExitWithoutSaveDialog(BuildContext context) async {
    var res = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: const Text('Do you want to exit without saving?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.pop(c, true),
          ),
        ],
      ),
    );
    return res ?? false;
  }
}
