import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/redeem_status.dart';
import 'package:flutter/material.dart';

class CouponCardLeading extends StatelessWidget {
  final RedeemResultStatus status;

  final VoidCallback onTap;

  const CouponCardLeading({
    Key key,
    this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print('the statue in leading is $status ');

    return InkWell(
      onTap: status == null || status == RedeemResultStatus.newBonus
          ? null
          : onTap,
      child: Container(width: 40, height: 40, child: _decorationByStatus()));
  }


  _decorationByStatus() {
    switch (status) {
      case RedeemResultStatus.newBonus:
        return SizedBox.shrink();
      case RedeemResultStatus.redeemingInProgress:
        return CircularProgressIndicator();
      case RedeemResultStatus.info_ok:
      case RedeemResultStatus.info_fail:
        Color color = colorByStatus(status);
        return ClipOval(
            clipBehavior: Clip.antiAlias,
            clipper: CircleClip(),
            child: Container(
              color: color,
            ));
    }
  }
}

class CircleClip extends CustomClipper<Rect> {
  @override
  getClip(Size size) {
    print(size);
    Rect rect = Rect.fromCircle(
        center: new Offset(size.height / 2, size.width / 2), radius: 8);
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

Color colorByStatus(status) {
  return (RedeemResultStatus.newBonus == RedeemResultStatus.info_ok)
      ? Colors.greenAccent.withAlpha(150)
      : Colors.redAccent.withAlpha(150);
}
