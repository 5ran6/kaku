import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class bottomSheet {
  settingModalBottomSheet(context) {
    TextEditingController _code = new TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: TextField(
                      controller: _code,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        post(context, _code.text.trim());
                      },
                      autofocus: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Add a brief destination address',
                          labelStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // ScalingText('Loading...'),
                        FlatButton(
                          onPressed: () => post(context, _code.text.trim()),
                          child: Text(
                            "POST",
                          ),
                          textColor: Colors.white,
                          focusNode: FocusNode(),
                          color: Colors.indigoAccent,
                          splashColor: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  dynamic post(BuildContext context, String text) async {
    if (text.toString().length >= 3) {
      bool done = false;
      //Validated
      Toast.show("Sending.....", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      //TODO: server update call

      DateTime now = new DateTime.now();
      String dateTime = DateFormat('EEEE').format(now) + ', ' + now.day.toString() + '-' + now.month.toString() + '-' + now.year.toString() + ' @ ' + now.hour.toString() + ':' + now.minute.toString() + ':' + now.second.toString();
//      await DatabaseService()
//          .updateOrder(dateTime, "Everyone", text, false, 0);
      done = true;
      //after it is done
      if (done) {
        Toast.show("SENT TO ALL ONLINE DRIVERS", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else {
        Toast.show("Network issues! Try again", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      //toast
      Toast.show("Invalid address", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
