import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/home/home_page.dart';
import 'ui/onboarding/onboarding_page.dart';
import 'util/constant.dart';
import 'util/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isNewUser = preferences.getBool(Constant.IS_NEW_USER) ?? true;

  final MyApp myApp = MyApp(
    initialRoute: isNewUser ? OnBoardingPage.TAG : HomePage.TAG,
  );
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme(),
      initialRoute: initialRoute,
      home: OnBoardingPage(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case OnBoardingPage.TAG:
            {
              return MaterialPageRoute(builder: (context) => OnBoardingPage());
            }
          case HomePage.TAG:
            {
              return MaterialPageRoute(builder: (context) => HomePage());
            }
        }
        return MaterialPageRoute(builder: (context) => OnBoardingPage());
      },
    );
  }
}
