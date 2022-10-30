import 'package:flutter/material.dart';

class RoundedPage extends StatelessWidget {
  const RoundedPage({
    super.key,
    this.title,
    this.floatingActionButton,
    this.onRefresh,
    this.appBarActions,
    this.roundedMargin = 20,
    this.bodyMargin = 40,
    required this.child,
  });

  final String? title;
  final Widget child;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;
  final List<Widget>? appBarActions;
  final double roundedMargin;
  final double bodyMargin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: title != null ? Text(title!) : null,
        actions: appBarActions,
      ),
      floatingActionButton: floatingActionButton,
      body: Scaffold(
        body: Center(
          child: onRefresh == null
              ? _getBody(context)
              : _getBodyWithRefesh(context),
        ),
      ),
    );
  }

  Widget _getBodyWithRefesh(context) {
    assert(onRefresh != null);
    return RefreshIndicator(
      onRefresh: onRefresh!,
      child: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).primaryColor,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: roundedMargin),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: bodyMargin),
              child: child,
            ),
          ],
        ),
      ],
    );
  }
}
