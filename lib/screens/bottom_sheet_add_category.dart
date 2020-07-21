import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/constants.dart';
import 'package:kaku/screens/add_product_line.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class bottomSheetAddCategory {
  void settingModalBottomSheet(context, String token) {
    TextEditingController _productNameController = new TextEditingController();
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
                    child: TextFormField(
                      controller: _productNameController,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Category name',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {
                        addCategory(_productNameController.text, context);
                      },
                      child: Text(
                        "Add",
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

  addCategory(String name, BuildContext context) async {
    Toast.show("Adding....", context);

    Map data = {'name': name.trim()};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");

    var jsonData;
    var response = await http
        .post(Constants.domain + "addProductCategory", body: data, headers: {
      'Authorization': 'Bearer $token',
    });

    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print('success: ' + response.body);
      Toast.show('Done', context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => add_product_line(
          token: token,
        ),
      ));
    } else {
      try {
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
        if (response.statusCode == 422) {
          //user not found prompt
          String error = "";
          ///////////TODO///////////////////////////////////////////
          if (jsonData['errors'].toString() != 'null') {
            error = jsonData['errors']
                .toString()
                .substring(1, jsonData['errors'].toString().length - 1);
          } else {
            error = jsonData['message'].toString();
          }
          //////////////////////////////////////////////////////
          Toast.show("Oops! $error", context);
        }
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        String error = "";
        error = 'Oops! Something went wrong.';
        Toast.show("Oops! $error", context);
      }
    }
  }
}
