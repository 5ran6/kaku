import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'approval.dart';
import 'make_sales.dart';

class bottomSheet {
  void settingModalBottomSheet(context) {
    TextEditingController _customersName = new TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: TextFormField(
                      controller: _customersName,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Customer name (Required)',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SalesQRCode(_customersName.text)));
                      },
                      child: Text(
                        "Proceed",
                      ),
                      textColor: Colors.white,
                      color: Colors.indigoAccent,
                      splashColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
