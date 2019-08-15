import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_code_card.dart';
import 'package:flutter/material.dart';

class CouponTile extends StatelessWidget {
  final String code;
  final IconData icon;
  final Color iconColor;


  CouponTile(this.code, this.icon, this.iconColor);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CouponCodeCard(code, RedeemResultStatus.info_ok),
      trailing: Padding(
        padding: EdgeInsets.only(right: 6),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
