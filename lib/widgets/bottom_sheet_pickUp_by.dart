import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:kaku/services/database.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
class bottomSheetPickUpBy {
  settingModalBottomSheet(context) {
    FocusNode focusNode = new FocusNode();
    TextEditingController _code = new TextEditingController();
    TextEditingController _address = new TextEditingController();
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
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _code,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (value) {
                            focusNode;
                          },
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Driver's Email",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextField(
                          controller: _address,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          focusNode: focusNode,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            post(context, _code.text.trim(), _address.text);
                          },
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // ScalingText('Loading...'),
                        FlatButton(
                          onPressed: () =>
                              post(context, _code.text.trim(), _address.text),
                          child: Text(
                            "SEND",
                          ),
                          textColor: Colors.white,
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

  dynamic post(BuildContext context, String text, String address) async {
    bool done = false; //a sent to server flag
    if (text.isEmpty) {
      // The form is empty
      Toast.show("Enter email", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      // return "Enter email address";
    }
    if (address.isEmpty) {
      // The form is empty
      Toast.show("Enter a valid address", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      // return "Enter email address";
    }

    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(text)) {
      // So, the email is valid
      Toast.show("Adding.....", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      //if driver belongs to store
//      final snapShot =
//          await Firestore.instance.collection('drivers').document(text.trim()).get();

//      if (!snapShot.exists ||
//          snapShot == null ||
//          snapShot.data['active'] == false) {
//        Toast.show("Driver does not exist! Check the email", context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      } else {
//        //driver exists for this store
//        // send to driver
//        DateTime now = new DateTime.now();
//        String dateTime = DateFormat('EEEE').format(now) + ', ' + now.day.toString() + '-' + now.month.toString() + '-' + now.year.toString() + ' @ ' + now.hour.toString() + ':' + now.minute.toString() + ':' + now.second.toString();
////        await DatabaseService()
////            .updateOrder(dateTime, text, address, false, 0);
//        done = true;
//      }

      //when done, close bottomSheet

      if (done) {
        Toast.show("ADDED SUCCESSFULLY", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      }
      //     return null;

    } else {
      Toast.show("Enter a valid address", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    // The pattern of the email didn't match the regex above.

    //  return 'Enter a valid Email address';
  }
}
