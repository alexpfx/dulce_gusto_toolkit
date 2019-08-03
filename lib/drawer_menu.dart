import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:dulce_gusto_toolkit/model/page_summary.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  Widget _mapPages(PageSummary page, BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, page.route);
      },
      leading: Icon(
        page.icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        page.title,
        style: Theme.of(context).textTheme.subhead,
      ),
      subtitle: Text(
        page.subtitle,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Dolce Gusto Toolkit",
              style: Theme.of(context).textTheme.display1,
            ),
          ),
          ...pages.map((p) => _mapPages(p, context)).toList(),
        ],
      ),
    );
  }
}
