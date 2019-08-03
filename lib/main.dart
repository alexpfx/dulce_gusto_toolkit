import 'package:dulce_gusto_toolkit/colors.dart';
import 'package:dulce_gusto_toolkit/coupons/coupons_page.dart';
import 'package:dulce_gusto_toolkit/drawer_menu.dart';
import 'package:dulce_gusto_toolkit/flavors/flavors_page.dart';
import 'package:dulce_gusto_toolkit/timer/timer_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/': (context) => CouponPage(),
        '/timer': (context) => TimerPage(),
        '/flavors': (context) => FlavorsPage(),
        '/coupons': (context) => CouponPage()
      },
      theme: ThemeData.dark().copyWith(cardColor: kCardColor),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text("Page"), drawer: DrawerMenu());
  }
}
