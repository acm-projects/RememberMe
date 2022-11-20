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
    this.useListView = true,
    this.leading,
    required this.child,
  });

  final String? title;
  final Widget child;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;
  final List<Widget>? appBarActions;
  final double roundedMargin;
  final double bodyMargin;
  final bool useListView;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    Widget body = Stack(
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
    );

    if (useListView) {
      body = ListView(
        children: [body],
      );
    }

    if (onRefresh != null) {
      body = RefreshIndicator(
        onRefresh: onRefresh!,
        child: body,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 85,
        elevation: 0,
        flexibleSpace:
        // FlexibleSpaceBar(
        //   centerTitle: true,
        //     title:
        //     title != null ? Text(title!,
        //       style: TextStyle(fontSize: 25, fontFamily: 'BoldMontserrat', fontWeight: FontWeight.bold,
        //           color: Color.fromARGB(250, 250, 250, 250)),) : null
        // ),
        //
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: title != null ? Center(child: Text(title!,
              style: TextStyle(fontSize: 26, fontFamily: 'BoldMontserrat', fontWeight: FontWeight.bold,
              color: Color.fromARGB(250, 250, 250, 250)),) ) : null
        ),
       //title: title != null ? Text(title!) : null,
        actions: appBarActions,
        leading: leading,
      ),
      floatingActionButton: floatingActionButton,
      body: Scaffold(
        body: Center(
          child: body,
        ),
      ),
    );
  }
}
