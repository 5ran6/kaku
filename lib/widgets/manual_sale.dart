import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kaku/constants.dart';
import 'package:kaku/models/stock_list.dart';
import 'package:kaku/screens/invoice_summary.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class Manual_Sale extends StatefulWidget {
  String name;
  String phone;
  String email;

  Manual_Sale(this.name, this.email, this.phone);

  @override
  _Manual_SaleState createState() => _Manual_SaleState();
}

class _Manual_SaleState extends State<Manual_Sale> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Make Sale',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Manual_Sales(
        title: 'Select an Item',
        name: widget.name,
        phone: widget.phone,
        email: widget.email,
      ),
    );
  }
}

// ignore: must_be_immutable
class Manual_Sales extends StatefulWidget {
  String title;
  String name;
  String phone;
  String email;

  Manual_Sales(
      {@required this.title, @required this.name, this.phone, this.email});

  @override
  _Manual_SalesState createState() => _Manual_SalesState();
}

class _Manual_SalesState extends State<Manual_Sales> {
  final itemHeight = 50.0;

  bool isLoaded = false;
  List<items> itemsList = [];
  List items_names = [];
  List prices = [];
  double _currentQuantity = 1.0;

  List items_list;

  Widget itemWidget(BuildContext context, int index) {
    return Text(items_list[index]['name']);
  }

  Widget titleWidget(BuildContext context) {
    return Text(
      "Items List",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24.0),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getProducts in stock
    getProducts();
  }

  void getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    print('token: ' + token);
    bool isSuccess = false;
    List products = [];
    var jsonData;
    var response = await http.get(Constants.domain + "getProducts", headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    print(response.body.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        isSuccess = true;

        Map<String, dynamic> products = json.decode(response.body);
        items_list = products['data']['products'];

        //items_list= List<Product>.from(parsed.map((i) => Product.fromJson(i))).toList();

//         items_list = (json.decode(response.body)['data']['products']).map((i) =>
//            Product.fromJson(i));
        print(items_list);
//        Product product = new Product.fromJson(jsonResponse);

        setState(() {
          isLoaded = true;
        });
        // populate on the list

      } on FormatException catch (exception) {
        isSuccess = false;
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        setState(() {
          isLoaded = true;
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "Something went wrong. Try again",
              style: TextStyle(color: Colors.redAccent),
            ),
          ));
        });
      }
    } else {
      try {
        isSuccess = false;
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
        setState(() {
          isLoaded = true;
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "Something went wrong. Try again",
              style: TextStyle(color: Colors.redAccent),
            ),
          ));
        });
      } on FormatException catch (exception) {
        isSuccess = false;
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        setState(() {
          isLoaded = true;
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "Something went wrong. Try again",
              style: TextStyle(color: Colors.redAccent),
            ),
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: isLoaded
            ? Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: items_list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Card(
                          margin: EdgeInsets.fromLTRB(2.0, 2, 2, 0),
                          child: ListTile(
                            onTap: () {
                              //actions to select quantity
                              setState(() {
                                isLoaded = false;
                                getStock(
                                    items_list[index]["id"].toString());
                              });
                            },
                            trailing: Icon(Icons.add_shopping_cart),
                            title: Text(items_list[index]['name']),
                            subtitle: Text(items_list[index]
                            ['product_category']['name']),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.done),
            backgroundColor: Colors.blue,
            onPressed: () => itemsList.length > 0
                ? createInvoice(itemsList, items_names, prices)
                : Toast.show(
                "You have not added any item to the cart", context),
          ),
        )
            : Scaffold(body: Center(child: CircularProgressIndicator())));
  }

  void getStock(String barcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    print('token: ' + token);
    bool isSuccess = false;
    Map data = {'stock_id': barcode};
    List stock = [];
    var jsonData;
    var response =
    await http.post(Constants.domain + "scanBarcode", body: data, headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    print(response.body.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        isSuccess = true;
        final Map<String, dynamic> parsed =
        json.decode(response.body)['data']['product_stock'];
        // print('created_at: ' + parsed['created_at']);

        // dialogue
        if (int.parse(parsed['current_quantity']) > 0) {
          _showDialog1(barcode, parsed['product']['name'],
              parsed['current_quantity'], parsed['selling_price']);
        } else {
          print(response.body.toString());
          setState(() {
            isLoaded = true;
            Toast.show("Sorry, this product is out of stock", context,
                textColor: Colors.white, duration: 5);

//            Scaffold.of(context).showSnackBar(SnackBar(
//              content: Text(
//                "Sorry, this product is out of stock",
//                style: TextStyle(color: Colors.redAccent),
//              ),
//            ));
          });
//          Toast.show("Sorry, this product is out of stock", context);
        }
      } on FormatException catch (exception) {
        isSuccess = false;
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        setState(() {
          isLoaded = true;
          Toast.show("Something went wrong. Try again", context,
              textColor: Colors.redAccent);
//          Scaffold.of(context).showSnackBar(SnackBar(
//            content: Text(
//              "Something went wrong. Try again",
//              style: TextStyle(color: Colors.redAccent),
//            ),
//          ));
        });
      }
    } else {
      try {
        isSuccess = false;
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
        setState(() {
          isLoaded = true;
          Toast.show("Something went wrong. Try again", context,
              textColor: Colors.redAccent);
//          Scaffold.of(context).showSnackBar(SnackBar(
//            content: Text(
//              "Something went wrong. Try again",
//              style: TextStyle(color: Colors.redAccent),
//            ),
//          ));
        });
      } on FormatException catch (exception) {
        isSuccess = false;
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        setState(() {
          isLoaded = true;
          Toast.show("Something went wrong. Try again", context,
              textColor: Colors.redAccent);

//          Scaffold.of(context).showSnackBar(SnackBar(
//            content: Text(
//              "Something went wrong. Try again",
//              style: TextStyle(color: Colors.redAccent),
//            ),
//          ));
        });
      }
    }
  }

  void _showDialog1(
      String barcode, String name, String quantity, String price) {
    try {
      showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return new NumberPickerDialog.integer(
              minValue: 1,
              maxValue: int.parse(quantity),
              title: new Text("Select the quantity"),
              initialIntegerValue: 1,
            );
          }).then((int value) {
        if (value != null) {
          addInvoice(barcode, quantity, name, price);

//        setState(() => _currentQuantity = value);
        }
      });
    } catch (e) {
      Toast.show("Sorry! Product is not in stock", context);
    }
  }

  void addInvoice(
      String stock_id, String quantity, String name, String price) async {
    //bottomSheet

    //add to list
    itemsList.add(items(stock_id, int.parse(quantity)));
    items_names.add(name);
    prices.add(price);
    print('Item size: ' + itemsList.length.toString());
    print('Items: ' + itemsList.toString());
    print('Names: ' + items_names.toString());
    print('Prices: ' + prices.toString());

    //setState
    Toast.show("Added to invoice", context, textColor: Colors.white, duration: 5);
//    Navigator.pop(context);

    setState(() {
      isLoaded = true;
////      Scaffold.of(context).showSnackBar(SnackBar(
////        content: Text(
////          "Added to invoice!",
////          style: TextStyle(color: Colors.green),
////        ),
////      ));
    });
  }

  void createInvoice(List<items> itemsList, List names, List prices) async {
    //call invoice summary UI.

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => InvoiceSummary(widget.name, itemsList, items_names,
          prices, widget.email, widget.phone),
    ));
  }
}
