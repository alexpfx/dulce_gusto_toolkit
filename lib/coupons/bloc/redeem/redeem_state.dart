import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RedeemState extends Equatable {
  RedeemState([List props = const []]) : super(props);
}

enum EnumRedeemState { initial, connecting, fail, succefull }

class InitialRedeemState extends RedeemState {}

class ConnectingState extends RedeemState {}

class FailState extends RedeemState {
  final Coupon coupon;
  final String message;

  FailState(this.coupon, this.message);
}

class SuccessfulState extends RedeemState {
  final Coupon coupon;
  final String message;

  SuccessfulState(this.coupon, this.message);
}
