import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SynchronizeBonusState extends Equatable {
  SynchronizeBonusState([List props = const <dynamic>[]]) : super(props);
}

class InitialSynchronizeBonusState extends SynchronizeBonusState {}


class BonusWasUpdatedState extends SynchronizeBonusState{

  final Coupon coupon;

  BonusWasUpdatedState(this.coupon): super([coupon]);


}
