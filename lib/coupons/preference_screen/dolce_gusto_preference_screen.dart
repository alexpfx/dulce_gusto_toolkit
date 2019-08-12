import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DolceGustoCredentialsPreferenceScreen extends StatefulWidget {
  @override
  _DolceGustoCredentialsPreferenceScreenState createState() =>
      _DolceGustoCredentialsPreferenceScreenState();
}

class _DolceGustoCredentialsPreferenceScreenState
    extends State<DolceGustoCredentialsPreferenceScreen> {
  Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool _isObscurePassword = true;
  String _user;
  String _pass;

  _onCheckConnection() {
    var connectionBloc = BlocProvider.of<ConnectionBloc>(context);
    print('user: $_user');
    connectionBloc.dispatch(
        LoginDgEvent(DolceGustoSession(Dio(), UserCredentials(_user, _pass))));
  }

  @override
  initState() {
    super.initState();
    _emailController.addListener(() {
      _user = _emailController.text;
    });
    _passController.addListener(() {
      _pass = _passController.text;
    });
    loadPreferences();
  }

  Future<bool> loadPreferences() async {
    var sp = await _sharedPreferences;
    _emailController.text = sp.getString(kDolceGustoLoginKey);
    _passController.text = sp.getString(kDolceGustoPassKey);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Credentials"),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                leading: Icon(Icons.person),
                trailing: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _emailController.clear();
                    });
                  },
                ),
              ),
              ListTile(
                title: TextField(
                  controller: _passController,
                  obscureText: _isObscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                leading: Icon(Icons.lock_outline),
                trailing: IconButton(
                    icon: Icon(
                      _isObscurePassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscurePassword = !_isObscurePassword;
                      });
                    }),
              ),
              new CheckCredentials(_onCheckConnection)
            ],
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  @override
  void dispose() {
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    var sp = await _sharedPreferences;
    var email = _emailController.text;
    var pass = _passController.text;

    sp.setString(kDolceGustoLoginKey, email);
    sp.setString(kDolceGustoPassKey, pass);

    return true;
  }
}

class CheckCredentials extends StatelessWidget {
  final VoidCallback onCheckConnection;

  CheckCredentials(this.onCheckConnection);

  @override
  Widget build(BuildContext context) {
    var connectionBloc = BlocProvider.of<ConnectionBloc>(context);
    print('CheckCredentials');
    return BlocBuilder(
        bloc: connectionBloc,
        builder: (BuildContext context, ConnState state) =>
            _build(state.asEnum, connectionBloc));
  }

  _build(EnumConnectionState state, ConnectionBloc connectionBloc) {
    String status;
    TextStyle style = TextStyle(fontSize: 14);
    switch (state) {
      case EnumConnectionState.initial:
        status = 'check connection';
        style = style.copyWith(color: Colors.white);
        break;
      case EnumConnectionState.connecting:
        status = 'connecting...';
        style = style.copyWith(color: Colors.yellow);
        break;
      case EnumConnectionState.login_succefull:
        status = 'successful connect';
        style = style.copyWith(color: Colors.green);
        break;
      case EnumConnectionState.could_not_connect:
        status = 'could not connect';
        style = style.copyWith(color: Colors.red);
        break;
    }

    return ListTile(
      trailing: Container(width: 40),
      leading: Container(width: 40),
      title: MaterialButton(
          onPressed: onCheckConnection,
          child: Text(
            status,
            style: style,
          )),
    );
  }
}
