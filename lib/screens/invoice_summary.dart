import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:kaku/screens/dashboard.dart';
import 'package:kaku/screens/dashboard_screen.dart';
import 'package:kaku/screens/login_screen.dart';
import 'package:kaku/widgets/animated_numeric_text.dart';
import 'package:kaku/widgets/fade_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaku/screens/bottom_sheet.dart';
import 'package:toast/toast.dart';

final bSheet = bottomSheet();

class InvoiceSummary extends StatefulWidget {
  String name;
  List items = []; // goes inner top
  List items_names = []; // goes inner top
  List prices = []; // goes inner top

  InvoiceSummary(this.name, this.items, this.items_names, this.prices);

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
  int total_amount=0;

  @override
  initState() {
    // i = double.parse(widget.payment_count);
//    print(widget.payments[0].toString());


    for (String price in widget.prices) {
      total_amount += int.parse(price);
    }

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
                            widget.name[index],
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
                            "Quantity: " + widget.items[index]["quantity"],
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
                        "₦ " + widget.items[index]["amount_paid"],
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
                        widget.items[index]["vendor_id"],
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
          Icon(
            Icons.assignment,
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
              height: 100,
              color: Colors.deepOrange,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.items.length.toString(),
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
                        "Total amount: ₦ " +total_amount.toString(),
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                //height: MediaQuery.of(context).size.height - 150.0,
                color: Colors.deepOrange,
                child: ListView.builder(
                    itemCount: widget.items_names.length,
                    itemBuilder: (context, index) {
                      return SimpleFoldingCell(
                          frontWidget: _buildFrontWidget(index),
                          innerTopWidget: _buildInnerTopWidget(index),
                          innerBottomWidget: _buildInnerBottomWidget(index),
                          cellSize:
                          Size(MediaQuery
                              .of(context)
                              .size
                              .width, 125),
                          padding: EdgeInsets.all(15),
                          animationDuration: Duration(milliseconds: 300),
                          borderRadius: 10,
                          onOpen: () => print('$index cell opened'),
                          onClose: () => print('$index cell closed'));
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        children: <Widget>[
          FlatButton(
              onPressed: () => _showDialog(' with cash', 1),
              color: Colors.blue,
              child: Text('Pay Now (Cash)'),
              splashColor: Colors.white.withOpacity(0.5)),
          FlatButton(
              onPressed: () => _showDialog(' Later', 2),
              color: Colors.white,
              child: Text('Pay Later'),
              splashColor: Colors.blue.withOpacity(0.5)),
        ],
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
              onPressed: () {
                if (flag == 1) {
                  //cash
                  Toast.show("Transaction Completed", context);
//                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => DashboardScreen(),
                  ));
                }
                if (flag == 2) {
                  makePayment();
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

  void makePayment() async {}
}
