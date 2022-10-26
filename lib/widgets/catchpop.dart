import 'package:flutter/cupertino.dart';

/// Stops the default pop and instead pops with the specified value
class CatchPop extends StatelessWidget {
  const CatchPop({super.key, required this.popValue, required this.child});

  final Widget child;
  final dynamic popValue;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(popValue);
        return false;
      },
      child: child,
    );
  }
}
