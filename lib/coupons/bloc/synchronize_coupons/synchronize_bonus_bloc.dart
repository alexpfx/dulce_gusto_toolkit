import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dulce_gusto_toolkit/model/data/database_helper.dart';
import './synchronize_bonus.dart';

class SynchronizeBonusBloc extends Bloc<SynchronizeBonusEvent, SynchronizeBonusState> {
  @override
  SynchronizeBonusState get initialState => InitialSynchronizeBonusState();

  @override
  Stream<SynchronizeBonusState> mapEventToState(
    SynchronizeBonusEvent event,
  ) async* {

    if (event is SynchronizeOneBonus){
      var bonus = await dbHelper.theBonus(event.coupon.id);

      yield BonusWasUpdatedState(bonus);
      //TODO ver como tratar erro.

    }

  }
}
