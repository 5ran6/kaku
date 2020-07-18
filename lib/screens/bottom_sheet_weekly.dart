import 'dart:convert';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:kaku/services/formatStuff.dart';

import '../constants.dart';

class bottomSheetRange {
  void settingModalBottomSheet(context, String passed) {
    DateTime selectedDate = DateTime.now();
    String cashAtHand = '0';
    String netProfitToday = '0';

    String expensesToday = '0';
    String paymentsAmountToday = '0';
    String date = passed;
// 2020-07-06
    void getReportToday(String date) async {
//YYYY-MM-DD
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String token = await sharedPreferences.get("token");

      var response =
      await http.get(Constants.domain + "payDaySalesReport", headers: {
        'Authorization': 'Bearer $token',
      });
      print('Status Code = ' + response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          print('success: ' + response.body);

          cashAtHand = formatStuff
              .formatMoney(json.decode(response.body)['cash_at_hand']);
          netProfitToday = formatStuff
              .formatMoney(json.decode(response.body)['date_net_profit']);
          expensesToday = formatStuff
              .formatMoney(json.decode(response.body)['date_expenses']);
          paymentsAmountToday = formatStuff
              .formatMoney(json.decode(response.body)['payments_amount_total']);

        } on FormatException catch (exception) {
          print('Exception: ' + exception.toString());
          print('Error' + response.body);
          Toast.show("Error while fetching data", context);
        }
      } else {
        try {
          Toast.show("Error while fetching data", context);
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
        settingModalBottomSheet(context, date);
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
                          child: Text('Select date range'),
                        ),
                        new MaterialButton(
                            color: Colors.deepOrangeAccent,
                            onPressed: () async {
                              final List<DateTime> picked = await DateRagePicker.showDatePicker(
                                  context: context,
                                  initialFirstDate: new DateTime.now(),
                                  initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
                                  firstDate: new DateTime(2020),
                                  lastDate: new DateTime(2101)
                              );
                              if (picked != null && picked.length == 2) {
                                print(picked);


                              }
                            },
                            child: new Text("Pick date range")
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {

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
                ],
              ),
            ),
          );
        });
  }
}
