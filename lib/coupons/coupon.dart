

class Coupon {
  String code;
  DateTime dateAdded;
  Status status;

  Coupon(this.code, {this.dateAdded, this.status});

  @override
  String toString() {
    return 'Coupon{code: $code, dateAdded: $dateAdded, status: $status}';
  }


}

enum Status {
  redeemed,
  added_new,
  error,
}
