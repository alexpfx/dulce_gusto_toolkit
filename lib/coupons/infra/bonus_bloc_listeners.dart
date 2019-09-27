import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus_bloc.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonusBlocListeners extends StatelessWidget {
  final Widget child;

  BonusBlocListeners({@required this.child});

  @override
  Widget build(BuildContext context) {
    var syncBloc = BlocProvider.of<SynchronizeBonusBloc>(context);
    var redeemBloc = BlocProvider.of<RedeemBloc>(context);
    return MultiBlocListener(
      listeners: <BlocListener>[
        BlocListener<SynchronizeBonusBloc, SynchronizeBonusState>(
          bloc: syncBloc,
          listener: (context, state) {
            if (state is BonusWasStored) {
              syncBloc.dispatch(GetAllBonus());
            }

            if (state is BonusWasUpdated) {
              syncBloc.dispatch(GetBonus(state.bonus));
            }
          },
        ),
        BlocListener<RedeemBloc, RedeemState>(
          bloc: redeemBloc,
          listener: (context, state) {
            if (state is CompletedState) {
              var code = state.bonus;
              syncBloc.dispatch(UpdateEvent(code));
            }
          },
        )
      ],
      child: child,
    );
  }
}

/*
BlocListener<SynchronizeBonusBloc, SynchronizeBonusState>(
bloc: syncBloc,
listener: (context, SynchronizeBonusState state) {
if (state is BonusWasStored) {
print('bonus_list: $state');
syncBloc.dispatch(GetAllBonus());
}
},*/
