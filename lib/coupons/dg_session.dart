import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' as html;

const baseUrl = 'https://www.nescafe-dolcegusto.com.br/m/';
const kAccountLoginGet = baseUrl + 'customer/account/login';
const accountLoginPost = baseUrl + 'customer/account/loginPost';
const accountGet = baseUrl + 'customer/account';
const myBonusGet = baseUrl + 'mybonus';
const kAccountEditGet = baseUrl + 'customer/account/edit';
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

class DioHolder {
  final Dio dio;
  final DefaultCookieJar cookieJar = DefaultCookieJar();

  DioHolder(this.dio){
   init();
  }


  void init() {
    dio.interceptors.add(new CookieManager(cookieJar));
    dio.options = BaseOptions(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        followRedirects: false,
        validateStatus: (s) => s < 500);

    dio.interceptors.add(InterceptorsWrapper(onResponse: (r) {
      print(r.data);
      return r;
    }));
  }

}


class DolceGustoSession {
  static DolceGustoSession _instance;
  final Function(dynamic data) formKeyParser;

  final DioHolder dioHolder;

  get dio => dioHolder.dio;
  get cookieJar => dioHolder.cookieJar;



  factory DolceGustoSession({DioHolder dioHolder,
      Function(dynamic data) formKeyParser}) {
    _instance ??= DolceGustoSession._internalConstructor(dioHolder?? DioHolder(Dio()),
        formKeyParser: formKeyParser);

    return _instance;
  }

  DolceGustoSession._internalConstructor(this.dioHolder,
      {this.formKeyParser});


  /*DolceGustoSession(this.dio, this._credentials,
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
  }*/

  Stream<String> login(String login, String password) {
    return _loginto(login, password);
  }

  Stream<String> _loginto(String username, String password) async* {


    yield 'tentando conectar $username $password';
    var accountLoginGetResponse;
    try {
      accountLoginGetResponse = await dio.get(kAccountLoginGet);
    } catch (e) {
      yield 'verifique conexão';
    }

    if (accountLoginGetResponse?.statusCode == 200) {
      final formKey = _parseFormKey(accountLoginGetResponse.data);
      yield 'enviando informações de login';
      await dio.post(accountLoginPost,
          data: loginFormData(username, password, formKey));
      final r = await dio.get(baseUrl);
      final errormessage = _getMessages(r.data);
      if (errormessage == '') {
        yield 'connection successfull';
      } else {
        yield errormessage;
      }
    }
  }

  Future<void> logout() async {
    await dio.get(kLogoutGet);

  }

  Future<bool> get isLogged => _isLogged();

  Future<int> get bonusPoints async {
    if (!await _isLogged()) {
      return null;
    }
    return BonusPointsParser(dioHolder.dio, myBonusGet).parsePoints;
  }

  Future<bool> _isLogged() async {
    await dio.get(myBonusGet);
    List<Cookie> cl = cookieJar.loadForRequest(Uri.parse(myBonusGet));
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
    print('the bonus: $code');
    await dio.post(submitBonusPost, data: {'coupon_code[]': code});
    var r = await dio.get(myBonusGet);
    var message = _getMessages(r.data);
    log(message);
    return Future.value(message);
  }

  Future<String> _clientName() async {
    var accountEditResponse = await dio.get(kAccountEditGet);

    if (accountEditResponse.statusCode == 200) {
      var doc = html.parse(accountEditResponse.data);

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

    debugPrint(message);
  }
}
