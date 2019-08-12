import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_points.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:html/parser.dart' as html;

const baseUrl = 'https://www.nescafe-dolcegusto.com.br/m/';
const accountLoginGet = baseUrl + 'customer/account/login';
const accountLoginPost = baseUrl + 'customer/account/loginPost';
const accountGet = baseUrl + 'customer/account';
const myBonusGet = baseUrl + 'mybonus';
const accountEditGet = baseUrl + 'customer/account/edit';
const submitBonusPost = baseUrl + 'pcm/customer_account_bonus/couponPost/';
const kLogoutGet = baseUrl + 'customer/account/logout/';
const kLogoutSuccessGet = baseUrl + 'customer/account/logoutSuccess/';

loginFormData(user, pass, formKey) => {
      'login[username]': user,
      'login[password]': pass,
      'form_key': formKey,
      'recaptcha-form': 'login',
      'send': ''
    };

_getMessages(data) {
  var parsed = html.parse(data);
  return parsed?.querySelector('ul.messages')?.text ?? "";
}

String _parseFormKey(data) {
  var formKey = html
      .parse(data)
      .querySelector('input[name="form_key"]')
      .attributes['value'];
  return formKey;
}

class DolceGustoSession {
  final Dio dio;
  final Function(dynamic data) formKeyParser;
  final _cookieJar = DefaultCookieJar();
  final UserCredentials _credentials;

  DolceGustoSession(this.dio, this._credentials,
      {this.formKeyParser = _parseFormKey}) {
    assert(dio != null, "dio is null");

    dio.options = BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        followRedirects: false,
        validateStatus: (s) => s < 500);

    dio.interceptors.add(CookieManager(_cookieJar));
    dio.interceptors.add(InterceptorsWrapper(onResponse: (r) {
      log(r.statusCode);
      return r;
    }));
  }

  Future<void> login() async {
    await _login(_credentials.login, _credentials.password);
  }

  Future<void> _login(String username, String password) async {
    _cookieJar.deleteAll();
    log('tentando logar: $username $password');

    final getResponse = await dio.get((accountLoginGet));

    if (getResponse.statusCode == 200) {
      final formKey = _parseFormKey(getResponse.data);
      await dio.post(accountLoginPost,
          data: loginFormData(username, password, formKey));
    }
  }

  Future<void> logout() async {
    await dio.get(kLogoutGet);
    _cookieJar.deleteAll();
  }

  Future<bool> get isLogged => _isLogged();

  Future<int> get bonusPoints async {
    if (!await _isLogged()) {
      return null;
    }
    return BonusPointsParser(dio, myBonusGet).parsePoints;
  }

  Future<bool> _isLogged() async {
    await dio.get(myBonusGet);
    List<Cookie> cl = _cookieJar.loadForRequest(Uri.parse(myBonusGet));
    print('cl: $cl');

    for (var value in cl) {
      if (value.name == 'CUSTOMER_AUTH') {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  Future<String> get clientName => _clientName();

  Future<String> storeBonus(String code) async {
    await dio.post(submitBonusPost, data: {'coupon_code[]': code}).then(
        (Response response) async {
      var r = await dio.get(myBonusGet);
      var message = _getMessages(r.data);
      return Future.value(message);
    });

    return Future.value(null);
  }

  bool _isOk(Response response) {
    return response.statusCode == 200;
  }

  Future<String> _clientName() async {
    if (!await isLogged) {
      return Future.error("client is not logged in");
    }
    var response = await dio.get(accountEditGet);
    if (_isOk(response)) {
      var doc = html.parse(response.data);
      var firstNameElement = doc.querySelector("div.field.name-firstname");
      var firstname = firstNameElement.querySelector("input[name=firstname]");
      var lastNameElement = doc.querySelector("div.field.name-lastname");
      var lastName = lastNameElement.querySelector("input[name=lastname]");
      return firstname.attributes['value'].trim() +
          ' ' +
          lastName.attributes['value'].trim();
    } else {
      return null;
    }
  }

  void log(Object message) {
    print(message);
  }
}
