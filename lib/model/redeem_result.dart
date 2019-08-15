import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_code_card.dart';

class RedeemEvent{
  final RedeemResultStatus status;
  final String message;
  final code;
  final DateTime dateAdded;

  RedeemEvent({this.status, this.message, this.code, this.dateAdded});


}
