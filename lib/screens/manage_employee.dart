import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/constants.dart';
import 'package:kaku/models/employee.dart';
import 'package:kaku/screens/manage_employee_tile.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class ManageEmployee extends StatefulWidget {
  String token;
  bool loaded = false;
  List<Employee> list;

  ManageEmployee(this.token);

  @override
  _ManageEmployeeState createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  @override
  void initState() {
    super.initState();
    getEmployees(widget.token);
  }

  void getEmployees(String token) async {
    var response =
        await http.get(Constants.domain + "vendorGetEmployees", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        print('success: ' + response.body);
        final List parsedList = json.decode(response.body);

        widget.list = parsedList.map((val) => Employee.fromJson(val)).toList();

        setState(() {
          widget.loaded = true;
        });
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        Toast.show("Error while fetching data", context);
        setState(() {
          widget.loaded = false;
        });
      }
    } else {
      try {
        setState(() {
          widget.loaded = false;
        });
        Toast.show("Error while fetching data", context);
        print('failed: ' + response.body);
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: !widget.loaded
          ? CircularProgressIndicator(
              backgroundColor: Colors.white,
            )
          : Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context)),
                title: const Text('Click to Manage'),
              ),
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return ManageEmployeeTile(
                      token: widget.token, employee: widget.list[index]);
                },
              ),
            ),
    );
  }
}
