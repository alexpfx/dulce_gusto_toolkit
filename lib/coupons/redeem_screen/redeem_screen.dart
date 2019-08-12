import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_tile.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/coupons/menu_constants.dart';
import 'package:dulce_gusto_toolkit/coupons/preference_screen/dolce_gusto_preference_screen.dart';
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

class RedeemScreen extends StatelessWidget {
  final List<Coupon> coupons;

  RedeemScreen({@required this.coupons});

  var _username;
  var _pass;

  BuildContext context;

  loadPreferences() async {
    var sh = await SharedPreferences.getInstance();
    _username = sh.getString(kDolceGustoLoginKey);
    _pass = sh.getString(kDolceGustoPassKey);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
      body: Column(
        children: <Widget>[
          BlocListener<RedeemBloc, RedeemState>(
            bloc: BlocProvider.of<RedeemBloc>(context),
            condition: (prevState, state) {
              return state.asEnum == EnumRedeemState.succefull;
            },
            child: Expanded(
              child: ListView.builder(
                itemBuilder: _builder,
                itemCount: coupons.length,
              ),
            ),
            listener: (BuildContext context, state) {
              if (state is SuccessfulState) {
                var c = coupons.indexOf(state.coupon);

                print('coupon na lista: $c');
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              height: kDefaultBarHeight,
              child: _blocBuilderHandleLoginState(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _builder(BuildContext context, int index) {
    return CouponTile(coupons[index].code, Icons.fiber_new, Colors.white);
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

  Future _redeemButtonPress() async {
    var bloc = BlocProvider.of<RedeemBloc>(context);
    DolceGustoSession session = DolceGustoSession(Dio(), UserCredentials(_username, _pass));

    for (var coupon in coupons) {
      bloc.dispatch(RedeemCodeEvent(
          session: session, coupon: coupon));
    }
  }

  Widget status() {}

  Widget _blocBuilderHandleLoginState(BuildContext _context) {
    print('context button $_context');
    return RaisedButton(
      onPressed: _redeemButtonPress,
      child: Text('Cadastrar'),
    );
  }
}
