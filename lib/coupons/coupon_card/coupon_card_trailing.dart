import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:flutter/material.dart';

class CouponCardTrailing extends StatelessWidget {
  final VoidCallback onPressCallback;
  final RedeemState state;

  CouponCardTrailing({this.onPressCallback, this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 56,
        height: 56,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (state is LoadingState)
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: onPressCallback,
                ),
        ));
  }
}
