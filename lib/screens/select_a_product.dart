import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaku/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'add_stock.dart';

class ProductsListToSelect extends StatefulWidget {
  bool loaded = false;
  List list;

  ProductsListToSelect();

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsListToSelect> {
  @override
  void initState() {
    super.initState();
  //  getProducts();
  }

  Future getProducts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = await sharedPreferences.get("token");

    var response = await http.get(Constants.domain + "getProducts", headers: {
      'Authorization': 'Bearer $token',
    });
    print('Status Code = ' + response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        print('success: ' + response.body);
        Map<String, dynamic> products = json.decode(response.body);

        widget.list = products['data']['products'];

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
          title: const Text('Select a product'),
        ),
        body: FutureBuilder(
          future: getProducts(),
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
                          //Navigate
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => add_stock(
                              product_no: widget.list[index]['id'].toString(),
                              cost_price: widget.list[index]["cost_price"],
                              selling_price: widget.list[index]
                                  ['selling_price'],
                            ),
                          ));
                        },
                        trailing: Icon(
                          Icons.navigate_next,
                        ),
                        leading: Icon(Icons.grade),
                        title: Text(widget.list[index]['name']),
                        subtitle: Text("Category:  " +
                            widget.list[index]['product_category']['name']),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
