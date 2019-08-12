import 'package:equatable/equatable.dart';

abstract class ConnState extends Equatable {
  ConnState([List props = const []]) : super(props);

  EnumConnectionState get asEnum;
}

enum EnumConnectionState {
  initial,
  connecting,
  login_succefull,
  could_not_connect
}

class InitialState extends ConnState {
  @override
  EnumConnectionState get asEnum => EnumConnectionState.initial;
}

class ConnectingState extends ConnState {
  @override
  EnumConnectionState get asEnum => EnumConnectionState.connecting;
}

class CouldNotConnect extends ConnState {
  @override
  EnumConnectionState get asEnum => EnumConnectionState.could_not_connect;
}

class ConnectionSuccessState extends ConnState {
  final String loginMessage;

  ConnectionSuccessState(this.loginMessage) : super([loginMessage]);

  @override
  EnumConnectionState get asEnum => EnumConnectionState.login_succefull;
}
