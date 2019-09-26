import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SynchronizeBonusState extends Equatable {
  SynchronizeBonusState([List props = const <dynamic>[]]) : super(props);
}

class InitialSynchronizeBonusState extends SynchronizeBonusState {}


class GetBonusState extends SynchronizeBonusState{

  final Coupon coupon;
  GetBonusState(this.coupon): super([coupon]);


}

class BonusWasStored extends SynchronizeBonusState{
  final Coupon coupon;

  BonusWasStored(this.coupon): super([coupon]);

}

class BonusWasUpdated extends SynchronizeBonusState{
  final Coupon bonus;

  BonusWasUpdated(this.bonus) : super([bonus]);


}


class AllBonusState extends SynchronizeBonusState{
  final List<Coupon> bonusList;

  AllBonusState(this.bonusList): super([bonusList]);


}