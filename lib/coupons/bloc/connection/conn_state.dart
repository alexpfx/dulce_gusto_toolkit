import 'package:equatable/equatable.dart';

abstract class ConnState extends Equatable {
  ConnState([List props = const []]) : super(props);

}

class InitialState extends ConnState {
}

class MessageSend extends ConnState{
  final String message;

  MessageSend(this.message);


}

class ConnectingState extends ConnState {
}

class CouldNotConnect extends ConnState {

}

class ConnectionSuccessState extends ConnState {
  final String loginMessage;

  ConnectionSuccessState(this.loginMessage) : super([loginMessage]);

}
