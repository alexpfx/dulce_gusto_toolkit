import 'package:dulce_gusto_toolkit/drawer_menu.dart';
import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  final Widget body;
  final String title;
  final FloatingActionButton fab;
  final List<Widget> actions;

  Page({this.title, this.body, this.fab, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      drawer: DrawerMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: fab,
      body: body,
    );
  }
}
