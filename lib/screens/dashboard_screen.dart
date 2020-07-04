import 'dart:io';
import 'package:kaku/screens/invoice.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaku/screens/approval.dart';
import 'package:kaku/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:kaku/models/user.dart';
import 'package:kaku/models/users.dart';
import 'package:kaku/widgets/bottom_sheet.dart';
import 'package:kaku/widgets/bottom_sheet_pickUp_by.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../constants.dart';
import '../custom_route.dart';
import '../transition_route_observer.dart';
import '../widgets/animated_numeric_text.dart';
import '../widgets/bottom_sheet_add.dart';
import '../widgets/fade_in.dart';
import '../widgets/round_button.dart';
import 'add_stock.dart';
import 'dashboard.dart';

class DashboardScreen extends StatefulWidget {
  User user;

  DashboardScreen({this.user});

  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  bool sign = false;
  double i = 0;

  Future<bool> _goToLogi(BuildContext context) async {
    try {
      sign = true;
//      await _auth.logout();
//      //  FirebaseUser user = result.user;
//      //create a document for the user in users collections
//      await DatabaseService(uid: widget.user.uid)
//          .updateUserData(widget.user.email, false);
      return Navigator.of(context)
          .pushReplacementNamed(LoginScreen.routeName)
          // we don't want to pop the screen, just replace it completely
          .then((_) => false);
    } catch (e) {
      print('Seems user is null: ' + e.toString());
      return null;
    }
  }

  final routeObserver = TransitionRouteObserver<PageRoute>();
  static const headerAniInterval =
      const Interval(.1, .3, curve: Curves.easeOut);
  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;

  void getPermission() async {
    Map<Permission, PermissionState> permission = await PermissionsPlugin
        .requestPermissions([
      Permission.ACCESS_FINE_LOCATION,
      Permission.ACCESS_COARSE_LOCATION,
      Permission.READ_PHONE_STATE
    ]);

    if( permission[Permission.CAMERA] != PermissionState.GRANTED) {
      try {
        permission = await PermissionsPlugin
            .requestPermissions([
          Permission.CAMERA,
          Permission.READ_EXTERNAL_STORAGE,
          Permission.WRITE_EXTERNAL_STORAGE
        ]);
      } on Exception {
        debugPrint("Error");
      }

      if( permission[Permission.CAMERA] == PermissionState.GRANTED)
        print("permissions granted");
      else
        permissionsDenied(context);

    }
else{
      print("Permission ok");
    }

  }

  void permissionsDenied(BuildContext context){
    showDialog(context: context, builder: (BuildContext _context) {
      return SimpleDialog(
        title: const Text("Permission denied"),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
            child: const Text(
              "These permission are needed for this application to run well",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54
              ),
            ),
          )
        ],
      );
    });
  }
  @override
  void initState() {
    super.initState();
    getPermission();

    i = 43;

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController,
      curve: headerAniInterval,
    ));
  }

