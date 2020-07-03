import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'transition_route_observer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirst = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs){
      var isShowed =prefs.getBool("isIntroShowed");
      if(isShowed!=null && isShowed)
      {
        //navigate to main page
     isFirst = false;
      }
      else{
        //navigate to intro page
        isFirst = true;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.orange,
        cursorColor: Colors.orange,
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.bold,
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
          button: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          display4: TextStyle(fontFamily: 'Quicksand'),
          display3: TextStyle(fontFamily: 'Quicksand'),
          display1: TextStyle(fontFamily: 'Quicksand'),
          headline: TextStyle(fontFamily: 'NotoSans'),
          title: TextStyle(fontFamily: 'NotoSans'),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body2: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
          subtitle: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: Builder(
          builder: (context) =>
          isFirst ? onboarding(context) : LoginScreen()),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
         LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
      },
    );
  }

  void doneFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setBool("isIntroShowed", true);
  }


  Widget onboarding(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ).then((value) => doneFirstTime()),
        onSkipButtonPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ).then((value) => doneFirstTime()),
//      onDoneButtonPressed: () => Navigator.of(context)
//          .pushReplacementNamed('/login_screen')
//          .then((value) => doneFirstTime()),
//      onSkipButtonPressed: () => Navigator.of(context)
//          .pushReplacementNamed('/login_screen')
//          .then((value) => doneFirstTime()),
      ),
    );
  }

  final pageList = [
    PageModel(
        color: Colors.deepOrangeAccent,
        heroAssetPath: 'assets/img_wizard_1.png',
        title: Text('Hotels',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text('All hotels and hostels are sorted by hospitality rating',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconAssetPath: 'assets/img_wizard_1.png'),
    PageModel(
        color: Colors.cyan,
        heroAssetPath: 'assets/img_wizard_2.png',
        title: Text('Banks',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(
            'We carefully verify all banks before adding them into the app',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconAssetPath: 'assets/img_wizard_4.png'),
    PageModel(
      color: Colors.greenAccent,
      heroAssetPath: 'assets/img_wizard_4.png',
      title: Text('Store',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('All local stores are categorized for your convenience',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      iconAssetPath: 'assets/img_wizard_3.png',
    ),
  ];
}
