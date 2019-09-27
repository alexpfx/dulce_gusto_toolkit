import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/synchronize_coupons/synchronize_bonus.dart';
import 'package:dulce_gusto_toolkit/model/data/database_helper.dart';

class SynchronizeBonusBloc
    extends Bloc<SynchronizeBonusEvent, SynchronizeBonusState> {
  @override
  SynchronizeBonusState get initialState => InitialSynchronizeBonusState();

  @override
  Stream<SynchronizeBonusState> mapEventToState(
    SynchronizeBonusEvent event,
  ) async* {
    if (event is GetBonus) {
      var bonus = await dbHelper.theBonus(event.coupon.id);
      yield GetBonusState(bonus);
    }

    if (event is GetAllBonus) {
      var bonusList = await dbHelper.allBonus();
      yield AllBonusState(bonusList);
    }

    if (event is UpdateEvent) {
      int id = await dbHelper.saveOrUpdateBonus(event.bonus);
      yield BonusWasUpdated(event.bonus.copyWith(id: id));
    }

    if (event is StoreBonus) {
      int id = await dbHelper.saveOrUpdateBonus(event.bonus);
      var all = await dbHelper.allBonus();
      print(all);

      yield BonusWasStored(event.bonus.copyWith(id: id));
    }
  }
}
