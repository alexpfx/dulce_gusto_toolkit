



enum RedeemResultStatus {
  newBonus,
  redeemingInProgress,
  info_ok,
  info_fail
}

/*
class CouponCodeCard extends StatelessWidget {
  final String coupon;
  final RedeemResultStatus status;

  CouponCodeCard(this.coupon, this.status);

  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RedeemResultStatusWidget(result: RedeemEvent(
                    status: RedeemResultStatus.info_ok,
                    code: 'xxxs ssfa pala',
                    message: 'Cupom resgatado com sucesso. Mais 10 pontos na sua conta.'

                  )),
                  InkWell(
                    child: Text(
                      coupon,
                      style: Theme.of(context).textTheme.title.copyWith(
                          letterSpacing: 1,
                          wordSpacing: 2,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: coupon));
                      if (scaffold != null) {
                        scaffold.showSnackBar(SnackBar(
                            content: Text("${coupon} into clipboard!")));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: SizedBox()),
        ]);
  }


}



*/
