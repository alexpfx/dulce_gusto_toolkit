import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

class BonusPointsParser {
  final Dio dio;
  final String bonusUrl;

  BonusPointsParser(this.dio, this.bonusUrl);

  Future<int> get parsePoints async {
    var r = await dio.get(bonusUrl);
    if (r.statusCode == 200) {
      var doc = html.parse(r.data);
      var bonusBox = doc.querySelector('.box.info-box.bonus-number-box');
      var digits = bonusBox.querySelectorAll('.digit');
      return _extractDigits(digits);
    } else {
      print(r.statusMessage);
      print(r.statusCode);
      print(r.extra);
    }
    return null;
  }

  int _extractDigits(List<Element> digits) {
    var list = [];
    for (var d in digits) {
      var digit = d.attributes['class'];
      var n = _toDigit(digit);
      list.add(n);
    }
    return int.parse(list.join());
  }

  int _toDigit(String digit) {
    return _mapStringNumber[digit];
  }

  var _mapStringNumber = {
    'digit digit-0': 0,
    'digit digit-1': 1,
    'digit digit-2': 2,
    'digit digit-3': 3,
    'digit digit-4': 4,
    'digit digit-5': 5,
    'digit digit-6': 6,
    'digit digit-7': 7,
    'digit digit-8': 8,
    'digit digit-9': 9,
  };
}
