import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GetUserInfoState extends Equatable {
  GetUserInfoState([List props = const []]) : super(props);
}

class InitialGetUserInfoState extends GetUserInfoState {}

class ConnectingState extends GetUserInfoState {}

class MessageState extends GetUserInfoState{
  final String message;

  MessageState(this.message);

}


class SuccessfulState extends GetUserInfoState {
  final String clientName;
  final int points;
  final String message;




  SuccessfulState(this.clientName, this.points, this.message);
}
