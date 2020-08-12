import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/constants.dart';
import 'package:kaku/screens/select_a_product.dart';
import 'package:kaku/screens/update_stock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'add_stock.dart';

class StockManageList extends StatefulWidget {
  String token;
  bool loaded = false;
  List list;

  StockManageList();

  @override
  _StockManageListState createState() => _StockManageListState();
}

class _StockManageListState extends State<StockManageList> {
  @override
  void initState() {
    super.initState();
    getStocks();
  }

  Future getStocks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");

    var response = await http.get(Constants.domain + "getStocks", headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        print('success: ' + response.body);
        Map<String, dynamic> stocks = json.decode(response.body);
        widget.list = stocks['data']['stocks'];
//        setState(() {
//          widget.loaded = true;
//        });
        return widget.list;
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
        Toast.show("Error while fetching data", context);
        setState(() {
          widget.loaded = false;
        });
      }
    } else {
      try {
        setState(() {
          widget.loaded = false;
        });
        Toast.show("Error while fetching data", context);
        print('failed: ' + response.body);
      } on FormatException catch (exception) {
        print('Exception: ' + exception.toString());
        print('Error' + response.body);
      }
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: const Text('List of Added Stocks'),
        ),
        body: Container(
          child: FutureBuilder(
            future: getStocks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(10.0, 6, 10, 0),
                        child: ListTile(
                          onTap: () {
                            //Do go to Update Stock
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => update_stock(stock_id: widget.list[index]['id'].toString(), cost_price: widget.list[index]['cost_price'], selling_price: widget.list[index]['selling_price'],
                                description: widget.list[index]['description'],discount: widget.list[index]['discount'],quantity: widget.list[index]['current_quantity'],),
                            ));

                          },
                          trailing: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              border: Border.all(width: .2),
                              shape: BoxShape.circle,
                              // You can use like this way or like the below line
                              //borderRadius: new BorderRadius.circular(30.0),
                              color: int.parse(widget.list[index]['current_quantity']) > 10 ? Colors.green : Colors.redAccent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(widget.list[index]['current_quantity']),
                              ],
                            ),
                          ),
                          leading: Icon(Icons.store),
                          title: Text(widget.list[index]['product']['name']),
                          subtitle: Text("Cost Price:  ₦" +
                              widget.list[index]['cost_price'] +
                              " \nSelling Price: ₦" +
                              widget.list[index]['selling_price'] +
                              " \nAdded on: " +
                              widget.list[index]['created_at'].split("T")[0]),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {
            //Navigate
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductsListToSelect(),
            ));
          },
        ),
      ),
    );
  }
}
