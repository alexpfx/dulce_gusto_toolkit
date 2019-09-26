import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:dulce_gusto_toolkit/coupons/add_code_widget.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/user_info/get_user_info.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/bonus_list.dart';
import 'package:dulce_gusto_toolkit/coupons/client_info_panel_widget.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/redeem_status.dart';
import 'package:dulce_gusto_toolkit/coupons/menu_constants.dart';
import 'package:dulce_gusto_toolkit/coupons/preference_screen/credentials_settings_screen.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:dulce_gusto_toolkit/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future _loadPreferencesFuture;

  GetUserInfoBloc connBloc;

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _pass;

  ScaffoldState scaffold;

  bool get hasCredentials =>
      _username != null &&
      _username.isNotEmpty &&
      _pass != null &&
      _pass.isNotEmpty;

  @override
  initState() {
    _loadPreferencesFuture = loadPreferences();
    super.initState();
  }

  @override
  dispose() {
//    syncBloc.dispose();
//    connBloc.dispose();
    super.dispose();
  }

  Future<void> loadPreferences() async {
    var sh = await SharedPreferences.getInstance();
    _username = sh.getString(kDolceGustoLoginKey);
    _pass = sh.getString(kDolceGustoPassKey);
  }

  @override
  Widget build(BuildContext context) {
    connBloc = BlocProvider.of<GetUserInfoBloc>(context);

    getUserInfo(context);



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

  Future getUserInfo(BuildContext context) async {
    if (hasCredentials) {
      connBloc.dispatch(GetUserInfoEventImpl(_username, _pass));
    }
  }

  _pageBuilder(context) {
    return Container(
      child: FutureBuilder(
        future: _loadPreferencesFuture,
        builder: (context, snapshot) => Center(
          child: snapshot.connectionState == ConnectionState.done
              ? Column(
                  children: <Widget>[
                    AddCodeWidget(_onAddButtonPressed),
                    Expanded(
                      child: BonusList(UserCredentials(_username, _pass)),
                    ),
                    ClientInfoPanelWidget(
                        _onChangeCredentials, _onRefreshClientInfo),
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
                            onPressed: () {},
                            child: Text('Resgatar Todos'),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  void onWillPop() {
    _loadPreferencesFuture = loadPreferences();
  }

  _choiceAction(String action) {
    switch (action) {
      case "credentials":
        Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                settings: RouteSettings(),
                builder: (context) =>
                    CredentialsSettingsScreen(callback: onWillPop)));
        break;
      case "sort":
        setState(() {
          _sortList();
        });
        break;
    }
  }

  void _sortList() {
/*    _coupons.sort(
          (a, b) => (a.status == Status.added_new)
          ? -1
          : b.status == Status.added_new
          ? 1
          : a.status.hashCode.compareTo(b.status.hashCode),
    );*/
  }

  List<PopupMenuEntry<String>> _menuItemBuilder(BuildContext context) {
    return [
      kBuildMenuItem(Icons.sort, "Sort", "sort"),
      kBuildMenuItem(Icons.verified_user, 'Credentials', 'credentials')
    ];
  }

  void _onChangeCredentials() {
    print('onChangeCredentials');
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            settings: RouteSettings(),
            builder: (context) => CredentialsSettingsScreen()));
  }

  void _onRefreshClientInfo() {
    getUserInfo(context);
  }

  _onAddButtonPressed(String code) {
    var coupon = Coupon(
        code: code,
        dateAdded: DateTime.now(),
        status: Status.redeemed,
        redeemAttempt:
            RedeemAttempt(status: RedeemResultStatus.newBonus, message: ""));


    var syncBloc = BlocProvider.of<SynchronizeBonusBloc>(context);

    syncBloc.dispatch(StoreBonus(coupon));
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
