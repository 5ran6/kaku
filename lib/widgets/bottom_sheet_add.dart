import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class bottomSheetAdd {
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
                    padding: MediaQuery.of(context).viewInsets,
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
                              labelText: "Employee's Email",
                              labelStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        TextField(
                          controller: _name,
                          keyboardType: TextInputType.visiblePassword,
                          textCapitalization: TextCapitalization.words,
                          focusNode: FocusNode(),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            post(context, _code.text.trim(), _name.text);
                          },
                          autofocus: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Employee's Password (min 6)",
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
                              post(context, _code.text.trim(), _name.text),
                          child: Text(
                            "ADD",
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

  dynamic post(BuildContext context, String text, String name) async {
    bool done = false;
    bool checked = false;
    if (text.isEmpty) {
      // The form is empty
      Toast.show("Enter email address", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

  //     return "Enter email address";
    }
    if (name.isEmpty || name.length < 6) {
      // The form is empty
      Toast.show("Enter a password of at least 6 characters", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

//       return "Enter a password of at least 6 characters";
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

    if (regExp.hasMatch(text) && name.isNotEmpty) {
      // So, the email is valid
      Toast.show("Adding.....", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//when done, close bottomSheet

      if (done) {
        Toast.show("ADDED SUCCESSFULLY", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else {
        if (!checked) {
          Toast.show("Network issues! Try again", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          checked = false;
        } else {
          Toast.show("This employee has been registered already", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    } else {
      Toast.show("Enter a valid credentials", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
