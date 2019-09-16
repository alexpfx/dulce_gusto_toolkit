import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Obtém do banco a atualização de um bonus depois da tentativa de cadastro no site.
@immutable
abstract class SynchronizeBonusEvent extends Equatable {
  SynchronizeBonusEvent([List props = const <dynamic>[]]) : super(props);
}


class SynchronizeOneBonus extends SynchronizeBonusEvent{
  final Coupon coupon;

  SynchronizeOneBonus({this.coupon}): super([coupon]);


}



