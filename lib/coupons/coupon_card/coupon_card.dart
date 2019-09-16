import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_card_leading.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_card_title.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/coupon_card_trailing.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon_card/redeem_status.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

math.Random random = math.Random();

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final UserCredentials credentials;
  final Function(String coupon) onCouponClick;
  var _mark = false;

  get mark => _mark;
  final double height;

  CouponCard({this.credentials, this.coupon, this.onCouponClick, this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var bloc = BlocProvider.of<RedeemBloc>(context);

    return Container(
        width: double.infinity,
        height: height,
        child: Card(
          elevation: 2,
          margin: EdgeInsets.all(1),
          child: BlocBuilder<RedeemBloc, RedeemState>(
              bloc: bloc,
              condition: (RedeemState oldState, RedeemState state) {
                return !(state is InitialRedeemState);
              },
              builder: (BuildContext context, RedeemState state) =>
                  buildByState(context, state)),
        ));
  }

  void _onDownloadPress(BuildContext context) {
    var redeeBloc = BlocProvider.of<RedeemBloc>(context);

    redeeBloc.dispatch(RedeemCodeEvent(
      user: credentials.login,
      pass: credentials.password,
      coupon: coupon,
    ));
  }

  bool get hasCredentials => ((credentials?.login?.isNotEmpty ?? false) &&
      (credentials?.password?.isNotEmpty ?? false));

  buildByState(BuildContext context, RedeemState state) {
    RedeemResultStatus status;
    debugPrint("buildByState: $state");


    return ListTile(
      leading: CouponCardLeading(
        onTap: () {
          _onStatusButtonTap(context, coupon);
        },
        status: status,
      ),
      title: CouponCardTitle(coupon: coupon),
      trailing: CouponCardTrailing(
        onPressCallback:
            (isOnPressEnabled(status)) ? () => _onDownloadPress(context) : null, state: state,
      ),
    );
  }

  bool isOnPressEnabled(RedeemResultStatus status) =>
      hasCredentials && status != RedeemResultStatus.info_ok;

  void _onStatusButtonTap(context, Coupon coupon) {
    final scaffold = Scaffold.of(context, nullOk: true);

    scaffold.showSnackBar(
        new SnackBar(content: Text(coupon.redeemAttempt.message)));
  }
}
