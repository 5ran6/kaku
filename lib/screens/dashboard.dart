import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaku/models/users.dart';

import '../models/users.dart';
import '../transition_route_observer.dart';

class Dashboard extends StatefulWidget {
  Widget home;
  Widget _buildDashboardGrid;
  ThemeData theme;
  Widget _buildHeader;

  Dashboard(this.home, this.theme, this._buildHeader, this._buildDashboardGrid);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with TickerProviderStateMixin, TransitionRouteAware {
  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<List<Users>>(context);

//    userData.forEach((user){
//      print(user.online);
//      print(user.email);
//      print(user.uid);
//    });
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: widget.theme.primaryColor.withOpacity(.1),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 40),
              Expanded(
                flex: 2,
                child: widget._buildHeader, //theme
              ),
              Expanded(
                flex: 8,
                child: ShaderMask(
                  // blendMode: BlendMode.srcOver,
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.mirror,
                      colors: <Color>[
                        Colors.deepPurpleAccent.shade100,
                        Colors.deepPurple.shade100,
                        Colors.deepPurple.shade100,
                        Colors.deepPurple.shade100,
                        // Colors.red,
                        // Colors.yellow,
                      ],
                    ).createShader(bounds);
                  },
                  child: widget._buildDashboardGrid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
