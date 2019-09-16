import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RedeemEvent extends Equatable {
  RedeemEvent([List props = const []]) : super(props);
}

class RedeemCodeEvent extends RedeemEvent{
  final Coupon coupon;
  final String user;
  final String pass;


  RedeemCodeEvent({this.user, this.pass, this.coupon}): super([user, pass, coupon]);
}
