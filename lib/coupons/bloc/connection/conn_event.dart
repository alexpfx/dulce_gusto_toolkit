import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:dulce_gusto_toolkit/coupons/user/user_credentials.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConnectionEvent extends Equatable {
  ConnectionEvent([List props = const []]) : super(props);
}

class LoginDgEvent extends ConnectionEvent {
  final String username;
  final String password;

  LoginDgEvent(this.username, this.password) : super([username, password]);
}
