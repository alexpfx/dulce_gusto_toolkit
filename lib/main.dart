import 'package:dulce_gusto_toolkit/colors.dart';
import 'package:dulce_gusto_toolkit/coupons/coupons_page.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/drawer_menu.dart';
import 'package:dulce_gusto_toolkit/flavors/flavors_page.dart';
import 'package:dulce_gusto_toolkit/timer/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'coupons/bloc/connection/conn.dart';
import 'coupons/bloc/redeem/redeem.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<ConnectionBloc>(
        builder: (context) => ConnectionBloc(),
      ), BlocProvider<RedeemBloc>(
        builder: (context) => RedeemBloc(),
      )],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routes: {
          '/': (context) => CouponPage(),
          '/timer': (context) => TimerPage(),
          '/flavors': (context) => FlavorsPage(),
          '/coupons': (context) => CouponPage()
        },
        theme: ThemeData.dark().copyWith(cardColor: kCardColor),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text("Page"), drawer: DrawerMenu());
  }
}
