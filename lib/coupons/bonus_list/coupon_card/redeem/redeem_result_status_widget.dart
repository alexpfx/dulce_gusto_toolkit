import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/redeem_status.dart';
import 'package:dulce_gusto_toolkit/model/redeem_result.dart';
import 'package:flutter/material.dart';

const kNewIcon = Icons.card_giftcard;
const kInfoIcon = Icons.info;
const kColorNewIcon = Colors.yellow;
const kColorSuccess = Colors.green;
const kColorFail = Colors.red;
const kIconSize = 16.0;

class RedeemResultStatusWidget extends StatelessWidget {
  RedeemResultStatusWidget({
    Key key,
    @required this.result,
  }) : super(key: key);

  final RedeemEvent result;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Center(
      child: Container(
        padding: EdgeInsets.all(4),
        child: _buildChildByStatus(result.status),
      ),
    );
  }

  _buildChildByStatus(RedeemResultStatus status) {
    switch (status) {
      case RedeemResultStatus.newBonus:
        return IconButton(
          icon: Icon(
            kNewIcon,
            color: kColorNewIcon,
          ),
          onPressed: _onPress,
          iconSize: kIconSize,
        );
      case RedeemResultStatus.redeemingInProgress:
        return CircularProgressIndicator();
      case RedeemResultStatus.info_ok:
        return IconButton(
          icon: Icon(kInfoIcon),
          color: kColorSuccess,
          onPressed: _onPress,
          iconSize: kIconSize,
        );
      case RedeemResultStatus.info_fail:
        return IconButton(
          icon: Icon(kInfoIcon),
          color: kColorFail,
          onPressed: _onPress,
          iconSize: kIconSize,
        );
    }
  }

  void _onPress() {
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            title: Text("${result.code}"),
            content: Text(result.message),
            actions: <Widget>[
              new FlatButton(
                  onPressed: Navigator.of(context).pop, child: Text("Close"))
            ],
          );
        });
  }
}
