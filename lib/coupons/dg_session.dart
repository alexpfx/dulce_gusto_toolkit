import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_points.dart';
import 'package:html/parser.dart' as html;

const baseUrl = 'https://www.nescafe-dolcegusto.com.br/m/';
const accountLoginGet = baseUrl + 'customer/account/login';
const accountLoginPost = baseUrl + 'customer/account/loginPost';
const accountGet = baseUrl + 'customer/account';
const myBonusGet = baseUrl + 'mybonus';
const accountEditGet = baseUrl + 'customer/account/edit';
const submitBonusPost = baseUrl + 'pcm/customer_account_bonus/couponPost/';
const kLogoutGet = baseUrl + 'customer/account/logout/';
const kLogoutSuccess = baseUrl + 'customer/account/logoutSuccess/';

loginFormData(user, pass, formKey) => {
      'login[username]': user,
      'login[password]': pass,
      'form_key': formKey,
      'recaptcha-form': 'login',
      'send': ''
    };

String _parseFormKey(data) {
  var formKey = html
      .parse(data)
      .querySelector('input[name="form_key"]')
      .attributes['value'];
  return formKey;
}

class DolceGustoSession implements DgSession {
  void log(Object message) {
    print(message);
  }

  final Dio dio;
  final Function(dynamic data) formKeyParser;

  DolceGustoSession(this.dio, {this.formKeyParser = _parseFormKey}) {
    assert(dio != null, "dio is null");
  }

  Future<bool> login(String username, String password) async {
    print('login: $username');
    final getResponse = await dio.get(accountLoginGet);
    print('getResponse');

    if (getResponse.statusCode == 200) {
      final formKey = formKeyParser(getResponse.data);

      final postResponse = await dio.post(accountLoginPost,
          data: loginFormData(username, password, formKey));
      log('posting form data');

      if (postResponse.statusCode == 302) {
        return isLogged;
      }
    }
    print('login failed');
    return Future.error('login failed');
  }

  @override
  Future<bool> logout() async {
    if (await isLogged) {
      var v = await dio.get(kLogoutGet);
      if (v.statusCode == 302) {
        return _isOk(await dio.get(kLogoutSuccess));
      }
      return false;
    }
    return true;
  }

  @override
  Future<String> get clientName => _clientName();

  @override
  Future<int> get bonusPoints async {
    if (!await _isLogged()) {
      return null;
    }
    return BonusPointsParser(dio, myBonusGet).parsePoints;
  }

  @override
  Future<bool> get isLogged => _isLogged();

  @override
  Future<bool> storeBonus(String code) async {
    await dio.post(submitBonusPost, data: {'coupon_code[]': code}).then(
        (response) async {
      if (_isOk(response)) {
        var r = await dio.get(myBonusGet);
        return _isOk(r);
      } else {
        return false;
      }
    });
    return false;
  }

  @override
  String get username => username;

  bool _isOk(Response response) {
    return response.statusCode == 200;
  }

  Future<bool> _isLogged() async {
    try {
      return _isOk(await dio.get(myBonusGet));
    } catch (e) {
      return Future.error(e);
    }
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
}

abstract class DgSession {
  Future<bool> login(String username, String pass);

  String get username;

  Future<String> get clientName;

  Future<bool> get isLogged;

  Future<int> get bonusPoints;

  Future<void> storeBonus(String code);

  Future<bool> logout();
}
