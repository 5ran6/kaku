import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaku/models/stocks.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:qrcode/qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../constants.dart';
import 'invoice_summary.dart';

//void main() => runApp(QRScan());
class SalesQRCode extends StatelessWidget {
  String name;
  String email;
  String phone;

  SalesQRCode(@required this.name, this.email, this.phone);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new QRScan(name, email, phone),
    );
  }
}

class QRScan extends StatefulWidget {
  String customer_name;
  String customer_email;
  String customer_phone;

  QRScan(@required this.customer_name, this.customer_email, this.customer_phone);

  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> with TickerProviderStateMixin {
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;
  final _formKey = new GlobalKey<FormState>();
  List items = [];
  List items_names = [];
  List prices = [];
  bool _isTorchOn = false, captured = false;
  double _currentQuantity = 1.0;
  String _captureText = '';

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      print('onCapture----$data');

      setState(() {
        _captureText = data;
        captured = true;
        getStock(_captureText.trim());
        print('I just captured----$data');
        //call approval API here
      });
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        isSuccess = true;
        final Map parsed = json.decode(response.body)['data']['product_stock'];
//        print('created_at: ' + parsed['created_at']);

        // dialogue
        _showDialog1(barcode, parsed['product']['name'],
            parsed['current_quantity'], parsed['selling_price']);
      } on FormatException catch (exception) {
        isSuccess = false;
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        setState(() {
          captured = false;
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
          captured = false;
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
          captured = false;
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

//  void _showDialog(String barcode, String name, String quantity) {
//    // flutter defined function
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Out of $quantity in Stock"),
//          content: new Text("Alert Dialog body"),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            new FlatButton(
//              child: new Text("Close"),
//              onPressed: () {
//                Toast.show("Cancelled!", context);
//                Navigator.of(context).pop();
//              },
//            ),
//            new FlatButton(
//              child: new Text("Add"),
//              onPressed: () {
//            //    addInvoice(barcode, quantity, name);
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  void _showDialog1(
      String barcode, String name, String quantity, String price) {
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
        Navigator.pop(context);
        addInvoice(barcode, quantity, name, price);


//        setState(() => _currentQuantity = value);
      }
    });
  }

  void addInvoice(
      String stock_id, String quantity, String name, String price) async {
    //bottomSheet

    //add to list
    items.add({'stock_id': stock_id, 'quantity': quantity});
    items_names.add(name);
    prices.add(price);
    print('Item size: ' + items.length.toString());
    print('Items: ' + items.toString());
    print('Names: ' + items_names.toString());
    print('Prices: ' + prices.toString());

    //setState
    setState(() {
      captured = false;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Added to invoice!",
          style: TextStyle(color: Colors.green),
        ),
      ));
    });
  }

  void createInvoice(List items, List names, List prices) async {
    //call invoice summary UI.

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => InvoiceSummary(
          widget.customer_name, items, items_names, prices, widget.customer_email, widget.customer_phone),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Scan QRCode on Invoice'),
      ),
      body: captured
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.done),
                backgroundColor: Colors.blue,
                onPressed: () => createInvoice(items, items_names, prices),
              ),
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                    child: QRCaptureView(
                      controller: _captureController,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildToolBar(),
                  ),
                  Container(
                    child: captured ? Text('$_captureText') : Text(""),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildToolBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: Colors.orange)),
          onPressed: () {
            _captureController.pause();
          },
          child: Text('Pause'),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: Colors.orange)),
          onPressed: () {
            if (_isTorchOn) {
              _captureController.torchMode = CaptureTorchMode.off;
            } else {
              _captureController.torchMode = CaptureTorchMode.on;
            }
            _isTorchOn = !_isTorchOn;
          },
          child: Text('Torch'),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
              side: BorderSide(color: Colors.orange)),
          onPressed: () {
            _captureController.resume();
          },
          child: Text('Resume'),
        ),
      ],
    );
  }
}
