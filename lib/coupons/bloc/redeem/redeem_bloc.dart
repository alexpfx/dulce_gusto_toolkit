import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/redeem_status.dart';
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
  Stream<RedeemState> mapEventToState(RedeemEvent event) async* {
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
    }
  }

  Future<CompletedState> getResultMessage(
      DolceGustoSession session, Coupon coupon) async {
    if (_logged) {
      var message = await session.storeBonus(coupon.code);
      if (message != null) {
        var newBonus = updateCoupon(message, coupon);
        return CompletedState(newBonus);
      } else {
        return CompletedState(coupon.copyWith(
            redeemAttempt: RedeemAttempt(
                date: DateTime.now(),
                message: "Não pode adicionar bonus",
                status: RedeemResultStatus.info_fail)));
      }
    } else {
      return CompletedState(coupon.copyWith(
          redeemAttempt: RedeemAttempt(
              date: DateTime.now(),
              message: "Não pode adicionar bonus",
              status: RedeemResultStatus.info_fail)));
    }
  }

  Coupon updateCoupon(String message, Coupon bonus) {
    String upMessage = message.toUpperCase();
    RedeemResultStatus status;
    if (upMessage.contains('BONUS FORAM CREDITADOS')) {
      status = RedeemResultStatus.info_ok;
    } else {
      status = RedeemResultStatus.info_fail;
    }

    return bonus.copyWith(
        redeemAttempt: RedeemAttempt(
            status: status, message: upMessage, date: DateTime.now()));
  }
}
