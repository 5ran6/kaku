import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kaku/constants.dart';
import 'package:kaku/screens/bottom_sheet_add_category.dart';
import 'package:kaku/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaku/screens/invoices.dart';
import 'package:toast/toast.dart';

import 'bottom_sheet_add_subCategory.dart';

class add_product_line extends StatefulWidget {
  final String token;

  add_product_line({Key key, @required this.token}) : super(key: key);

  @override
  _add_product_lineState createState() => _add_product_lineState();
}

class _add_product_lineState extends State<add_product_line> {
  final focus1 = FocusNode();

  final focus2 = FocusNode();

  final focus3 = FocusNode();

  final focus4 = FocusNode();

  final focus5 = FocusNode();

  final focus6 = FocusNode();
  final focus7 = FocusNode();

  bool _isLoading = true;
  var error = 'Try again';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _productCategoryController =
      new TextEditingController();
  TextEditingController _subCategoryController = new TextEditingController();
  TextEditingController _modelController = new TextEditingController();
  TextEditingController _costPriceController = new TextEditingController();
  TextEditingController _sellingPriceController = new TextEditingController();
  TextEditingController _discountController = new TextEditingController();
  TextEditingController _expiryDateController = new TextEditingController();

  //strings to save state
  String name;
  String productCategory;
  String subCategory;
  String costPrice;
  String sellingPrice;
  String model;
  String discount;
  String expiry;
  DateTime selectedDate = DateTime.now();


  List subcategory = [

  ];
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

  List categoryList = [];


