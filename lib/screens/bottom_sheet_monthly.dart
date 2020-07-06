import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class bottomSheetMonthly {
  void settingModalBottomSheet(context) {
    List monthList = [
      {'name': 'January', 'value': '1'},
      {'name': 'February', 'value': '2'},
      {'name': 'March', 'value': '3'},
      {'name': 'April', 'value': '4'},
      {'name': 'May', 'value': '5'},
      {'name': 'June', 'value': '6'},
      {'name': 'July', 'value': '7'},
      {'name': 'August', 'value': '8'},
      {'name': 'September', 'value': '9'},
      {'name': 'October', 'value': '10'},
      {'name': 'November', 'value': '11'},
      {'name': 'December', 'value': '12'}
    ];

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
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        hintText: 'Select a month',
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: TextStyle(color: Colors.yellow),
                      ),
                      value: "1",
                      items: monthList.map((map) {
                        return DropdownMenuItem(
                          child: Text(map['name']),
                          value: map['value'],
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        //TODO: send to server or do other stuff
                        //                      Toast.show(value, context);
                      },
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