//  var state = const AppLifecycleState(state);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {

    routeObserver.unsubscribe(this);
    _loadingController.dispose();
    if (!sign) exiting();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.primaryColorLight,
      icon: const Icon(FontAwesomeIcons.user),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.accentColor,
      onPressed: () => _goToLogi(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/images/ecorp.png',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
          ),
          HeroText(
            Constants.appName,
            tag: Constants.titleTag,
            viewState: ViewState.shrunk,
            style: LoginThemeHelper.loginTextStyle,
          ),
          SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        child: menuBtn,
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
      ),
      actions: <Widget>[
        FadeIn(
          child: signOutBtn,
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.accentColor).first;
    final linearGradient = LinearGradient(colors: [
      primaryColor.shade800,
      primaryColor.shade200,
    ]).createShader(Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '',
                  style: theme.textTheme.display2.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 5),
                AnimatedNumericText(
                  initialValue: 0,
                  targetValue: i,
                  //TODO: number of online drivers gotten from firebase
                  curve: Interval(0, 1, curve: Curves.easeOut),
                  controller: _loadingController,
                  style: theme.textTheme.display3.copyWith(
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
              ],
            ),
            Text('Items Sold Today',
                style: TextStyle(color: Colors.green, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {Widget icon, String label, Interval interval, Function onPressed}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: () {
        onPressed();
      },
    );
  }

  void printer() {
    print('HII');
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 22.0,
        vertical: 20,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: Icon(Icons.person_add),
          label: 'Employee', //add employee by asking for password first
          interval: Interval(0, aniInterval),
          onPressed: () => {bottomSheetAdd().settingModalBottomSheet(context)},
        ),
        _buildButton(
          icon: Container(
            // fix icon is not centered like others for some reasons
            padding: const EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.assignment_turned_in,
            ),
          ),
          label: 'Approval', //approve payment (using barcode)
          interval: Interval(step, aniInterval + step),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => approval(),
          )),
        ),
        _buildButton(
          icon: Icon(
            Icons.playlist_add,
          ),
          label: 'Add Stock', //add stock
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => add_stock(),
              )),
        ),
        _buildButton(
          icon: Icon(Icons.store),
          label: "Vendor", //
          interval: Interval(0, aniInterval),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Vendor(),
          )),
        ),
        _buildButton(
          icon: Icon(Icons.shopping_basket),
          label: 'Make a Sale', //make a sale
          interval: Interval(step, aniInterval + step),
          onPressed: () => {},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.history),
          label: 'Reports', //sales history per day
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () => Navigator.of(context).push(FadePageRoute(
            builder: (context) => approval(),
          )),
        ),
        _buildButton(
          icon: Icon(Icons.receipt, size: 20),
          label: 'Invoices', //to reprint invoices by transaction ID
          interval: Interval(0, aniInterval),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Vendor(),
          )),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.info, size: 20),
          label: 'About', //about
          interval: Interval(step, aniInterval + step),
          onPressed: () => {
            showDialog(
                context: context,
                builder: (_) => AssetGiffyDialog(
                      key: Key("Asset"),
                      image: Image.asset(
                        'assets/about.gif',
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        'About KAKU',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      entryAnimation: EntryAnimation.BOTTOM_RIGHT,
                      description: Text(
                        'KAKU is a user friendly application for store vendors and their employees to automate sales, reporting and management!',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      onOkButtonPressed: () {
                        Navigator.pop(context);
                      },
                    ))
          },
        ),
        _buildButton(
          icon: Icon(Icons.exit_to_app, size: 20),
          label: 'Exit', //exit
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () => {exiting()},
        ),
      ],
    );
  }

  Widget approval() {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            image: DecorationImage(
              image: AssetImage("assets/scan.jpg"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          backgroundColor: Colors.orange,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QRScan(),
          )),
        ),
      ),
    );

     }

  Widget drivers() {
//    return StreamProvider<List<Drivers>>.value(
//      initialData: [],
//      value: DatabaseService().manage_drivers,
//      child: new DriversList(widget.user),
//    );
  }

  void exiting() async {
    showAlertDialog(context);
  }

  void checkPassword(String password) async {
    //start Rolling
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gottenPassword = await prefs.get("password");
    if (password == gottenPassword) {
      //proceed

    } else {
      Toast.show("Password mismatch", context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        exit(0);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Exiting?"),
      content: Text("Are you sure you want to exit?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _launchURLabout() async {
    const url = 'https://shopdeliverknysna.myshopify.com/pages/about';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildDebugButtons() {
    const textStyle = TextStyle(fontSize: 12, color: Colors.white);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Colors.red,
            child: Text('loading', style: textStyle),
            onPressed: () => _loadingController.value == 0
                ? _loadingController.forward()
                : _loadingController.reverse(),
          ),
        ],
      ),
    );
  }

//  Widget showPrompt(BuildContext context) {
//    showDialog(
//        context: context,
//        builder: (_) => AssetGiffyDialog(
//              onlyOkButton: true,
//              image: Image.asset('assets/images/broadcast.gif'),
//              title: Text(
//                'Broadcast to drivers',
//                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
//              ),
//              description: Text(
//                'Do you want a new delivery request to be broadcasted to all drivers online?',
//                textAlign: TextAlign.center,
//                style: TextStyle(),
//              ),
//              entryAnimation: EntryAnimation.DEFAULT,
//              onOkButtonPressed: () {
//                //TODO: Make a broadcast
//              },
//            ));
//  }

  @override
  Widget build(BuildContext context) {
    //  final users = Provider.of<List<Users>>(context);
    final theme = Theme.of(context);

    // i = i - 1;
//    users.forEach((user) {
//      print(user.online);
//      if (user.online == true && user.role == 'driver') {
//        i++;
//      }
//    });

    //    if (i < 0) {
//      i = 0;
//    }

//    j = i.round();
    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Dashboard(_widget(theme), theme, _buildHeader(theme),
              _buildDashboardGrid()),
        ),
      ),
    );
  }

//  return WillPopScope(
//      onWillPop: () => _goToLogin(context),
//      child: SafeArea(
//        child: StreamProvider<List<Users>>.value(
//          value: DatabaseService().user,
//          child: Scaffold(
//            appBar: _buildAppBar(theme),
//            body: Dashboard(_widget(theme), theme, _buildHeader(theme),
//                _buildDashboardGrid()),
//          ),
//        ),
//      ),
//    );
//  }

  Widget _widget(ThemeData theme) {
    Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.primaryColor.withOpacity(.1),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 40),
              Expanded(
                flex: 2,
                child: _buildHeader(theme),
              ),
              Expanded(
                flex: 8,
                child: ShaderMask(
                  // blendMode: BlendMode.srcOver,
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.clamp,
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
                  child: _buildDashboardGrid(),
                ),
              ),
            ],
          ),
          if (!kReleaseMode) _buildDebugButtons(),
        ],
      ),
    );
  }
}
