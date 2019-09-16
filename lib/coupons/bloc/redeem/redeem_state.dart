import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RedeemState extends Equatable {
  RedeemState([List props = const []]) : super(props);
}

class InitialRedeemState extends RedeemState {}

class LoadingState extends RedeemState {}

class CompletedState extends RedeemState {
  final String message;
  final String code;

  CompletedState(this.message, this.code);
}

class ResultMessageState extends RedeemState {
  final String message;
  final String code;
  final bool hasError;

  ResultMessageState(this.message, this.code, {this.hasError: false});
}
