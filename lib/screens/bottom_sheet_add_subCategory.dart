import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'add_product_line.dart';

class bottomSheetAddSubCategory {
  void settingModalBottomSheet(context, List category, String token) {
    TextEditingController _productSubCategoryNameController =
        new TextEditingController();

    String category_id = "1";
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  new Padding(
                    padding: MediaQuery.of(context).viewPadding,
                    child: TextFormField(
                      controller: _productSubCategoryNameController,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Sub Category name',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  new Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: "Select the category it falls under",
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      value: category[0]['value'],
                      items: category.map((map) {
                        return DropdownMenuItem(
                          child: Text(map['name']),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        category_id = value;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {
                        addSubCategory(_productSubCategoryNameController.text,
                            category_id, context);
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

  addSubCategory(
      String name, String product_category_id, BuildContext context) async {
    Toast.show("Adding....", context);
    Map data = {
      'name': name.trim(),
      'product_category_id': product_category_id.trim()
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");

    var jsonData;
    var response = await http
        .post(Constants.domain + "addProductSubCategory", body: data, headers: {
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
