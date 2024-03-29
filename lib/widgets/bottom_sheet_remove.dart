import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class bottomSheetRemove {
  settingModalBottomSheet(context) {
    TextEditingController _code = new TextEditingController();
    TextEditingController _name = new TextEditingController();
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
                    padding: MediaQuery
                        .of(context)
                        .viewInsets,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _code,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (value) {},
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Driver's Email",
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
                              post(context, _code.text.trim()),
                          child: Text(
                            "REMOVE",
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
    bool done = false;
    bool checked = false;
    if (text.isEmpty) {
      // The form is empty
      Toast.show("Enter email address", context,
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
      Toast.show("Removing.....", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//when done, close bottomSheet

      //check if email exists for this store
//      final snapShot = await Firestore.instance
//          .collection('drivers')
//          .document(text)
//          .get();

//      if (snapShot.exists) {
//        // Document with id == docId doesn't exist.
//        //if found
////        dynamic result = await DatabaseService(uid: '')
////            .removeDriverData( text.trim(), false);
////
////        print('REMOVED Status: ' + result.toString());
////        checked = true;
////        if (result.toString() == 'null') {
////          done = true;
////        }
//      } else {
//        checked = true;
//      }


      if (done) {
        Toast.show("REMOVED SUCCESSFULLY", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else {
        if (!checked) {
          Toast.show("Network issues! Try again", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          checked = false;
        }else{
          Toast.show("This driver is not registered yet", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        }
      }
    } else {
      Toast.show("Enter a valid address", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
