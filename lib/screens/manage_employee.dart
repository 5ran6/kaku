import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/constants.dart';
import 'package:kaku/models/employee.dart';
import 'package:kaku/screens/manage_employee_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ManageEmployee extends StatefulWidget {
  String token;
  bool loaded = false;
  List list;

  ManageEmployee();

  @override
  _ManageEmployeeState createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  @override
  void initState() {
    super.initState();
    //  getEmployees( );
  }

  Future getEmployees() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");
    var response =
        await http.get(Constants.domain + "vendorGetEmployees", headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        print('success: ' + response.body);
        Map<String, dynamic> products = json.decode(response.body);

        widget.list = products['data']['employees'];
        return widget.list;
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
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: const Text('Click to Manage an Employee'),
        ),
        body: FutureBuilder(
          future: getEmployees(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(10.0, 2, 2, 0),
                      child: ListTile(
                        onTap: () {
                          //actions with dialogs
                          showAlertDialog(
                              context,
                              widget.list[index]['id'].toString(),
                              widget.list[index]['phone'],
                              widget.list[index]['lastname'] +
                                  " " +
                                  widget.list[index]['firstname'],
                              widget.list[index]['user']['is_active']);
                        },
                        trailing: Icon(
                          widget.list[index]['user']['is_active'] == "1"
                              ? Icons.done_outline
                              : Icons.warning,
                        ),
                        leading: Icon(Icons.perm_identity),
                        title: Text(widget.list[index]['lastname'] +
                            " " +
                            widget.list[index]['firstname']),
                        subtitle:
                            Text("Phone:  " + widget.list[index]['phone']),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String id, String phoneNumber,
      String name, String status) {
    // set up the buttons
    Widget suspendEmployee = FlatButton(
      child: Text("Suspend Employee"),
      onPressed: () async {
        //send just picked to server
        Map data = {'id': id};
        Toast.show("Processing..", context);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String token = await sharedPreferences.get("token");

        var response = await http.post(
            Constants.domain + "vendorDeactivateEmployee",
            body: data,
            headers: {
              'Authorization': 'Bearer $token',
            });
        print('Response = ' + response.body.toString());
        Navigator.pop(context);
        setState(() {});
//        //pop
//        Navigator.of(context).pushReplacement(MaterialPageRoute(
//          builder: (context) => ManageEmployee(),
//        ));
      },
    ); // set up the buttons
    Widget unsuspendEmployee = FlatButton(
      child: Text("Unsuspend Employee"),
      onPressed: () async {
        Map data = {'id': id};
        Toast.show("Processing..", context);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String token = await sharedPreferences.get("token");

        var response = await http.post(
            Constants.domain + "vendorActivateEmployee",
            body: data,
            headers: {
              'Authorization': 'Bearer $token',
            });
        //pop
        print('Response = ' + response.body.toString());
        Navigator.pop(context);
        setState(() {});
      },
    ); // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () async {
        //pop
        Navigator.of(context).pop();
      },
    ); // set up the buttons

    Widget copyPhoneButton = FlatButton(
      child: Text("Dial Phone"),
      onPressed: () async {
//        String phone = phoneNumber;
        String url = "tel:$phoneNumber";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
        //pop
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Text("Want to"),
      actions: [suspendEmployee, copyPhoneButton, cancelButton],
    );
    AlertDialog alert2 = AlertDialog(
      title: Text(name),
      content: Text("Want to "),
      actions: [unsuspendEmployee, copyPhoneButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("Status: $status");
        if (status == '1') {
          return alert;
        } else {
          return alert2;
        }
      },
    );
  }
}
