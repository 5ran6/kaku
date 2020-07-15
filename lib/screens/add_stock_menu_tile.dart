import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaku/models/stock.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'add_stock.dart';

class ManageStockTile extends StatelessWidget {
  final Stock stock;
  final String token;

  ManageStockTile({this.stock, this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6, 20, 0),
        child: ListTile(
          onTap: () {
            //prompt if done
//TODO: get single stock by (product_id) first

            //Navigate
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => add_stock(
                  product_no: null,
                  cost_price: null,
                  selling_price: null,
                  quantity: null,
                  description: null,
                  discount: null),
            ));
          },
          trailing: Icon(
            int.parse(stock.data.stocks_count) >= 10
                ? Icons.playlist_add
                : Icons.warning,
          ),
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: int.parse(stock.data.stocks_count) >= 10
                ? Colors.green[200]
                : Colors.red[200],
          ),
          title: Text(stock.data.stocks + " " + stock.data.stocks),
          subtitle: Text(stock.data.stocks[2] + " remaining" ),
        ),
      ),
    );
  }
}
