
import 'package:cuttack/presentation/resources/routes_manager.dart';
import 'package:cuttack/presentation/screen/advertisementBooking/advertisementBooking.dart';
import 'package:cuttack/presentation/screen/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/homeScreen.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';


class GeneralFunction {
  void logout(BuildContext context)async {
       /// TODO LOGOUT CODE
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // Pop all routes until this page
    );
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
                image: AssetImage('assets/images/citysimpe.png'), // Replace with your asset image path
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Version - 06',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff3f617d),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/burger1.jpg'), // Replace with your asset image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // // const Icon(
                //   Icons.person,
                //   size: 50,
                //   color: Color(0xff3f617d),
                // ),

                Text(
                  '${sName}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xff3f617d),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.call,
                      size: 18,
                      color: Color(0xff3f617d),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${sContactNo}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff3f617d),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/home_nw.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Home',
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
                      print('----Advertisement---');
                      // Navigator.pushReplacementNamed(
                      //     context, Routes.advertisement);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Advertisement(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/my_wallet.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Advertisement Booking Status',
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ChangePassWord(),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/change_password_nw.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Garbage Pickup Request List',
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ChangePassWord(),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/change_password_nw.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Sewerage Lifting Request List',
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const NotificationPage(),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/notification.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Notification',
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
                      _showBottomSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logout_new.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Logout',
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
                    const SizedBox(width: 0),
                    Padding(
                      padding: EdgeInsets.only(right: AppSize.s10),
                      child: Container(
                        margin: EdgeInsets.all(AppSize.s10),
                        child: Image.asset(
                          ImageAssets.favicon,
                          //width: AppSize.s50,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
  //
  //  Future<void> launchGoogleMaps(double laititude,double longitude) async {
  //    double destinationLatitude= laititude;
  //    double destinationLongitude = longitude;
  //   final uri = Uri(
  //       scheme: "google.navigation",
  //       // host: '"0,0"',  {here we can put host}
  //       queryParameters: {
  //         'q': '$destinationLatitude, $destinationLongitude'
  //       });
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     debugPrint('An error occurred');
  //   }
  // }

}