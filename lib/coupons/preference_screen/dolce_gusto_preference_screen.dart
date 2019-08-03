import 'package:dulce_gusto_toolkit/constants.dart';
import 'package:flutter/material.dart';
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

  @override
  initState() {
    loadPreferences();

    super.initState();
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
                  onChanged: _onPassChanged,
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

  void _onPassChanged(String value) {}

  Future<bool> _onWillPop() async {
    var sp = await _sharedPreferences;
    var email = _emailController.text;
    var pass = _passController.text;

    sp.setString(kDolceGustoLoginKey, email);
    sp.setString(kDolceGustoPassKey, pass);

    return true;
  }
}
