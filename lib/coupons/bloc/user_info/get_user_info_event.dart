import 'package:dulce_gusto_toolkit/coupons/dg_session.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GetUserInfoEvent extends Equatable {
  GetUserInfoEvent([List props = const []]) : super(props);
}

class GetUserInfoEventImpl extends GetUserInfoEvent{
  final DolceGustoSession session;

  GetUserInfoEventImpl(this.session): super([session]);


}
