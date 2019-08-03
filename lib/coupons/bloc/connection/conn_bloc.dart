import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn_event.dart';
import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn_state.dart';
import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnState> {
  final DgSession _session;

  ConnectionBloc(this._session);

  @override
  ConnState get initialState => InitialState();

  @override
  Stream<ConnState> mapEventToState(ConnectionEvent event) async* {
    if (event is LoginDgEvent) {
      print('event: $event');
      yield ConnectingState();
      String errMessage;
      print("after event");

      try {
        await _session.logout();
        bool hasLogged = await _session
            .login(event.userCredential.login, event.userCredential.password)
            .catchError((err) {
          errMessage = err;
          throw err;
        });

        if (hasLogged) {
          yield ConnectionSuccessState(hasLogged ? 'Ok' : errMessage);
        }
      } catch (e) {
        yield InitialState();
      }
    }
  }
}
