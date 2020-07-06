import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bottomSheetWeekly {
  void settingModalBottomSheet(context) {
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
                      onFieldSubmitted: (v) {
                        //FocusScope.of(context).requestFocus(FocusNode());
                        //TODO: send request to server
                      },
                      textInputAction: TextInputAction.send,
                      autofocus: true,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Enter Week number',
                          hintText: "E.g: 4",
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Generate",
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
