import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Vendor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                        NetworkImage("https://lh3.googleusercontent.com/proxy/dhcnA8JjS2SYP_SJvfag6uxDEJ5NZxx5nirByisAfJ2hafTM3FmzHaAooOUQWtNayZ6yrZCJhDRc4d_6EvNhk0BSK92SAiR0JQ"),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    VerticalDivider(
                      thickness: 2,
                      width: 20,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Abraham Udele ",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Address of Store or Something related ",
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "Others ",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,0,10,5),
                child: Text(
                  "Welcome to Vendor's corner where the administration of the store happens",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                thickness: 3,
                height: 20,
                color: Colors.blue,
                indent: 10,
                endIndent: 10,
              ),



              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery. of(context). size. width/2 - 10,
                      height: MediaQuery. of(context). size. width/2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.list,
                                  size: 30,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Product List',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery. of(context). size. width/2 - 10,
                      height: MediaQuery. of(context). size. width/2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.attach_money,
                                  size: 30,
                                  color: Colors.red[300],
                                ),
                                Text(
                                  'Cost Price',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery. of(context). size. width/2 - 10,
                      height: MediaQuery. of(context). size. width/2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  size: 30,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Selling Price',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery. of(context). size. width/2 - 10,
                      height: MediaQuery. of(context). size. width/2 - 10,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.percent,
                                  size: 20,
                                  color: Colors.red[300],
                                ),
                                Text(
                                  'Discounts',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,

                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
