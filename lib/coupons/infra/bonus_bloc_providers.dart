import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/redeem/redeem.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/user_info/get_user_info.dart';
import 'package:dulce_gusto_toolkit/model/data/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonusBlocProviders extends StatelessWidget {
  final Widget child;
  BonusBlocProviders({@required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectionBloc>(
          builder: (context) => ConnectionBloc(),
        ),
        BlocProvider<RedeemBloc>(
          builder: (context) => RedeemBloc(dbHelper),
        ),
        BlocProvider<GetUserInfoBloc>(
          builder: (context) => GetUserInfoBloc(),
        ),
        BlocProvider<SynchronizeBonusBloc>(
          builder: (context) => SynchronizeBonusBloc(),
        )
      ], child: child,
    );
  }
}
