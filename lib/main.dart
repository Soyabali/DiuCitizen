import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'app/myapp.dart';
import 'firebase_options.dart';


void main() async {

   print("----Main Page---");
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  configLoading();
}

class MyHttpOverrides extends HttpOverrides {

  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void configLoading() {

  EasyLoading.instance

    ..displayDuration = const Duration(milliseconds: 2000)

    ..indicatorType = EasyLoadingIndicatorType.fadingCircle

    ..loadingStyle = EasyLoadingStyle.custom

    ..indicatorSize = 45.0

    ..radius = 10.0

    ..progressColor = Colors.white

    ..backgroundColor = Colors.black

    ..indicatorColor = Colors.white

    ..textColor = Colors.white

    ..maskColor = Colors.blue.withOpacity(0.5)

    ..userInteractions = false

    ..dismissOnTap = false;

}


