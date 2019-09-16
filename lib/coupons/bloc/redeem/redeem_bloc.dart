import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/model/data/database_helper.dart';
import 'package:flutter/foundation.dart';

import './redeem.dart';

class RedeemBloc extends Bloc<RedeemEvent, RedeemState> {
  final DbHelper dbHelper;

  RedeemBloc(this.dbHelper);

  @override
  RedeemState get initialState => InitialRedeemState();

  bool _logged = false;

  @override
  Stream<RedeemState> mapEventToState(
    RedeemEvent event,
  ) async* {
    if (event is RedeemCodeEvent) {
      yield LoadingState();

      var coupon = event.coupon;
      var session = DolceGustoSession();

      _logged = await session.isLogged;

      debugPrint('mapping event... code: ${coupon.code}');

      if (!_logged) {
        await for (final message in session.login(event.user, event.pass)) {
          debugPrint("message from login: $message");
        }
        _logged = await session.isLogged;
      }

      var message = await getResultMessage(session, coupon);
      yield message;

      update(coupon, message);

    }

  }

  Future<ResultMessageState> getResultMessage(DolceGustoSession session, Coupon coupon) async {
    if (_logged) {
      var message = await session.storeBonus(coupon.code);
      if (message != null) {
        return getStateByMessage(message, coupon.code);
      } else {
        return ResultMessageState("Não pôde adicionar cupom.", coupon.code,
            hasError: true);
      }
    } else {
      return ResultMessageState("Não pôde adicionar cupom.", coupon.code,
          hasError: true);
    }
  }

  update(Coupon coupon, ResultMessageState message) async {
    await dbHelper.updateBonus(coupon.copyWith());
  }

  RedeemState getStateByMessage(String message, String code) {
    String upMessage = message.toUpperCase();
    if (upMessage.contains('BONUS FORAM CREDITADOS')) {
      return ResultMessageState(message, code);
    } else {
      return ResultMessageState(message, code, hasError: true);
    }
  }
}
