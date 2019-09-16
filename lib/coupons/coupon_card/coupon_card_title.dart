import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kColorActive = Colors.white;
const kColorInactive = Colors.white60;

class CouponCardTitle extends StatelessWidget {
  final Coupon coupon;

  const CouponCardTitle({
    Key key,
    this.coupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          formatCode(coupon.code),
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

}

class ShowAttempt extends StatelessWidget {
  RedeemAttempt redeemAttempt;

  ShowAttempt(this.redeemAttempt); //  coupon.redeemAttempt != null

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        redeemAttempt.message,
        style:
            Theme.of(context).textTheme.caption.copyWith(color: kColorInactive),
      ),
    );
  }
}
