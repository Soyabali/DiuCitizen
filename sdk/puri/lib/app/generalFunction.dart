import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../resources/app_text_style.dart';
import '../temples/cityhistory/cityhistory.dart';
import '../temples/emergency/emergencyhome.dart';
import '../temples/facilities/facilities.dart';
import '../temples/howToReach/howToReach.dart';
import '../temples/templehome.dart';
import '../temples/weather/weather.dart';

// appBar
getAppBar(String title){
  return AppBar(
    backgroundColor: Colors.red,
    elevation: 10,
    shadowColor: Colors.orange,
    toolbarOpacity: 0.5,
    leading: Builder(
      builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            print('----26-----xxx-----');
            Scaffold.of(context).openDrawer();
           // Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            // Adjust the left margin as needed
            child: Transform.scale(
              scale: 0.8,
              // Adjust the scale factor as needed to reduce the image size
              child: Container(
                height: 35,
                width: 35,
                child: Image.asset("assets/images/menu.png"),
              ),
            ),
          ),
        );
      },
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/images/header_line1.png",
          width: 80,
          height: 15,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyle
              .font16penSansExtraboldWhiteTextStyle
        ),
        SizedBox(width: 10),
        Image.asset(
          "assets/images/header_line2.png",
          width: 75,
          height: 10,
        ),
      ],
    ),
  );
}
// appbar with backbutton
getAppBarBack(String title){
  return AppBar(
    backgroundColor: Colors.red,
    elevation: 10,
    shadowColor: Colors.orange,
    toolbarOpacity: 0.5,
    leading: Builder(
      builder: (BuildContext context) {
        return InkWell(
          onTap: () {
          },
          child: InkWell(
            onTap: (){
              print('------75---');
              Navigator.pop(context);
              //Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              // Adjust the left margin as needed
              child: Transform.scale(
                scale: 0.6,
                // Adjust the scale factor as needed to reduce the image size
                child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset("assets/images/back.png"),
                ),
              ),
            ),
          ),
        );
      },
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/images/header_line1.png",
          width: 80,
          height: 15,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyle
              .font16penSansExtraboldWhiteTextStyle
        ),
        SizedBox(width: 10),
        Image.asset(
          "assets/images/header_line2.png",
          width: 75,
          height: 10,
        ),
      ],
    ),
  );
}

class GeneralFunction {
  void logout(BuildContext context)async {
       /// TODO LOGOUT CODE
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("iUserId");
    prefs.remove("sName");
    prefs.remove("sContactNo");
    prefs.remove("sDesgName");
    prefs.remove("iDesgCode");
    prefs.remove("iDeptCode");
    prefs.remove("iUserTypeCode");
    prefs.remove("sToken");
    prefs.remove("dLastLoginAt");
    //displayToastlogout();
    goNext(context);
  }

  goNext(BuildContext context) {
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginScreen_2()),
    //       (route) => false, // Pop all routes until this page
    // );
  }
  // drawerFunction
  drawerFunction(BuildContext context, String sName, String sContactNo) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/applogo.png'), // Replace with your asset image path
                fit: BoxFit.cover,
              ),
            ),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => TemplesHome()),
                      );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const TemplesHome(),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/templepin.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'TEMPLES',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => CityHistory(templeName:"",image: "")),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CityHistory(templeName:"",image:""),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/cityhistory.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'CITY HISTORY',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => WeatherHome()),
                      );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const WeatherHome(),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/weather.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'WEATHER',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => FacilitiesHome()),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const FacilitiesHome(),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/facilities.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'FACILITIES',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                     // _showBottomSheet(context);   // EmergencyHome
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => EmergencyHome()),
                      );
                     //  Navigator.push(
                     //    context,
                     //    MaterialPageRoute(
                     //      builder: (context) => const EmergencyHome(),
                     //    ),
                     //  );
                   },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/emergency_menu.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'EMERGENCY',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      //_showBottomSheet(context);  //  HowToReach
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>  HowToReach(),
                      //   ),
                      // );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HowToReach()),
                      );
                      },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/how_to_rech.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'HOW TO REACH',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0,left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text('Synergy Telmatics Pvt.Ltd.',style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xffF37339),//#F37339
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    // const SizedBox(width: 0),
                    // Padding(
                    //   padding: EdgeInsets.only(right: AppSize.s10),
                    //   child: Container(
                    //     margin: EdgeInsets.all(AppSize.s10),
                    //     child: Image.asset(
                    //       ImageAssets.favicon,
                    //       //width: AppSize.s50,
                    //       width: 20,
                    //       height: 20,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ShowBottomSheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              print('---------');
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff3f617d),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Do you want to logout?",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff3f617d),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              // create an instance of General function
                              logout(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF255899),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust as needed
                              ), // Text color
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Adjust as needed
                              ), // Text color
                            ),
                            child: const Text(
                              'No',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
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
      },
    );
  }

  void displayToastlogout(){
    Fluttertoast.showToast(
        msg: "Someone else has been login with your number.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

   Future<void> launchGoogleMaps(double laititude,double longitude) async {
     double destinationLatitude= laititude;
     double destinationLongitude = longitude;
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {
          'q': '$destinationLatitude, $destinationLongitude'
        });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

}