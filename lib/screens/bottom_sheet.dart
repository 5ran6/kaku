import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'approval.dart';
import 'make_sales.dart';

class bottomSheet {
  void settingModalBottomSheet(context) {
    TextEditingController _customersName = new TextEditingController();
    TextEditingController _customersEmail = new TextEditingController();
    TextEditingController _customersPhone = new TextEditingController();

    final focusNode = FocusNode();
    final focusNodePhone = FocusNode();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: new Wrap(
                children: <Widget>[
                   Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _customersName,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusNode);
                      },
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autofocus: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Customer name (Required)',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _customersEmail,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusNodePhone);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      focusNode:focusNode,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Email (Optional)',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: TextFormField(
                      controller: _customersPhone,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      focusNode:focusNodePhone,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Phone (Optional)',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {
                        String email;
                        _customersEmail.text == null ? email= " ": email = _customersEmail.text;
                        String phone;
                        _customersPhone.text == null ? phone = " ": phone = _customersPhone.text;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SalesQRCode(_customersName.text, email, phone)));
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
