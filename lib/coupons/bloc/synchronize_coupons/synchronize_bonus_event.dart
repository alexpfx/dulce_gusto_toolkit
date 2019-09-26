import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// Obtém do banco a atualização de um bonus depois da tentativa de cadastro no site.
@immutable
abstract class SynchronizeBonusEvent extends Equatable {
  SynchronizeBonusEvent([List props = const <dynamic>[]]) : super(props);
}


class GetBonus extends SynchronizeBonusEvent{
  final Coupon coupon;

  GetBonus(this.coupon): super([coupon]);

}


class GetAllBonus extends SynchronizeBonusEvent{


  GetAllBonus();

}


class StoreBonus extends SynchronizeBonusEvent{
  final Coupon bonus;

  StoreBonus(this.bonus): super([bonus]);

}


class UpdateEvent extends SynchronizeBonusEvent{
  final Coupon bonus;

  UpdateEvent(this.bonus): super([bonus]);


}



