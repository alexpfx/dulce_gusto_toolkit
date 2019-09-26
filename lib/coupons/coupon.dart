import 'package:dulce_gusto_toolkit/coupons/bonus_list/coupon_card/redeem_status.dart';

class Coupon {
  static final String tableName = "coupons";
  static final String columnId = "id";
  static final String columnCode = "code";
  static final String columnDateAdded = "dateAdded";
  static final String columnStatus = "status";
  static final String columnLastMessage = "lastMessage";
  static final String columnDateLastAttempt = "dateLastAttempt";
  static final String columnStatusLastAttempt = "statusLastAttempt";
  static final String columnMarkedForDelection = "markedForDelection";

  final int id;
  final String code;
  final DateTime dateAdded;
  final Status status;
  final bool markedForDelection;

  RedeemAttempt redeemAttempt;

  Coupon(
      {this.code,
      this.dateAdded,
      this.status,
      this.redeemAttempt,
      this.id,
      this.markedForDelection});

  @override
  String toString() {
    return 'Coupon{code: $code, dateAdded: $dateAdded, status: $status}';
  }

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnCode: code,
      columnMarkedForDelection:
          markedForDelection == null || !markedForDelection ? 0 : 1,
      columnDateAdded: dateAdded.millisecondsSinceEpoch
      /*columnStatus: status,
      columnLastMessage: redeemAttempt.message,
      columnDateLastAttempt: redeemAttempt.date,
      columnStatusLastAttempt: redeemAttempt.status*/
    };
  }

  static Coupon fromMap(Map<String, dynamic> map) {
    var deleted = map[columnMarkedForDelection] != null &&
        map[columnMarkedForDelection] == 1;

    return Coupon(
        code: map[columnCode],
        id: map[columnId],
        status: map[columnStatus],
        dateAdded: DateTime.fromMillisecondsSinceEpoch(map[columnDateAdded]),
        markedForDelection: deleted,
        redeemAttempt: RedeemAttempt(
            status: map[columnStatusLastAttempt],
            message: map[columnLastMessage],
            date: map[columnDateLastAttempt]));
  }

  Coupon copyWith(
      {int id,
      String code,
      DateTime dateAdded,
      Status status,
      RedeemAttempt redeemAttempt,
      bool markedForDelection}) {
    return new Coupon(
        id: id ?? this.id,
        code: code ?? this.code,
        dateAdded: dateAdded ?? this.dateAdded,
        status: status ?? this.status,
        redeemAttempt: redeemAttempt ?? this.redeemAttempt,
        markedForDelection: markedForDelection ?? this.markedForDelection);
  }
}

class RedeemAttempt {
  RedeemResultStatus status;
  String message;
  DateTime date;

  RedeemAttempt({this.status, this.message, this.date});
}

enum Status {
  redeemed,
  added_new,
  error,
}

enum RedeemStatus { newBonus, redeemingInProgress, info_ok, info_fail }
