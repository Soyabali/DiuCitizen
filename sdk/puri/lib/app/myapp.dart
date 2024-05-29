import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../resources/routes_managements.dart';
import '../resources/theme_manager.dart';


class MyApp extends StatefulWidget {
  MyApp._internal(); // private named constructor
  int appState = 0;
  static final MyApp instance =
  MyApp._internal(); // single instance -- singleton
  factory MyApp() => instance; // factory for the class instance
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
 // AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  void didChangeDependencies() {
   // _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}

