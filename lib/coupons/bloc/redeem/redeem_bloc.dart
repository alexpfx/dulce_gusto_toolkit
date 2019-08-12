import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import './redeem.dart';

class RedeemBloc extends Bloc<RedeemEvent, RedeemState> {
  RedeemBloc();

  @override
  RedeemState get initialState => InitialRedeemState();

  @override
  Stream<RedeemState> mapEventToState(
    RedeemEvent event,
  ) async* {
    if (event is RedeemCodeEvent){
      yield ConnectingState();

      var coupon = event.coupon;
      var session = event.session;
      if (!await session.isLogged){
          yield FailState(event.coupon, 'Not connected');
          print('not connected');
      }
      var message = await session.storeBonus(coupon.code);
      if (message != null){
        yield SuccessfulState(event.coupon, message);
        return;
      }
      yield FailState(event.coupon, "Could not add coupon");
    }
  }
}
