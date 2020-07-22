import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/widgets/animated_numeric_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:kaku/services/formatStuff.dart';

import '../constants.dart';

class bottomSheetDaily {
  void settingModalBottomSheet(context, String passed, StateSetter setState) {
    DateTime selectedDate = DateTime.now();
    String cashAtHand = '0';
    String paymentCount = '0';
    String payment = 'Payments for this day';

    String netProfitToday = '0';
    final theme = Theme.of(context);

    String expensesToday = '0';
    String paymentsAmountToday = '0';
    String date = passed;
    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.accentColor).first;

    final linearGradient = LinearGradient(colors: [
      primaryColor.shade800,
      primaryColor.shade200,
    ]).createShader(Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));
    double i = 0;
    bool visible = false;

    // 2020-07-06
    void getReportToday(String date) async {
//YYYY-MM-DD
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = await sharedPreferences.get("token");
      Map data = {'date': date.trim()};

      var response = await http
          .post(Constants.domain + "perDaySalesReport", body: data, headers: {
        'Authorization': 'Bearer $token',
      });
      print('Status Code = ' + response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          print('success: ' + response.body);

          payment =
              formatStuff.formatMoney(json.decode(response.body)['payments']);
          paymentCount = formatStuff
              .formatMoney(json.decode(response.body)['payments_count']);

          cashAtHand = formatStuff
              .formatMoney(json.decode(response.body)['cash_at_hand']);
          netProfitToday = formatStuff
              .formatMoney(json.decode(response.body)['date_net_profit']);
          expensesToday = formatStuff
              .formatMoney(json.decode(response.body)['date_expenses']);
          paymentsAmountToday = formatStuff
              .formatMoney(json.decode(response.body)['payments_amount_total']);
          setState(() {
            visible = true;
          });
        } on FormatException catch (exception) {
          print('Exception: ' + exception.toString());
          print('Error: ' + response.body);
          Toast.show("Error while fetching data", context);
        }
      } else {
        try {
          Toast.show(json.decode(response.body)['errors']['data'].toString().substring(1, json.decode(response.body)['errors']['data'].toString().length-1), context);
          print('failed: ' + response.body);
        } on FormatException catch (exception) {
          print('Exception: ' + exception.toString());
          print('Error: ' + response.body);
        }
      }
    }

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020, 7),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        // Toast.show(selectedDate.toLocal().toString(), context);
        date = "${selectedDate.toLocal()}".split(' ')[0];
        Navigator.pop(context);
        settingModalBottomSheet(context, date, setState);
      }
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          date,
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 10.0,
                        ),
                        RaisedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Select date'),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {
                        print(date);
                        getReportToday(date);
                      },
                      child: Text(
                        "Submit",
                      ),
                      textColor: Colors.white,
                      color: Colors.indigoAccent,
                      splashColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  visible
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
/*
 payments, payments_count, payments_amount_total, year_expenses,
year_net_proft, cash_at_hand

* */

                                Icon(
                                  Icons.payment,
                                  color: Colors.green[700],
                                ),
                                Text(
                                  payment.toUpperCase(),
                                  style: theme.textTheme.display3.copyWith(
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
/*
 payments, payments_count, payments_amount_total, year_expenses,
year_net_proft, cash_at_hand

* */

                                Icon(
                                  Icons.format_list_numbered_rtl,
                                ),
                                Text("Number of Payments: " +
                                    formatStuff.formatMoney(paymentCount)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
/*
 payments, payments_count, payments_amount_total, year_expenses,
year_net_proft, cash_at_hand

* */

                                Icon(
                                  Icons.payment,
                                  color: Colors.green[400],
                                ),
                                Text("Total Payment Amount: ₦" +
                                    formatStuff
                                        .formatMoney(paymentsAmountToday)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
/*
 payments, payments_count, payments_amount_total, year_expenses,
year_net_proft, cash_at_hand

* */

                                Icon(
                                  Icons.payment,
                                  color: Colors.orange[800],
                                ),
                                Text("Total Expenses Amount: ₦" +
                                    formatStuff.formatMoney(expensesToday)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
/*
 payments, payments_count, payments_amount_total, year_expenses,
year_net_proft, cash_at_hand

**/

                                Icon(
                                  Icons.payment,
                                  color: Colors.orange[800],
                                ),
                                Text("Net Profit Amount: ₦" +
                                    formatStuff.formatMoney(netProfitToday)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
/*
 payments, payments_count, payments_amount_total, year_expenses,
year_net_proft, cash_at_hand

* */

                                Icon(
                                  Icons.payment,
                                  color: Colors.black,
                                ),
                                Text("Cash at Hand: ₦" +
                                    formatStuff.formatMoney(cashAtHand)),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
        });
  }
}
