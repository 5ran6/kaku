import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../constants.dart';

//void main() => runApp(QRScan());
class MyQRCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new QRScan(),
    );
  }
}

class QRScan extends StatefulWidget {
  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> with TickerProviderStateMixin {
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;
  final _formKey = new GlobalKey<FormState>();

  bool _isTorchOn = false, captured = false;

  String _captureText = '';

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      print('onCapture----$data');

      setState(() {
        _captureText = data;
        captured = true;
        addStock(_captureText.trim());
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

  void addStock(String barcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    print('token: ' + token);
    bool isSuccess = false;
    Map data = {'barcode': barcode};
    String stock = "";
    var jsonData;
    var response =
        await http.post(Constants.domain + "barcode", body: data, headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        isSuccess = true;
        jsonData = json.decode(response.body);
        print('success: ' + response.body);
        //parse json

        stock = jsonData['data']['product_stocks'].toString();
      } on FormatException catch (exception) {
        isSuccess = false;
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    } else {
      try {
        isSuccess = false;
        jsonData = json.decode(response.body);
        print('failed: ' + response.body);
      } on FormatException catch (exception) {
        isSuccess = false;
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    }
    setState(() {
      captured = false;

        isSuccess
            ? Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Success! Remaining $stock items",
                  style: TextStyle(color: Colors.green),
                ),
              ))
            : Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Failed! Try again",
                  style: TextStyle(color: Colors.orange),
                ),
              ));
    });
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 56),
                    child: AspectRatio(
                      aspectRatio: 264 / 258.0,
                      child: Stack(
                        alignment: _animation.value,
                        children: <Widget>[
                          //                        Image.asset('assets/images/scan_area_1.png')
                        ],
                      ),
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
