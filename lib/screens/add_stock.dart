import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../constants.dart';

class add_stock extends StatefulWidget {
  String product_no;
  String cost_price = '';
  String selling_price = '';
  String quantity = ' ';
  String discount = ' ';
  String description = ' ';

  add_stock(
      {Key key,
      @required this.product_no,
      this.cost_price,
      this.selling_price,
      this.quantity,
      this.discount,
      this.description})
      : super(key: key);

  @override
  _add_stockState createState() => _add_stockState();
}

class _add_stockState extends State<add_stock> {
  final focus1 = FocusNode();

  final focus2 = FocusNode();

  final focus3 = FocusNode();

  final focus4 = FocusNode();

  final focus5 = FocusNode();

  final focus6 = FocusNode();

  bool _isLoading = false;
  var error = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _productNumberController = TextEditingController();
  TextEditingController _costPriceController = new TextEditingController();
  TextEditingController _sellingPriceController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _quantityController = new TextEditingController();
  TextEditingController _discountController = new TextEditingController(text: '0');

  //strings to save state
  String productNumber;
  String costPrice;
  String sellingPrice;
  String quantity;
  String discount;
  String description;

  addStock(String product_id, String cost_price, String selling_price,
      String quantity, String discount, String description) async {
    Map data = {
      'product_id': product_id.trim(),
      'cost_price': cost_price.trim(),
      'selling_price': selling_price.trim(),
      'quantity': quantity.trim(),
      'discount': discount.trim(),
      'description': description.trim()
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");

    var jsonData;
    var response =
        await http.post(Constants.domain + "addStock", body: data, headers: {
      'Authorization': 'Bearer $token',
    });

    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print('success: ' + response.body);
      setState(() {
        _isLoading = false;
        Toast.show('Done', context);
        Navigator.pop(context);
      });
    } else {
      try {
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
        if (response.statusCode == 422) {
          //user not found prompt
          setState(() {
            ///////////TODO///////////////////////////////////////////
            if (jsonData['errors']['product_id'].toString() != 'null') {
              error = jsonData['errors']['product_id'].toString().substring(
                  1, jsonData['errors']['product_id'].toString().length - 1);
            }else if(jsonData['errors']['discount'].toString() != 'null'){
              error = jsonData['errors']['discount'].toString().substring(
                  1, jsonData['errors']['discount'].toString().length - 1);
            }  else {
              error = jsonData['message'].toString();
            }
            //////////////////////////////////////////////////////
            _isLoading = false;
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
          });
        }
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        error = 'Oops! Something went wrong.';
        setState(() {
          _isLoading = false;
        });
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

  @override
  Widget build(BuildContext context) {
    String getSystemTime() {
      var now = new DateTime.now();
      return new DateFormat("H:m:s").format(now);
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

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[50],
        key: _scaffoldKey,
        body: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : ListView(
                  children: <Widget>[
                    SizedBox(height: 30), //space
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 10, 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add Stock\n_____",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: new Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Card(
                          //   key: _formKey,

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                leading: Icon(Icons.all_inclusive),
                                title: Text("KAKU"),
                                subtitle: Text(
                                    'Add a new stock by simply specifying the item count and any other parameters'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  initialValue: widget.product_no,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus1);
                                  },
                                  onSaved: (String value) {
                                    productNumber = widget.product_no;
                                  },
                                  textInputAction: TextInputAction.next,
                                  validator: _validateProductNumber,
                                  enabled: false,
                                  style: TextStyle(color: Colors.grey[900]),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: 'Product ID',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  validator: _validateCostPrice,
                                  onSaved: (String value) {
                                    costPrice = value;
                                  },
                                  controller: _costPriceController,
                                   textCapitalization: TextCapitalization.words,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus2);
                                  },
                                  focusNode: focus1,
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Cost Price',
                                      hintText: 'Amount in ₦',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    sellingPrice = value;
                                  },
                                  validator: _validateSellingPrice,
                                  controller: _sellingPriceController,
                                   textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus3);
                                  },
                                  focusNode: focus2,
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Selling Price',
                                      hintText: 'Amount in ₦',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    quantity = value;
                                  },
                                  validator: _validateQuantity,
                                  controller: _quantityController,
                                   textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus4);
                                  },
                                  focusNode: focus3,
                                  style: TextStyle(
                                    color: Colors.green[900],
                                  ),
                                  decoration: InputDecoration(
                                      labelText: 'Quantity',
                                      hintText: 'Number of items in stock',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    discount = value;
                                  },
//                                  validator: _validateConfirmPassword,
                                  controller: _discountController,
                                      textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus5);
                                  },
                                  focusNode: focus4,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      labelText: 'Discount',
                                      hintText: 'Amount in ₦',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    description = value;
                                  },
                                  controller: _descriptionController,
                                  textInputAction: TextInputAction.done,
                                  focusNode: focus5,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      labelText: 'Description (optional)',
                                      hintText: 'Some text',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  initialValue: getDate(),
                                  enabled: false,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    color: Colors.deepPurple[900],
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: 'Date',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.grey[200],
                                    child: const Text('List'),
                                    onPressed: () {
                                      /* ... */
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: _validateInputs,
                      child: Text(
                        "ADD STOCK",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
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

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Enter a valid Email address';
  }

  String _validateQuantity(String value) {
    if (value.length > 0) {
      return null;
    }

    return 'Please enter a quantity more than 0';
  }

  String _validateConfirmPassword(String value) {
    if (value.length > 5 && value == _quantityController.text) {
      return null;
    }
    return 'Passwords must match';
  }

  String _validatePhone(String value) {
    if (value.length > 10 && value.length < 16) {
      return null;
    }
    return 'Enter a valid phone number';
  }

  String _validateProductNumber(String value) {
    if (value.length > 0) {
      return null;
    }

    return 'Please enter a product number';
  }

  String _validateCostPrice(String value) {
    if (value.length > 0) {
      return null;
    }

    return 'Please enter a Cost Price';
  }

  String _validateSellingPrice(String value) {
    if (value.length > 0) {
      return null;
    }

    return 'Please enter a Selling Price';
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms has validated.
      // Every of the data in the form are valid at this point
      form.save();
//      showDialog(
//          context: context,
//          builder: (BuildContext context) =>
//          new AlertDialog(
//            content: new Text("Processing registration...."),
//          ));
      setState(() {
        _isLoading = true;
      });
      addStock(
          productNumber.trim().toUpperCase(),
          _costPriceController.text.trim().toUpperCase(),
          _sellingPriceController.text.trim().toUpperCase(),
          _quantityController.text.trim(),
          _discountController.text.trim(),
          _descriptionController.text.trim());
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
