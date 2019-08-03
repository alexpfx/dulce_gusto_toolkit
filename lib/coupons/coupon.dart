

class Coupon {
  String code;
  DateTime dateAdded;
  Status status;

  Coupon(this.code, {this.dateAdded, this.status});
}

enum Status {
  redeemed,
  added_new,
  error,
}
