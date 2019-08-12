import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RedeemState extends Equatable {
  RedeemState([List props = const []]) : super(props);

  EnumRedeemState get asEnum;

}

enum EnumRedeemState {
  initial,
  connecting,
  fail,
  succefull
}

class InitialRedeemState extends RedeemState {
  @override
  // TODO: implement asEnum
  EnumRedeemState get asEnum => EnumRedeemState.initial;
}

class ConnectingState extends RedeemState{
  @override
  // TODO: implement asEnum
  EnumRedeemState get asEnum => EnumRedeemState.connecting;

}

class FailState extends RedeemState{
  final Coupon coupon;
  final String message;


  FailState(this.coupon, this.message);

  @override
  EnumRedeemState get asEnum => EnumRedeemState.fail;

}

class SuccessfulState extends RedeemState{
  final Coupon coupon;
  final String message;

  @override
  EnumRedeemState get asEnum => EnumRedeemState.succefull;

  SuccessfulState(this.coupon, this.message);
}