  Future _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _expiryDateController.value = TextEditingValue(text: picked.toString());
      });
  }

  addProductLine(
      String name,
      String product_category_id,
      String product_subcategory_id,
      String cost_price,
      String selling_price,
      String model,
      String discount,
      String expiry_date) async {
    Map data = {
      'name': name.trim(),
      'product_category_id': product_category_id.trim(),
      'product_subcategory_id': product_subcategory_id.trim(),
      'cost_price': cost_price.trim(),
      'selling_price': selling_price.trim(),
      'model': model.trim(),
      'discount': discount.trim(),
      'expiry_date': expiry_date.trim()
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");

    var jsonData;
    var response =
        await http.post(Constants.domain + "addProduct", body: data, headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print('success: ' + response.body);
      setState(() {
        //clearAllFields();
        _isLoading = false;
      });
    } else {
      try {
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
        if (response.statusCode == 422) {
          //user not found prompt
          setState(() {
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
  void initState() {
    super.initState();
    //getCategories
    getcategories();
  }

  void getcategories() async {
    //getCategories
//    Map data = {'name': name.trim()};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");

    var jsonData;
    var response = await http.get(Constants.domain + "getProductCategory", headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print('success: ' + response.body);
      //parse Category List
      Map<String, dynamic> categoriesFromApi = json.decode(response.body);
     List cat = categoriesFromApi['categories'];
      for(final i in cat){
        var categoryMap = {
          'name': i['name'],
          'value': i['id'].toString()
        };

        categoryList.add(categoryMap);
      }
print('Category List: '+categoryList.toString());

      setState(() {
      //  clearAllFields();
        _isLoading = false;
      });
    } else {
      try {
        // jsonData = json.decode(response.body);
        print('failed: ' + response.body);
        if (response.statusCode >= 400 ) {

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
          Navigator.pop(context);
        }
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        error = 'Oops! Something went wrong.';
        Navigator.pop(context);
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

  void getSubcategory(String category, String token) async {
    //getSubCategories

  }

  @override
  Widget build(BuildContext context) {
    //signUp function


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
                          "Add Product Line\n_____",
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
                                    'Add new product lines by specifying the correct data per item.'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    name = value;
                                  },
                                  controller: _nameController,
                                  textCapitalization: TextCapitalization.words,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus1);
                                  },
                                  textInputAction: TextInputAction.next,
                                  validator: _validateProductName,
                                  autofocus: true,
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.blue,
                                      ),
                                      labelText: 'Product Name',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),

                              //////drop downs
                              Padding(
                                padding: const EdgeInsets.all(18.0),
//                                child: TextFormField(
//                                  validator: _validateLastName,
//                                  onSaved: (String value) {
//                                    lastName = value;
//                                  },
//                                  controller: _lastNameController,
//                                  textCapitalization: TextCapitalization.words,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focus2);
//                                  },
//                                  focusNode: focus1,
//                                  textInputAction: TextInputAction.next,
//                                  style: TextStyle(
//                                    color: Colors.black,
//                                  ),
//                                  keyboardType: TextInputType.text,
//                                  decoration: InputDecoration(
//                                      labelText: 'Cost Price',
//                                      hintText: 'Amount',
//                                      labelStyle:
//                                          TextStyle(color: Colors.black54),
//                                      border: OutlineInputBorder()),
//                                ),

                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.category),
                                    labelText: 'Select a Category',
                                    filled: true,
                                    fillColor: Colors.white,
                                    errorStyle: TextStyle(color: Colors.yellow),
                                  ),
                                  value: "1",
                                  items: categoryList.map((map) {
                                    return DropdownMenuItem(
                                      child: Text(map['name']),
                                      value: map['value'],
                                    );
                                  }).toList(),
                                  onChanged: (dynamic value) {
                                    _productCategoryController.text = value;
                                    productCategory = value;

                                    //TODO: server call for subCategory using 'value'
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.call_to_action),
                                    labelText: 'Select a Sub category',
                                    filled: true,
                                    fillColor: Colors.white,
                                    errorStyle: TextStyle(color: Colors.yellow),
                                  ),
                                  value: "0",
                                  items: subcategory.map((map) {
                                    return DropdownMenuItem(
                                      child: Text(map['name']),
                                      value: map['value'],
                                    );
                                  }).toList(),
//                                  items: monthList.map((map) {
//                                    return DropdownMenuItem(
//                                      child: Text(map['name']),
//                                      value: map['value'],
//                                    );
//                                  }).toList(),
                                  onChanged: (dynamic value) {
                                    _subCategoryController.text = value;
                                    subCategory = value;
                                  },
                                ),
                              ),
                              ///////////////drop downs

                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    costPrice = value;
                                  },
                                  validator: _validateCostPrice,
                                  controller: _costPriceController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus4);
                                  },
                                  focusNode: focus3,
                                  //    obscureText: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.score,
                                        color: Colors.blue,
                                      ),
                                      labelText: 'Cost Price',
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
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus5);
                                  },
                                  focusNode: focus4,
                                  // obscureText: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.monetization_on,
                                        color: Colors.blue,
                                      ),
                                      labelText: 'Selling Price',
                                      hintText: '',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    value == null ? model = "" : model = value;
                                  },
                                  controller: _modelController,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus6);
                                  },
                                  focusNode: focus5,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.more,
                                        color: Colors.blue,
                                      ),
                                      labelText: 'Model (optional)',
                                      hintText: ' ',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  onSaved: (String value) {
                                    value == null
                                        ? discount = ""
                                        : discount = value;
                                  },
                                  controller: _discountController,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus7);
                                  },
                                  enabled: true,
                                  focusNode: focus6,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    color: Colors.green[900],
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.money_off,
                                        color: Colors.green,
                                      ),
                                      labelText: 'Discount (optional)',
                                      labelStyle:
                                          TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: GestureDetector(
                                  onTap: null,
                                  child: TextFormField(
                                    onSaved: (String value) {
                                      value == null
                                          ? expiry = ""
                                          : expiry = value;
                                    },
                                    controller: _expiryDateController,
                                    focusNode: focus7,
                                    enabled: true,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.calendar_today,
                                          color: Colors.blue,
                                        ),
                                        labelText: 'Expiry Date (optional)',
                                        hintText: 'DD-MM-YYYY',
                                        labelStyle:
                                            TextStyle(color: Colors.black54),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              ButtonBar(
                                children: <Widget>[
                                  FlatButton(
                                    child: const Text(
                                      'Clear?',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    onPressed: () {
                                      /* ... */
                                      final form = _formKey.currentState;
                                      form.reset();
                                    },
                                  ),
                                  FlatButton(
                                    color: Colors.grey[200],
                                    child: const Text('Add new Category'),
                                    onPressed: () {
                                      /* .bottom sheet. */
                                      //TODO:  add category
                                      bottomSheetAddCategory()
                                          .settingModalBottomSheet(context,
                                              widget.token); //remove the null
                                    },
                                  ),
                                  FlatButton(
                                    color: Colors.grey[200],
                                    child: const Text('Add new Sub Category'),
                                    onPressed: () {
                                      /* .bottom sheet. */
                                      //TODO:  select category then use the category ID to add subcategory
                                      bottomSheetAddSubCategory()
                                          .settingModalBottomSheet(
                                              context,
                                              null,
                                              widget.token); //remove the null
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
                        "ADD",
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

  String _validateCostPrice(String value) {
    if (value.length > 0) {
      return null;
    }

    return 'Enter a cost price';
  }

  String _validateSellingPrice(String value) {
    if (value.length > 0) {
      return null;
    }
    return 'Enter a selling price';
  }

  String _validatePhone(String value) {
    if (value.length > 10 && value.length < 16) {
      return null;
    }
    return 'Enter a valid phone number';
  }

  String _validateProductName(String value) {
    if (value.length > 0) {
      return null;
    }

    return 'Please enter a Product name';
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // Text forms has validated.
      // Every of the data in the form are valid at this point
      form.save();
      setState(() {
        _isLoading = true;
      });
      addProductLine(
        _nameController.text.trim().toUpperCase(),
        _productCategoryController.text.trim().toUpperCase(),
        _subCategoryController.text.trim().toUpperCase(),
        _costPriceController.text.trim(),
        _sellingPriceController.text.trim(),
        model.trim(),
        discount.trim(),
        expiry.trim(),
      );
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

  void clearAllFields() {
    _formKey.currentState.reset();
  }
}
