import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_tile.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/coupons/menu_constants.dart';
import 'package:dulce_gusto_toolkit/coupons/preference_screen/dolce_gusto_preference_screen.dart';
import 'package:dulce_gusto_toolkit/coupons/redeem_screen/login_state_widget.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// TODO: criar novo status e mostrar mensagem quando nao foi possivel resgatar.
/// TODO: ir para a pagina de cupons.
/// TODO: permitir que o botao seja executado imediantemente. O botão vai ser substituido por uma barra de progresso
/// depois do click ate que o comando seja executado.
///
///
///
class RedeemScreen extends StatefulWidget {
  final List<Coupon> coupons;

  RedeemScreen({@required this.coupons});

  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  var _username;
  var _pass;
  var _bloc = ConnectionBloc(DolceGustoSession(_createDio()));

  loadPreferences() async {
    var sh = await SharedPreferences.getInstance();
    _username = sh.getString(kDolceGustoLoginKey);
    _pass = sh.getString(kDolceGustoPassKey);
  }

  @override
  void initState() {
    loadPreferences();
  }

  _RedeemScreenState();

  @override
  Widget build(BuildContext context) {
    print('context 1: $context');
    return Scaffold(
      appBar: AppBar(
        title: Text('Resgate de Códigos'),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: _menuBuilder,
            onSelected: _choiceAction,
          )
        ],
      ),
      body: BlocProvider<ConnectionBloc>(
        builder: (context) => _bloc,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: _builder,
                itemCount: widget.coupons.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: kDefaultBarHeight,
                child: _blocBuilderHandleLoginState(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, int index) {
    return CouponTile(
        widget.coupons[index].code, Icons.fiber_new, Colors.white);
  }

  List<PopupMenuEntry<String>> _menuBuilder(BuildContext context) {
    return [
      kBuildMenuItem(Icons.verified_user, "Dc Credentials", "credentials"),
    ];
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
    }
  }

  Future _redeemButtonPress() async {}

  Widget status() {}

  @override
  void dispose() {
    super.dispose();
  }

  Widget _blocBuilderHandleLoginState(BuildContext _context) {
    print('context button $_context');
    return LoginStateWidget(
      redeemButtonPress: _redeemButtonPress,
      connectButtonPress: _connectButtonPress,
    );
  }

  _connectButtonPress() async {
    var bloc = _bloc;
    await loadPreferences();
    print('login: $_username');
    print('pass: $_pass');
    bloc.dispatch(LoginDgEvent(UserCredentials(_username, _pass)));
  }

  static Dio _createDio() {
    var cookieManager = CookieManager(CookieJar());
    Dio dio = Dio()
      ..options = BaseOptions(
          contentType: ContentType.parse("application/x-www-form-urlencoded"),
          followRedirects: false,
          validateStatus: (s) => s < 500)
      ..interceptors.add(cookieManager);
    return dio;
  }
}
