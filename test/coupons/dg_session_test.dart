import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

const kAccountLoginGet = kBaseUrl + 'customer/account/login';
const kBaseUrl = 'https://www.nescafe-dolcegusto.com.br/m/';
const kAccountLoginPost = kBaseUrl + 'customer/account/loginPost';
const kAccountGet = kBaseUrl + 'customer/account';
const myBonusGet = kBaseUrl + 'mybonus';
const accountEditGet = kBaseUrl + 'customer/account/edit';
const submitBonusPost = kBaseUrl + 'pcm/customer_account_bonus/couponPost/';
const kLogoutGet = kBaseUrl + 'customer/account/logout/';
const kLogoutSuccess = kBaseUrl + 'customer/account/logoutSuccess/';

Response createResponse(int status, String message) {
  return Response(statusCode: status, statusMessage: message);
}

void main() {

  group('isLoggedIn', () {
    MockDio dioMock = MockDio();
    DolceGustoSession session = DolceGustoSession(dioMock);

    test('is logged in', () async {
      when(dioMock.get(myBonusGet))
          .thenAnswer((_) async => createResponse(200, 'OK'));
      bool result = await session.isLogged;
      expect(result, isTrue);
    });

    test('is not logged in', () async {
      when(dioMock.get(myBonusGet))
          .thenAnswer((_) async => createResponse(302, 'Found'));
      bool result = await session.isLogged;
      expect(result, isFalse);
    });

  });


  group('login', () {
    MockDio dioMock = MockDio();
    DolceGustoSession session = DolceGustoSession(dioMock, formKeyParser: (data) => 'whatever');

    test('fail first get', () async {
      when(dioMock.get(kAccountLoginGet))
          .thenAnswer((_) async => createResponse(302, 'Found'));
      expect(session.login('username', 'password'), throwsA(equals('login failed')));
    });

    test('fail first post', () async {
      when(dioMock.get(kAccountLoginGet))
          .thenAnswer((_) async => createResponse(200, 'Ok'));

      when(dioMock.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => createResponse(400, 'Found'));

      expect(session.login('username', 'password'), throwsA(equals('login failed')));
    });

    test('fail second get', () async {
      when(dioMock.get(kAccountLoginGet))
          .thenAnswer((_) async => createResponse(200, 'Ok'));

      when(dioMock.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => createResponse(302, 'Found'));

      when(dioMock.get(kBaseUrl))
          .thenAnswer((_) async => createResponse(404, 'Not Found'));

      expect(session.login('username', 'password'), throwsA(equals('login failed')));
    });

    test('login ok', () async {
      when(dioMock.get(kAccountLoginGet))
          .thenAnswer((_) async => createResponse(200, 'Ok'));

      when(dioMock.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => createResponse(302, 'Found'));

      when(dioMock.get(kBaseUrl))
          .thenAnswer((_) async => createResponse(200, 'Ok'));

      expect(await session.login('username', 'password'), true);
    });



  });

  group('login', ()
  {
    MockDio dioMock = MockDio();
    DolceGustoSession session = DolceGustoSession(
        dioMock, formKeyParser: (data) => 'whatever');

    test('error', () async {


    });

  });





}