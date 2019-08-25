import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn_event.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnState> {
  ConnectionBloc();

  @override
  ConnState get initialState => InitialState();

  @override
  Stream<ConnState> mapEventToState(ConnectionEvent event) async* {
    if (event is LoginDgEvent) {
      try {
        var session = event.session;

        await for (final message in session.login()){
          yield new MessageSend(await message);
        }

        if (await session.isLogged) {
          yield ConnectionSuccessState("conexão ok");
        } else {
          yield CouldNotConnect();
        }
      } catch (e) {
        print(e);
        yield InitialState();
      }
    }
  }
}
