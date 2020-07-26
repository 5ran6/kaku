import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/screens/specific_report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class bottomSheetMonthly {
  void settingModalBottomSheet(context) {
    String month = '01';

    String monthName= 'January';

    List monthList = [
      {'name': 'January', 'value': '1'},
      {'name': 'February', 'value': '2'},
      {'name': 'March', 'value': '3'},
      {'name': 'April', 'value': '4'},
      {'name': 'May', 'value': '5'},
      {'name': 'June', 'value': '6'},
      {'name': 'July', 'value': '7'},
      {'name': 'August', 'value': '8'},
      {'name': 'September', 'value': '9'},
      {'name': 'October', 'value': '10'},
      {'name': 'November', 'value': '11'},
      {'name': 'December', 'value': '12'}
    ];

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
                    padding: MediaQuery
                        .of(context)
                        .viewInsets,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        hintText: 'Select a month',
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      value: "1",

                      items: monthList.map((map) {

                        return DropdownMenuItem(
                          child: Text(map['name']),
                          value: map['value'],

                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        //TODO: send to server or do other stuff
                        month = value;
                        monthName = monthList[int.parse(value)-1]['name'];
                        Toast.show(monthName, context);

                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {
                        getReport(context, month, monthName);
                      },
                      child: Text(
                        "Generate",
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

  void getReport(BuildContext context, String month, String monthN) async {
    String cashAtHand = '0';
    String paymentCount = '0';
    String paymentsAmount = '0';
    String netProfit = '0';
    String expenses = '0';
    List payment = [];
    Toast.show("Fetching records...", context);
//YYYY-MM-DD
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");
    Map data = {'month': month.trim(),'year': '2020'};

    var response = await http
        .post(Constants.domain + "perMonthSalesReport", body: data, headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        print('success: ' + response.body);

        payment = json.decode(response.body)['data']['payments'];
        paymentCount =
            json.decode(response.body)['data']['payments_count'].toString();

        cashAtHand =
            json.decode(response.body)['data']['cash_at_hand'].toString();
        netProfit =
            json.decode(response.body)['data']['date_net_profit'].toString();
        expenses =
            json.decode(response.body)['data']['date_expenses'].toString();
        paymentsAmount = json
            .decode(response.body)['data']['payments_amount_total']
            .toString();
        print('Values: ' +
            paymentCount +
            ' ' +
            paymentsAmount.toString() +
            ' ' +
            cashAtHand.toString() +
            ' ' +
            payment.toString());

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              SpecificReport('As at $monthN', paymentCount,
                  paymentsAmount, cashAtHand, payment, expenses, netProfit),
        ));
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error: ' + response.body);
        Toast.show("Error while fetching data", context);
      }
    } else {
      try {
        Toast.show(
            json.decode(response.body)['errors']['data'] .toString().substring(
                1,
                json.decode(response.body)['errors']['data']
                    .toString()
                    .length -
                    1),
            context);
        print('failed: ' + response.body);
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error: ' + response.body);
      }
    }
  }
}
