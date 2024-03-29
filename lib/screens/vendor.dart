import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/screens/add_product_line.dart';
import 'package:kaku/screens/add_product_line_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage_employee.dart';
import 'manage_stock_menu.dart';

class Vendor extends StatelessWidget {
  String token, name;

  Vendor({this.name});

  void _goto(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.get("token").toString();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductsList(),
    ));
  }

  void _gotoStock(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.get("token").toString();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StockManageList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[50],
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(
                            "https://icon-library.com/images/store-icon-png/store-icon-png-20.jpg"),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    VerticalDivider(
                      thickness: 2,
                      width: 20,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "(Store Admin)",
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 5),
                child: Text(
                  "Welcome to Vendor's corner where the administration of the store happens",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                thickness: 3,
                height: 20,
                color: Colors.blue,
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 10,
                      height: MediaQuery.of(context).size.width / 2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            _goto(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.add_shopping_cart,
                                  size: 30,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Product Line',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 10,
                      height: MediaQuery.of(context).size.width / 2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            _gotoStock(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.store,
                                  size: 30,
                                  color: Colors.red[300],
                                ),
                                Text(
                                  'Manage Stock',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 10,
                      height: MediaQuery.of(context).size.width / 2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ManageEmployee(),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.person_outline,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Manage Employee',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 10,
                      height: MediaQuery.of(context).size.width / 2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.chat,
                                  size: 30,
                                  color: Colors.blue[300],
                                ),
                                Text(
                                  'Send a message',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
