import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class bottomSheetDaily {
  void settingModalBottomSheet(context, String passed) {
    DateTime selectedDate = DateTime.now();
    String date = passed;
// 2020-07-06
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020, 6),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
       // Toast.show(selectedDate.toLocal().toString(), context);
        date = "${selectedDate.toLocal()}".split(' ')[0];
        Navigator.pop(context);
        settingModalBottomSheet(context, date);
      }
    }

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          date,
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 10.0,
                        ),
                        RaisedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Select date'),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Submit",
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
