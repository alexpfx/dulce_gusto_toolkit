import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RedeemState extends Equatable {
  RedeemState([List props = const []]) : super(props);
}

class InitialRedeemState extends RedeemState {}

class LoadingState extends RedeemState {}

class CompletedState extends RedeemState {
  final Coupon bonus;

  CompletedState(this.bonus) : super([bonus]);
}


