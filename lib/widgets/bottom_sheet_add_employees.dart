import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;

class bottomSheetAdd {
  settingModalBottomSheet(context) {
    TextEditingController _code = new TextEditingController();
    TextEditingController _name = new TextEditingController();
    TextEditingController _fname = new TextEditingController();
    TextEditingController _lname = new TextEditingController();
    bool done = false;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _code,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (value) {},
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Employee's Email",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextField(
                          controller: _name,
                          keyboardType: TextInputType.phone,
                          textCapitalization: TextCapitalization.words,
                          //  focusNode: FocusNode(),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (value) {},
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Employee's phone number ",
                              hintText: "080xxxxxxxx",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextField(
                          controller: _fname,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          //  focusNode: FocusNode(),
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Employee's First name",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextField(
                          controller: _lname,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          // focusNode: FocusNode(),
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          onSubmitted: (value) {
                            post(context, _code.text.trim(), _name.text,
                                _fname.text, _lname.text);
                          },
                          decoration: InputDecoration(
                              labelText: "Employee's Last name",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // ScalingText('Loading...'),
                        FlatButton(
                          onPressed: () => post(context, _code.text.trim(),
                              _name.text, _fname.text, _lname.text),
                          child: Text(
                            "ADD",
                          ),
                          textColor: Colors.white,
                          //   focusNode: FocusNode(),
                          color: Colors.indigoAccent,
                          splashColor: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  dynamic post(BuildContext context, String email, String phone, String fname,
      String lname) async {
    var error = '';

    bool checked = false;
    if (email.isEmpty) {
      // The form is empty
      Toast.show("Enter email address", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      //     return "Enter email address";
    }
    if (fname.isEmpty) {
      // The form is empty
      Toast.show("Enter First Name", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      //     return "Enter email address";
    }
    if (lname.isEmpty) {
      // The form is empty
      Toast.show("Enter Last Name", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      //     return "Enter email address";
    }

    if (phone.isEmpty || phone.length < 6) {
      // The form is empty
      Toast.show("Enter a phone number of at least 6 characters", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

//       return "Enter a password of at least 6 characters";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(email) && phone.isNotEmpty) {
      // So, the email is valid
      Toast.show("Adding.....", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      //when done, close bottomSheet
      //get SharedPref
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return String
      String token = prefs.getString('token');
      //call api here
      addEmployee(fname, lname, email, phone, token, context);
    } else {
      Toast.show("Enter a valid credentials", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  addEmployee(String firstname, String lastname, String email, String phone,
      String token, BuildContext context) async {
    bool done = false, checked = false;
    Map data = {
      'email': email.trim(),
      'firstname': firstname.trim(),
      'lastname': lastname.trim(),
      'phone': phone.trim()
    };

    var jsonData, error;
    var response =
        await http.post(Constants.domain + "addEmployee", body: data, headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print('success: ' + response.body);
      done = true;
      if (done) {
        Toast.show("ADDED SUCCESSFULLY", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else {
        if (checked) {
          Toast.show("Something went wrong", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          checked = false;
        } else {
          Toast.show("This employee has been registered already", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    } else {
      try {
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
        if (response.statusCode == 422) {
          //user not found prompt
          if (jsonData['errors']['email'].toString() != 'null') {
            error = jsonData['errors']['email'].toString().substring(
                1, jsonData['errors']['email'].toString().length - 1);
          } else if (jsonData['errors']['user'].toString() != 'null') {
            print('reached here');
            error = jsonData['errors']['user']
                .toString()
                .substring(1, jsonData['errors']['user'].toString().length - 1);
          } else {
            error = jsonData['message'].toString();
          }
          done = false;
          showToast('$error',
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              reverseAnimation: StyledToastAnimation.slideToTop,
              position: StyledToastPosition.top,
              startOffset: Offset(0.0, -3.0),
              reverseEndOffset: Offset(0.0, -3.0),
              duration: Duration(seconds: 4),
              //Animation duration   animDuration * 2 <= duration
              animDuration: Duration(seconds: 1),
              curve: Curves.elasticOut,
              reverseCurve: Curves.fastOutSlowIn);
        }
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        error = 'Oops! Something went wrong.';
        done = false;
        showToast('$error',
            context: context,
            animation: StyledToastAnimation.slideFromTop,
            reverseAnimation: StyledToastAnimation.slideToTop,
            position: StyledToastPosition.top,
            startOffset: Offset(0.0, -3.0),
            reverseEndOffset: Offset(0.0, -3.0),
            duration: Duration(seconds: 4),
            //Animation duration   animDuration * 2 <= duration
            animDuration: Duration(seconds: 1),
            curve: Curves.elasticOut,
            reverseCurve: Curves.fastOutSlowIn);
      }
    }
  }
}
