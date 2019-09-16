import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';

import './get_user_info.dart';

class GetUserInfoBloc extends Bloc<GetUserInfoEvent, GetUserInfoState> {
  @override
  GetUserInfoState get initialState => InitialGetUserInfoState();

  @override
  Stream<GetUserInfoState> mapEventToState(
    GetUserInfoEvent event,
  ) async* {
    if (event is GetUserInfoEventImpl) {
      yield ConnectingState();
      var session = DolceGustoSession(dioHolder: DioHolder(Dio()));

      await for (final message in session.login(event.username, event.password)){
        yield new MessageState(message);
      }

      if (!await session.isLogged) {
        yield new MessageState('Could not connect');
        throw new Exception("Could not connect");
      }

      var bonus = await session.bonusPoints;
      var clientName = await session.clientName;


      yield new SuccessfulState(clientName, bonus, getMessage());
    }
  }

  String getMessage() {
    return 'getting the message';
  }
}
