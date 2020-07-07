import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaku/models/employee.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ManageEmployeeTile extends StatelessWidget {
  final Employee employee;
  final String token;

  ManageEmployeeTile({this.employee, this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6, 20, 0),
        child: ListTile(
          onTap: () {
            //prompt if done
            showAlertDialog(context);
          },
          trailing: Icon(
            employee.data.is_active != "1" ? Icons.done : Icons.warning,
          ),
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor:
                employee.data.is_active != "1" ? Colors.green : Colors.red,
          ),
          title: Text(employee.data.lastname + " " + employee.data.firstname),
          subtitle: Text("Email: " + employee.data.email),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () async {
        //pop
        Navigator.of(context).pop();
      },
    ); // set up the buttons

    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        //activate api
        await activate(token);
        //pop
        Navigator.of(context).pop();
      },
    );
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        //deactivate api
        await deactivate(token);
        //pop
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Do you want to activate this account?"),
      actions: [
        yesButton,
        cancelButton,
      ],
    );
    AlertDialog alert2 = AlertDialog(
      title: Text("Alert"),
      content: Text("Do you want to deactivate this account"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (employee.data.is_active != "2") {
          return alert;
        } else {
          //level is 1
          return alert2;
        }
      },
    );
  }

  String getDate() {
    var now = new DateTime.now();
    return new DateFormat('EEEE').format(now) +
        ', ' +
        now.day.toString() +
        '-' +
        now.month.toString() +
        '-' +
        now.year.toString() +
        ' @ ' +
        getSystemTime();
  }

  String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("H:m:s").format(now);
  }

  Future activate(String id) async {
    Map data = {'id': id};

    var jsonData;
    var response = await http.post(Constants.domain + "vendorActivateEmployee",
        body: data,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        jsonData = json.decode(response.body);
        print('success: ' + response.body);
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    } else {
      try {
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    }
  }

  Future deactivate(String id) async {
    Map data = {'id': id};

    var jsonData;
    var response = await http.post(Constants.domain + "vendorActivateEmployee",
        body: data,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        jsonData = json.decode(response.body);
        print('success: ' + response.body);
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    } else {
      try {
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    }
  }
}
