import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponCodeCard extends StatelessWidget {
  final String coupon;

  CouponCodeCard(this.coupon);

  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    child: Text(
                      coupon,
                      style: Theme.of(context).textTheme.title.copyWith(
                          letterSpacing: 1,
                          wordSpacing: 2,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: coupon));
                      if (scaffold != null) {
                        scaffold.showSnackBar(SnackBar(
                            content: Text("${coupon} into clipboard!")));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: SizedBox()),
        ]);
  }
}
