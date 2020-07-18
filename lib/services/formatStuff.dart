import 'package:intl/intl.dart';

class formatStuff {
  String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("H:m:s").format(now);
  }

  static String getDate() {
    var now = new DateTime.now();
    return new DateFormat('yyyy-MM-dd').format(now);
  }

  static String formatDate(String date) {
    String formated = '';
    if (date == 'today') {
      formated = getDate().trim();
    } else {}
    return formated;
  }

  static String formatMoney(String amount) {
    return new NumberFormat.simpleCurrency(locale: "en_US")
        .format(amount)
        .toString();
  }
}
