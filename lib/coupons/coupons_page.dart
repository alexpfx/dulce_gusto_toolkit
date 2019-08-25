import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_status_panel.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_card.dart';
import 'package:dulce_gusto_toolkit/coupons/menu_constants.dart';
import 'package:dulce_gusto_toolkit/coupons/preference_screen/dolce_gusto_preference_screen.dart';
import 'package:dulce_gusto_toolkit/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/user_info/get_user_info.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
//import 'package:provider/provider.dart';

/*
  TODO's:
   - botao limpar invalidos
   - criar label para as datas que aparecem ('adicionado em', 'resgatado em',...)
   - ao clicar no icone de status mostrar hint.

 */

const kCardHeight = 72.0;

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  List<Coupon> _coupons = [];

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _pass = "";

  ScaffoldState scaffold;

  @override
  void initState() {
    _coupons.add(Coupon("XSXS AAAA BBCD",
        dateAdded: DateTime.now(), status: Status.added_new));
    _coupons.add(Coupon("XNSX NSFN NNFA",
        dateAdded: DateTime.now(), status: Status.added_new));
    _coupons.add(Coupon("AAAA ZPTA ABDD",
        dateAdded: DateTime.now(), status: Status.redeemed));
    _coupons.add(Coupon("ZAFA BTAA ABXP",
        dateAdded: DateTime.now(), status: Status.redeemed));

    _coupons.add(Coupon("XSXS AAAA BBCD",
        dateAdded: DateTime.now(), status: Status.added_new));
    _coupons.add(Coupon("XNSX NSFN NNFA",
        dateAdded: DateTime.now(), status: Status.added_new));
    _coupons.add(Coupon("AAAA ZPTA ABDD",
        dateAdded: DateTime.now(), status: Status.redeemed));
    _coupons.add(Coupon("ZAFA BTAA ABXP",
        dateAdded: DateTime.now(), status: Status.redeemed));
    _coupons.add(Coupon("XSXS AAAA BBCD",
        dateAdded: DateTime.now(), status: Status.added_new));
    _coupons.add(Coupon("XNSX NSFN NNFA",
        dateAdded: DateTime.now(), status: Status.added_new));
    _coupons.add(Coupon("AAAA ZPTA ABDD",
        dateAdded: DateTime.now(), status: Status.added_new));
    _coupons.add(Coupon("ZAFA BTAA ABXP",
        dateAdded: DateTime.now(), status: Status.redeemed));

    loadPreferences();



    super.initState();
  }

  loadPreferences() async {
    var sh = await SharedPreferences.getInstance();
    _username = sh.getString(kDolceGustoLoginKey);
    _pass = sh.getString(kDolceGustoPassKey);
  }

  @override
  Widget build(BuildContext context) {
    var connectionBloc = BlocProvider.of<GetUserInfoBloc>(context);
    connectionBloc.dispatch(GetUserInfoEventImpl(
        new DolceGustoSession(Dio(), UserCredentials(_username, _pass))
    ));

    return Page(
      title: 'My Coupons',
      body: _pageBuilder(context),
      actions: <Widget>[
        PopupMenuButton<String>(
          itemBuilder: _menuItemBuilder,
          onSelected: _choiceAction,
        ),
      ],
    );
  }

  _pageBuilder(context) => Container(
        child: Column(
          children: <Widget>[
            BonusStatusPanel(),
            Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _coupons.length,
                itemBuilder: _itemBuilder,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlineButton(
                    child: Text('Limpar resgatados'),
                    onPressed: () {},
                  ),
                  RaisedButton(
                    onPressed: () {
                    },
                    child: Text('Resgatar Todos'),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Random r = Random();

  Widget _itemBuilder(BuildContext context, int index) {
    var coupon = _coupons[index];
    return CouponCard(
      coupon: coupon,
      height: 56,
      onCouponClick: (x) {},
    );
  }

  _choiceAction(String action) {
    switch (action) {
      case "credentials":
        Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                settings: RouteSettings(),
                builder: (context) => DolceGustoCredentialsPreferenceScreen()));
        break;
      case "sort":
        _coupons.sort(
          (a, b) => (a.status == Status.added_new)
              ? -1
              : b.status == Status.added_new
                  ? 1
                  : a.status.hashCode.compareTo(b.status.hashCode),
        );
        setState(() {});
        break;
    }
  }

  List<PopupMenuEntry<String>> _menuItemBuilder(BuildContext context) {
    return [
      kBuildMenuItem(Icons.sort, "Sort", "sort"),
      kBuildMenuItem(Icons.verified_user, 'Credentials', 'credentials')
    ];
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  SectionTitle({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      margin: EdgeInsets.only(top: 16),
      child: Container(
        height: 64,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 4,
            ),
            Text(subtitle, style: Theme.of(context).textTheme.caption)
          ],
        ),
      ),
    );
  }
}
