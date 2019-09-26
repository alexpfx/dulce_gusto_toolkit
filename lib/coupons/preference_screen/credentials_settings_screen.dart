import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsSettingsScreen extends StatefulWidget {

  final VoidCallback callback;


  CredentialsSettingsScreen({this.callback});

  @override
  _CredentialsSettingsScreenState createState() =>
      _CredentialsSettingsScreenState();
}

class _CredentialsSettingsScreenState
    extends State<CredentialsSettingsScreen> {
  Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool _isObscurePassword = true;
  String _user;
  String _pass;

  _onCheckConnectionClick() {
    var connectionBloc = BlocProvider.of<ConnectionBloc>(context);
    connectionBloc.dispatch(
        LoginDgEvent(_user, _pass)
    );
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
    print('load preferences');
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
              new CheckCredentials(_onCheckConnectionClick)
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


    widget.callback?.call();

//    if (widget.callback != null) widget.callback();
    return true;
  }
}

// todo este nome está ruim
class CheckCredentials extends StatelessWidget {
  final VoidCallback onCheckConnection;

  CheckCredentials(this.onCheckConnection);

  @override
  Widget build(BuildContext context) {
    var connectionBloc = BlocProvider.of<ConnectionBloc>(context);
    print('CheckCredentials');
    return BlocBuilder(
      bloc: connectionBloc,
      builder: (BuildContext context, state) => _build(context, state),
    );
  }

  _build(BuildContext context, ConnState state) {
    String status;
    TextStyle style = TextStyle(fontSize: 14);

    if (state is InitialState) {
      status = 'check connection';
      style = style.copyWith(color: Colors.white);
    }
    if (state is MessageSend) {
      print('message: ${state.message}');
      status = state.message;
      style = style.copyWith(color: Colors.yellow);
    }

    if (state is ConnectionSuccessState) {
      status = 'successful connect';
      style = style.copyWith(color: Colors.green);
    }
    if (state is CouldNotConnect) {
      status = 'could not connect';
      style = style.copyWith(color: Colors.red);
    }

    print('status: $status');
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
