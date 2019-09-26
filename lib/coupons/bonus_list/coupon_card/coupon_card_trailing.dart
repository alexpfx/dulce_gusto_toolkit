import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CouponCardTrailing extends StatelessWidget {
  final VoidCallback onPressCallback;
  final SynchronizeBonusState state;

  CouponCardTrailing({this.onPressCallback, this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 56,
        height: 56,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (state is! BonusWasUpdated)
              ? SpinKitFadingFour(
            color: Colors.white,
            size: 28,
          )
              : IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: onPressCallback,
                ),
        ));
  }
}
