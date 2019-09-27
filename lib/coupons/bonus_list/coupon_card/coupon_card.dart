import 'dart:math' as math;

import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/coupon_card_leading.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/coupon_card_title.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/coupon_card_trailing.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/redeem_status.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/preference_screen/credentials_settings_screen.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:flutter/foundation.dart';
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
          child: BlocBuilder<SynchronizeBonusBloc, SynchronizeBonusState>(
              bloc: BlocProvider.of<SynchronizeBonusBloc>(context),
              condition: (prevState, actualState) {
                return actualState is BonusWasUpdated;
              },
              builder: (context, state) {
                return buildByState(context, state);
              }),
        ));
  }

  void _onDownloadPress(BuildContext context) {
    if (!hasCredentials) {
      Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              settings: RouteSettings(),
              builder: (context) => CredentialsSettingsScreen()));
      return;
    }

    var redeeBloc = BlocProvider.of<RedeemBloc>(context);

    redeeBloc.dispatch(RedeemCodeEvent(
      user: credentials.login,
      pass: credentials.password,
      coupon: coupon,
    ));
  }

  bool get hasCredentials => ((credentials?.login?.isNotEmpty ?? false) &&
      (credentials?.password?.isNotEmpty ?? false));

  buildByState(BuildContext context, SynchronizeBonusState state) {
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
        onPressCallback: () => _onDownloadPress(context),
        state: state,
      ),
    );
  }

  void _onStatusButtonTap(context, Coupon coupon) {
    final scaffold = Scaffold.of(context, nullOk: true);

    scaffold.showSnackBar(
        new SnackBar(content: Text(coupon.redeemAttempt.message)));
  }
}
