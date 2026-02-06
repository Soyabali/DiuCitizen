
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/generalFunction.dart';
import '../../services/verifyAppVersion.dart';
import '../complaints/complaintHomePage.dart';
import '../login/loginScreen_2.dart';
import '../resources/app_text_style.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplaceState();
}

class _SplaceState extends State<SplashView> {

  bool activeConnection = false;
  String T = "";
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
          versionAliCall();
          //displayToast(T);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
        displayToast(T);
      });
    }
  }

  //url
  void _launchGooglePlayStore() async {
    const url = 'https://apps.apple.com/app/6739492787'; // Replace <YOUR_APP_ID> with your app's package name
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    checkUserConnection();
    super.initState();
  }



  Future<void> navigateBasedOnToken() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sContactNo = prefs.getString('sContactNo');
    print('------90--ContactNo----$sContactNo');

    if (sContactNo != null && sContactNo.isNotEmpty) {
      // Token found → Navigate to Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ComplaintHomePage()),
            (Route<dynamic> route) => false,
      );
    } else {
      // No token → Navigate to Login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen_2()),
            (Route<dynamic> route) => false,
      );
    }

  }

  getlocalDataBaseValue() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('sToken');
    print('----TOKEN---87---$token');
    if(token!=null && token!=''){

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ComplaintHomePage()),
            (Route<dynamic> route) => false, // This condition removes all previous routes
      );


    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen_2()),
            (Route<dynamic> route) => false, // This condition removes all previous routes
      );

    }
  }
  versionAliCall() async {
    /// TODO HERE YOU SHOULD CHANGE APP VERSION FLUTTER VERSION MIN 3 DIGIT SUCH AS 1.0.0
    /// HERE YOU PASS variable _appVersion
    var loginMap = await VerifyAppVersionRepo().verifyAppVersion(context,'21');
    var msg = "${loginMap['Msg']}";
    var iVersion = "${loginMap['iVersion']}";
    print("---version :  $iVersion");
    print("-----118---version api responnse-: $loginMap");
    // dep
   // var ver ="13";

    if(iVersion=="21"){
      print("-------123----version api match");
      // to check token is store or not
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sContactNo = prefs.getString('sContactNo');
      print("------162---ContactNo---$sContactNo");
      if(sContactNo!=null && sContactNo!=''){

        print("-------130----version api not match");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ComplaintHomePage()),
              (Route<dynamic> route) => false, // This condition removes all previous routes
        );

      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  const LoginScreen_2()),
        );
      }
      // displayToast(msg);
    }else{
      showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Version Available'),
            content: const Text('Download the latest version of the app from the App Store.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _launchGooglePlayStore(); // Close the dialog
                },
                child: const Text('Download'),
              ),

            ],
          );
        },
      );
      displayToast(msg);
      //print('----F---');
    }
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplaceScreen(),
    );
  }
}

class SplaceScreen extends StatelessWidget {

  const SplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomRight,
          children: [
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                     Positioned(
                         child: Text('Diu Citizen',
                           style:AppTextStyle.font30penSansExtraboldWhiteTextStyle,
                         ),
                     )
                ],
              )
            )

          ],
      )
    );
  }

}

