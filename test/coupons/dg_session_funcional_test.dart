// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

const accountLoginGet = baseUrl + 'customer/account/login';

const awaitBetweenTests = 1;

void main() {

  Dio createDio() {
    var cookieManager = CookieManager(CookieJar());
    Dio dio = Dio()
      ..options = BaseOptions(
          contentType: ContentType.parse("application/x-www-form-urlencoded"),
          followRedirects: false,
          validateStatus: (s) => s < 500)
      ..interceptors.add(cookieManager);
    return dio;
  }

    group('login', () {
      Dio dio;
      DolceGustoSession session;

      setUp(() async {
        await Future.delayed(Duration(seconds: awaitBetweenTests));
        dio = createDio();
        session = DolceGustoSession(dio);
      });

      tearDown(() {
        dio.clear();
        dio = null;
        session = null;
      });


      test('sucesso', () async {
        print('sucesso');
        var result = await session.login('alexpfba@gmail.com', '7x43b7j1*D');
        expect(result, isTrue);

        result = await session.login('alexpfba@gmail.com', '7x43b7j1*D');
        expect(result, isFalse);
      });

      test('senha incorreta', () async {
        var result = await session.login('alexpfba@gmail.com', '7x43b7j1*x');
        expect(result, isFalse);
      });
    });

    group('isLoggedIn', () {
      Dio dio;
      DolceGustoSession session;

      setUp(() async {
        await Future.delayed(Duration(seconds: awaitBetweenTests));
        dio = createDio();
        session = DolceGustoSession(dio);
      });

      test('ainda nao logado', () async {
        var result = await session.logout();
        expect(result, isTrue);
      });



    });

    group('logout', () {
      Dio dio;
      DolceGustoSession session;

      setUp(() async {
        await Future.delayed(Duration(seconds: awaitBetweenTests));
        dio = createDio();
        session = DolceGustoSession(dio);
      });

      test('ainda nao logado', () async {
        var result = await session.logout();
        expect(result, isTrue);
      });

      test('ja logado', () async {
        await session.login('alexpfba@gmail.com', '7x43b7j1*D');
        var result = await session.logout();
        expect(result, isTrue);

        var isLogged = await session.isLogged;
        expect(isLogged, isFalse);
      });
    });

    group('clientName', () {
      Dio dio;
      DolceGustoSession session;

      setUp(() async {
        await Future.delayed(Duration(seconds: awaitBetweenTests));
        dio = createDio();
        session = DolceGustoSession(dio);
      });

      test('success', () async {
        await session.login('alexpfba@gmail.com', '7x43b7j1*D');

        var clientName= await session.clientName;
        expect(clientName, "Alexandre Alessi");
      });

      test('not logged', () async {
        await session.logout();
        var clientName= await session.clientName;
        expect(clientName, isNull);
      });
    });


    group('bonusPoints', () {
      Dio dio;
      DolceGustoSession session;

      setUp(() async {
        await Future.delayed(Duration(seconds: awaitBetweenTests));
        dio = createDio();
        session = DolceGustoSession(dio);
      });

      test('success', () async {
        var x = await session.login('alexpfba@gmail.com', '7x43b7j1*D');
        print("logou: $x");

        var clientName= await session.bonusPoints;
        expect(clientName, 50);
      });

      test('not logged', () async {
        await session.logout();
        var clientName= await session.bonusPoints;
        expect(clientName, isNull);
      });
    });

}
