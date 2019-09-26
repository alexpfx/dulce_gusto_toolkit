import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus.dart';
import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/coupon_card.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonusList extends StatelessWidget {
  List<Coupon> coupons = [];
  List<Coupon> deleted = [];
  final UserCredentials credentials;
  SynchronizeBonusBloc syncBloc;

  BonusList(this.credentials);

  @override
  Widget build(BuildContext context) {
    syncBloc = BlocProvider.of<SynchronizeBonusBloc>(context);
    syncBloc.dispatch(GetAllBonus());

    return BlocBuilder<SynchronizeBonusBloc, SynchronizeBonusState>(
        bloc: BlocProvider.of<SynchronizeBonusBloc>(context),
        builder: (bloc, state) {
          if (state is AllBonusState) {
            coupons = state.bonusList;
          }

          return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: coupons.length,
            itemBuilder: _itemBuilder,
          );
        });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var coupon = coupons[index];
    return Dismissible(

      direction: DismissDirection.horizontal,
      onDismissed: (_) => _onDismiss(coupon),
      dragStartBehavior: DragStartBehavior.down,
      confirmDismiss: _confirmDismiss,
      background: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Colors.redAccent,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(Icons.delete),
            ),
          ),
        ),
      ),
      dismissThresholds: {
        DismissDirection.startToEnd: 0.9
      },
      child: Visibility(
        visible: !(coupon.markedForDelection),
        child: CouponCard(
          coupon: coupon,
          credentials: credentials,
          height: 64,
          onCouponClick: (x) {},
        ),
      ),
      key: Key(coupon.id.toString()),
    );
  }

  Future<bool> _confirmDismiss(DismissDirection direction) {
    if (direction == DismissDirection.endToStart){
      return Future.value(false);
    }

    return Future.value(true);
  }

  _onDismiss(Coupon coupon) {
    int index = coupons.indexOf(coupon);
    var newBonus = coupon.copyWith(markedForDelection: true);
    deleted.add(newBonus);
    coupons.removeAt(index);
    syncBloc.dispatch(UpdateEvent(newBonus));
  }
}
