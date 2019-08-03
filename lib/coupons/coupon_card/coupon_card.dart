import 'dart:math' as math;

import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_tile.dart';
import 'package:flutter/material.dart';

math.Random random = math.Random();

class CouponCard extends StatefulWidget {
  final Coupon coupon;
  final Function(String coupon) onCouponClick;
  var _mark = false;

  get mark => _mark;
  final double height;

  CouponCard({this.coupon, this.onCouponClick, this.height: 72});

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context, nullOk: true);

    return Card(
        elevation: 0,
        margin: EdgeInsets.all(1),
        child: conditions(widget.coupon)[widget.coupon.status]);
  }

  Widget invalid() {}
}

conditions(Coupon coupon) => {
      Status.added_new: CouponTile(
          coupon.code, Icons.fiber_new, Colors.yellowAccent.shade100),
      Status.redeemed: CouponTile(coupon.code, Icons.check, Colors.green)
    };

class StatusIcon extends StatelessWidget {
  final Status status;

  StatusIcon(this.status);

  @override
  Widget build(BuildContext context) {
    var icon = _getIcon();
    return Icon(
      icon,
      size: 32,
    );
  }

  IconData _getIcon() {
    switch (status) {
      case Status.redeemed:
        return Icons.check;
      case Status.added_new:
        return Icons.fiber_new;
      case Status.error:
        return Icons.message;
    }
  }
}
