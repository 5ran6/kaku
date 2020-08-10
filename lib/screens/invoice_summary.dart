import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:kaku/constants.dart';
import 'package:kaku/models/stock_list.dart';
import 'package:kaku/models/stock_list.dart';
import 'package:kaku/models/stock_list.dart';
import 'package:kaku/screens/dashboard.dart';
import 'package:kaku/screens/dashboard_screen.dart';
import 'package:kaku/screens/login_screen.dart';
import 'package:kaku/widgets/animated_numeric_text.dart';
import 'package:kaku/widgets/fade_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaku/screens/bottom_sheet.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

final bSheet = bottomSheet();

class InvoiceSummary extends StatefulWidget {
  String name;
  List <items> itemsList = []; // goes inner top
  List items_names = []; // goes inner top
  List prices = []; // goes inner top
  String customer_email;
  String phone;

  InvoiceSummary(this.name, this.itemsList, this.items_names, this.prices,
      this.customer_email, this.phone);

  @override
  _InvoiceSummaryState createState() => _InvoiceSummaryState();
}

class _InvoiceSummaryState extends State<InvoiceSummary>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;

  static const headerAniInterval =
      const Interval(.1, .3, curve: Curves.easeOut);
  Animation<double> _headerScaleAnimation;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  bool _isVisible = false;
  double i;
  int total_amount = 0;

  @override
  initState() {
    // i = double.parse(widget.payment_count);
//    print(widget.payments[0].toString());

    widget.prices.forEach((price) {
      print('Price: $price');
      total_amount += int.parse(price);
    });

//    for (String price in widget.prices) {
//      total_amount += int.parse(price);
//    }

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
    _isVisible = !_isVisible;
  }

  Widget toggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          child: FloatingActionButton(
            backgroundColor: _buttonColor.value,
            onPressed: animate,
            tooltip: 'Toggle',
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animateIcon,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFrontWidget(int index) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 26.0,
                        backgroundImage: AssetImage('assets/images/ecorp.jpg'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    VerticalDivider(
                      thickness: 2,
                      width: 20,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.items_names[index],
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Price: " + widget.prices[index],
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "Quantity: " + widget.itemsList[index].quantity.toString(),
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  Widget _buildInnerTopWidget(int index) {
    return Container(
        color: Colors.blueGrey[100],
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                color: Colors.blueGrey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Date: ",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                color: Colors.blueGrey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Total Price: ",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₦ ",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                color: Colors.blueGrey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Sold by (ID):",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "",
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildInnerBottomWidget(int index) {
    return Builder(builder: (context) {
      return Container(
        color: Color(0xFFecf2f9),
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: FlatButton(
                onPressed: () {
                  SimpleFoldingCellState foldingCellState =
                      // ignore: deprecated_member_use
                      context.ancestorStateOfType(
                          // ignore: deprecated_member_use
                          TypeMatcher<SimpleFoldingCellState>());
                  foldingCellState?.toggleFold();
                },
                child: Text(
                  "Close",
                ),
                textColor: Colors.indigoAccent,
                color: Colors.white,
                splashColor: Colors.white.withOpacity(0.5),
              ),
            )
          ],
        ),
      );
    });
  }

  int notificationCounter = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.content_copy),
            highlightColor: Colors.white,
            onPressed: () {
              Toast.show("Phone number copied to clipboard", context);
              Clipboard.setData(ClipboardData(text: widget.phone));
            },
          ),
        ],
        title: Text(
            //widget.title
            'Invoice for ' + widget.name),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              // width: double.infinity,
              height: 120,
              color: Colors.deepOrange,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.itemsList.length.toString(),
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        "Item(s) to be sold\n",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "Total amount: ₦ " + total_amount.toString(),
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                color: Colors.deepOrange,
                child: ListView.builder(
                    itemCount: widget.items_names.length,
                    itemBuilder: (context, index) {
                      return SimpleFoldingCell(
                          frontWidget: _buildFrontWidget(index),
                          innerTopWidget: _buildInnerTopWidget(index),
                          innerBottomWidget: _buildInnerBottomWidget(index),
                          cellSize: Size(MediaQuery.of(context).size.width, 90),
                          padding: EdgeInsets.all(15),
                          animationDuration: Duration(milliseconds: 300),
                          borderRadius: 10,
                          onOpen: () => print('$index cell opened'),
                          onClose: () => print('$index cell closed'));
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () => _showDialog(' over the counter', 1),
                    color: Colors.blue,
                    splashColor: Colors.white.withOpacity(0.5),
                    minWidth: double.infinity,
                    height: 50,
                    child: Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => _showDialog(' Later', 2),
                    color: Colors.white30,
                    splashColor: Colors.blue.withOpacity(0.5),
                    minWidth: double.infinity,
                    height: 50,
                    child: Text(
                      "Pay Later",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(String name, int flag) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pay $name?"),
          content: new Text("Are you sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                if (flag == 1)  {
                  //pay cash
                  Toast.show("Processing ....", context);
                  createInvoice(widget.itemsList, widget.name,
                      widget.customer_email, widget.phone, 1);
                  //cash
              //    Toast.show("Transaction Completed", context);
//                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => DashboardScreen(),
                  ));
                }
                if (flag == 2) {
                  //pay later
                  Toast.show("Processing ....", context);

                   createInvoice(widget.itemsList, widget.name,
                      widget.customer_email, widget.phone, 2);
                }
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                //    addInvoice(barcode, quantity, name);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void createInvoice(List <items> items, String customer_name, String customer_email,
      String customer_phone, int flag) async {
    //createInvoice to get invoice_no and I will pass payment_method based on flag

    stockList cart = stockList(items);
    String list = jsonEncode(cart);
    Map data = {
      'customer_email': customer_email,
      'customer_phone': customer_phone,
      'customer_name': customer_name,
      'stockLists': list
    };
    print('Params: ' + data.toString());


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');
//    Toast.show(list.toString(), context);

    var jsonData;
    var response =
        await http.post(Constants.domain + "createInvoice", body: data, headers: {
      'Authorization': 'Bearer $token',
    });



    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print('success: ' + response.body);

      if (flag == 1) {
        String invoice_no = jsonData['data'];
//if pay now
        makePayment(invoice_no, "Cash", "Paid with Cash to KAKU rep!");
      }
      if (flag == 2) {
//if pay later
        //create Invoice routine
        Toast.show("QR Code Sent to your email successfully!", context,
            duration: Toast.LENGTH_LONG);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
      }
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
          Toast.show("$error", context);
        }
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        String error = "";
        error = 'Oops! Something went wrong.';
        Toast.show("$error", context);
      }
    }
  }

  void makePayment(
      String invoice_no, String payment_method, String note) async {

    Map data = {
      'invoice_no': invoice_no,
      'payment_method': payment_method,
      'note': note
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');

    var jsonData;
    var response =
    await http.post(Constants.domain + "makePayment", body: data, headers: {
      'Authorization': 'Bearer $token',
    });

    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      jsonData = json.decode(response.body);
      print('success: ' + response.body);
      Toast.show("Payment Approved!", context, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => DashboardScreen(),
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
