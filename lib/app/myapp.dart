import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:puri/provider/todo_provider.dart';

import '../presentation/resources/app_strings.dart';
import '../presentation/resources/noInternet.dart';
import '../presentation/resources/routes_managements.dart';
import '../presentation/resources/theme_manager.dart';


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

  bool activeConnection = false;
  String T = "";
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  void initState() {
    checkUserConnection();
    super.initState();
  }

  @override
  void didChangeDependencies() {
   // _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return activeConnection
        ? MultiProvider(
      providers: [
        ListenableProvider<TodoProvider>(create: (_) => TodoProvider()),
        // ChangeNotifierProvider<ParamsProvider>(
        //     create: (_) => ParamsProvider()),
        // ListenableProvider<PendingPhotoProvider>(
        //     create: (_) => PendingPhotoProvider()),
        // ListenableProvider<ReportUploadProvider>(
        //     create: (_) => ReportUploadProvider()),
        // ListenableProvider<PendingProvider>(
        //     create: (_) => PendingProvider()),
        // ListenableProvider<CompleteListProvider>(
        //     create: (_) => CompleteListProvider()),
        // ListenableProvider<ParamsProviderCom>(
        //     create: (_) => ParamsProviderCom()),
        // ListenableProvider<GetLecParametersProvider>(
        //     create: (_) => GetLecParametersProvider()),
        // ListenableProvider<ReportDownlodeProvider>(
        //     create: (_) => ReportDownlodeProvider()),
      ],//ReportDownlodeProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        initialRoute: Routes.splashRoute,
        onGenerateRoute: RouteGenerator.getRoute,
        builder: EasyLoading.init(),
      ),
    )
        : MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoInternet(),
      builder: EasyLoading.init(),
      // initialRoute: AppStrings.routeToSplash,
      // onGenerateRoute: generateRoute,
    );
  }
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   onGenerateRoute: RouteGenerator.getRoute,
    //   initialRoute: Routes.splashRoute,
    //   builder: EasyLoading.init(),
    //   theme: getApplicationTheme(),
    // );
  }


