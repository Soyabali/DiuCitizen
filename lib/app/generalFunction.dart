import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../presentation/advertisementBookingStatus/advertisementBookingStatus.dart';
import '../presentation/complaints/complaintHomePage.dart';
import '../presentation/complaints/raiseGrievance/notification.dart';
import '../presentation/homepage/homepage.dart';
import '../presentation/login/loginScreen_2.dart';
import '../presentation/resources/app_text_style.dart';
import '../presentation/resources/assets_manager.dart';
import '../presentation/resources/values_manager.dart';
import '../presentation/temples/cityhistory/cityhistory.dart';
import '../presentation/temples/emergency/emergencyhome.dart';
import '../presentation/temples/facilities/facilities.dart';
import '../presentation/temples/howToReach/howToReach.dart';
import '../presentation/temples/templehome.dart';
import '../presentation/temples/weather/weather.dart';
import '../services/deleteaccountrepo.dart';

// pdf downlodd path

Future<String> loadPdfFromAssets(String assetPath) async {
  try {
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer;
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp.pdf');
    await tempFile.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return tempFile.path;
  } catch (e) {
    print(e);
    return '';
  }
}
// call dialog
Widget buildDialogCall(BuildContext context, String sEmpName, String sContactNo) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 170,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Space for the image
              const Row(
                children: [
                  Icon(
                    Icons.phone, // Exclamation icon
                    color: Colors.red, // Color of the icon
                    size: 22, // Size of the icon
                  ),
                  SizedBox(width: 8), // Spacing between the icon and text
                  Text(
                    'Phone Call',
                    style: TextStyle(
                      fontSize: 16, // Adjust font size
                      fontWeight: FontWeight.bold, // Make the text bold
                      color: Colors.black, // Text color
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded( // Wrap the text in Expanded to allow it to take available space and wrap
                child: Text.rich(
                  TextSpan(
                    text: 'Do you want to call ', // Regular text
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600]), // Default text style
                    children: <TextSpan>[
                      TextSpan(
                        text: '$sEmpName', // Highlighted text
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Bold only for the name
                          color: Color(0xff3f617d), // Optional: Change color for the name
                        ),
                      ),
                      const TextSpan(
                        text: '?', // Regular text after the name
                      ),
                    ],
                  ),
                ),
                // child: Text(
                //   "Do you want to call Ashish Babu",
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey[600],
                //   ),
                //   textAlign: TextAlign.left, // Align the text to the left
                //   softWrap: true, // Allow text to wrap
                //   maxLines: 2, // Set the maximum number of lines the text can take
                //   overflow: TextOverflow.ellipsis, // Add ellipsis if the text exceeds the available space
                // ),
              ),
              SizedBox(height: 20),
              Container(
                height: 35, // Reduced height to 35
                padding: EdgeInsets.symmetric(horizontal: 5), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Colors.white, // Container background color
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  border: Border.all(color: Colors.grey), // Border color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          //generalFunction.logout(context);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          minimumSize: Size(0, 0), // Remove minimum size constraints
                          backgroundColor: Colors.white, // Button background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Button border radius
                          ),
                        ),
                        child: Text(
                          'No',
                          style: GoogleFonts.openSans(
                            color: Colors.red, // Text color for "Yes"
                            fontSize: 12, // Adjust font size to fit the container
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.grey, // Divider color
                      width: 20, // Space between buttons
                      thickness: 1, // Thickness of the divider
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // getLocation();
                          // Navigator.of(context).pop();
                          _makePhoneCall("${sContactNo}");

                          print("----Phone call----");
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          minimumSize: Size(0, 0), // Remove minimum size constraints
                          backgroundColor: Colors.white, // Button background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Button border radius
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: GoogleFonts.openSans(
                            color: Colors.green, // Text color for "No"
                            fontSize: 12, // Adjust font size to fit the container
                            fontWeight: FontWeight.w400,
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

      ],
    ),
  );
}

// phoneCall method
void _makePhoneCall(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneUri';
  }
}

// toast
void displayToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
// navigateToGoogleMap

Future<void> launchGoogleMaps(double latitude, double longitude) async {
  print('----37---$latitude');
  print('----38---$longitude');

  final uri = Uri(
    scheme: 'geo',
    path: '$latitude,$longitude',
    queryParameters: {
      'q': '$latitude,$longitude',
    },
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    debugPrint('An error occurred');
  }
}

// backbutton dialog
Future<bool> _onWillPop(BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () {
            exit(0);
            //Navigator.of(context).pop(true);
          },
          child: Text('Yes'),
        ),
      ],
    ),
  )) ??
      false;
}

// readmoreTemple
readmore(String templeDetails) {
  return ReadMoreText(
    '''The District of Puri has been named after its head quarters, Puri. According to Cunningham, the ancient name of this town was Charitra
Under Mughal Rule (1592-1751), Odisha for the purpose of revenue administration was divided into three circars, namely Jaleswar,
 Bhadrak and Kataka, each of which under the Mughals was subdivided into Bishis. Puri formed a part of Kataka circar. After their occupation of Odisha in 1751, 
the Marathas brought about some changes in the revenue divisions of the province. They divided Odisha, which then extended from the river Suvarnarekha 
in the North to the lake Chilika in the South, into four Chakalas viz. Pipli, Kataka, Soro and Balasore. The Chakala of Pipli comprised major portions of the modern District of Puri.
''',
    trimLines: 10,
    colorClickableText: Colors.red,
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    trimExpandedText: 'Show less',
    style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
    moreStyle:
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
   // textAlign: TextAlign.justify, // Justify text alignment
  );
}

// middleHeader
middleHeader(BuildContext context, String templeName) {
  return Stack(
    children: <Widget>[
      Container(
        height: 35,
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 5,
              top: 5,
              right: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/cityelementone.png',
                    // Replace with your first image path
                    height: 25.0,
                    width: 25.0,
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/images/listelementtop.png',
                    // Replace with your second image path
                    height: 25.0,
                    width: 25.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );
}
middleHeaderPuri(BuildContext context, String templeName) {
  return Stack(
    children: <Widget>[
      Container(
        height: 50,
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 5,
              top: 5,
              right: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/cityelementone.png',
                    // Replace with your first image path
                    height: 25.0,
                    width: 25.0,
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/images/listelementtop.png',
                    // Replace with your second image path
                    height: 25.0,
                    width: 25.0,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              child: Image.asset('assets/images/templeelement1.png',
                  // Replace with your first image path
                  height: 30.0,
                  width: MediaQuery.of(context).size.width),
            ),
            Positioned(
                top: 55,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(templeName,
                      style: AppTextStyle.font16penSansExtraboldRedTextStyle),
                ))
          ],
        ),
      )
    ],
  );
}
 appBarFunction(BuildContext context,String title){
   return AppBar(
     // statusBarColore
     iconTheme: IconThemeData(color: Colors.white),
     systemOverlayStyle: const SystemUiOverlayStyle(
       statusBarColor: Color(0xFF12375e),
       statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
       statusBarBrightness: Brightness.light, // For iOS (dark icons)
     ),
     // backgroundColor: Colors.blu
     backgroundColor: Color(0xFF255898),
     centerTitle: true,
     title: Padding(
       padding: EdgeInsets.symmetric(horizontal: 5),
       child: Text(
         '$title',
         style: const TextStyle(
           color: Colors.white,
           fontSize: 16,
           fontWeight: FontWeight.normal,
           fontFamily: 'Montserrat',
         ),
         textAlign: TextAlign.center,
       ),
     ),
     //centerTitle: true,
     elevation: 0, // Removes shadow under the AppBar
   );
}
// appBar
getAppBar(String title) {
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
              scale: 0.6,
              // Adjust the scale factor as needed to reduce the image size
              child: Container(
                height: 20,
                width: 20,
                child: Image.asset("assets/images/menu.png"),
              ),
            ),
          ),
        );
      },
    ),
    title: Text(title, style: AppTextStyle.font16penSansExtraboldWhiteTextStyle),
    centerTitle: true,
  );
}

// appbar with backbutton
getAppBarBack(BuildContext context ,String title) {
  return AppBar(
    // statusBarColore
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF12375e),
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ),
    // backgroundColor: Colors.blu
    centerTitle: true,
    backgroundColor: Color(0xFF255898),
    leading: GestureDetector(
      onTap: (){
        print("------back---");
        Navigator.pop(context);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.arrow_back_ios,
          color: Colors.white,),
      ),
    ),
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        '$title',
        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
        textAlign: TextAlign.center,
      ),
    ),
    //centerTitle: true,
    elevation: 0, // Removes shadow under the AppBar
  );
}

dynamic? lat,long;

class GeneralFunction {

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This removes all stored data
    goNext(context);

  }

  goNext(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen_2()),
          (Route<dynamic> route) => false, // Condition to retain routes
    );
  }
  // drawerfuntiion 2

  drawerFunction(BuildContext context, String sName, String sContactNo) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0098a6),

            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    sName,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Text(
                    "email",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                ],
              ),
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ComplaintHomePage()),
                      );
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset('assets/images/home.png',
                            width: 25,
                            height: 25),
                        // color: Colors.red),
                        const SizedBox(width: 10),
                        Text('Home',
                            style: AppTextStyle
                                .font16penSansExtraboldBlackTextStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: ()async {
                      // lat and long in a sharedPreferenc
                      //
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      double? lat = prefs.getDouble('lat');
                      double? long = prefs.getDouble('long');
                      print('---334---lat---$lat');
                      print('---335---long---$long');

                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => TemplesHome(lat:lat,long:long)),
                      // );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => TemplesHome()),
                      );
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
                        Text('Advertisement Booking Status',
                            style: AppTextStyle
                                .font16penSansExtraboldBlackTextStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                CityHistory(templeName: "", image: "")),
                      );
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
                        Text(
                          'Notification',
                          style:
                          AppTextStyle.font16penSansExtraboldBlackTextStyle,
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
                        Text('Logout',
                            style: AppTextStyle
                                .font16penSansExtraboldBlackTextStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // widget function
  Widget _buildDialogSucces(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 170,
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Space for the image
                const Row(
                  children: [
                    Icon(
                      Icons.error_outline, // Exclamation icon
                      color: Colors.red, // Color of the icon
                      size: 22, // Size of the icon
                    ),
                    SizedBox(width: 8), // Spacing between the icon and text
                    Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 16, // Adjust font size
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.black, // Text color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded( // Wrap the text in Expanded to allow it to take available space and wrap
                  child: Text(
                    "Are you sure you want to Delete Account?",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.left, // Align the text to the left
                    softWrap: true, // Allow text to wrap
                    maxLines: 2, // Set the maximum number of lines the text can take
                    overflow: TextOverflow.ellipsis, // Add ellipsis if the text exceeds the available space
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 35, // Reduced height to 35
                  padding: EdgeInsets.symmetric(horizontal: 5), // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    border: Border.all(color: Colors.grey), // Border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            //generalFunction.logout(context);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove default padding
                            minimumSize: Size(0, 0), // Remove minimum size constraints
                            backgroundColor: Colors.white, // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red, // Text color for "Yes"
                              fontSize: 12, // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.grey, // Divider color
                        width: 20, // Space between buttons
                        thickness: 1, // Thickness of the divider
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: ()async {
                            // getLocation();
                            Navigator.pop(context);
                            print("----Call api delete the Account---");

                            var  deleteAccount = await DeleteAccountRepo().deleteAccount(context,"");
                            print("-----DeleteAccount---$deleteAccount");

                            var  result = "${deleteAccount['Result']}";
                            var msg = "${deleteAccount['Msg']}";


                            if(result=="1"){
                              // show dialog Account is deleted
                              // _buildDialogSucces2
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return _buildDialogSucces2(context,msg);
                                },
                              );
                            }else{
                              displayToast(msg);
                              // show a msg api msg
                            }
                            // Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove default padding
                            minimumSize: Size(0, 0), // Remove minimum size constraints
                            backgroundColor: Colors.white, // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              color: Colors.green, // Text color for "No"
                              fontSize: 12, // Adjust font size to fit the container
                              fontWeight: FontWeight.w400,
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
        ],
      ),
    );
  }
  // drawerFunction
  Widget _buildDialogSucces2(BuildContext context,String msg) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 190,
            padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Success',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // navigate to LoginScreen

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen_2()),
                              (Route<dynamic> route) => false, // Condition to retain routes
                        );


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the background color to white
                        foregroundColor: Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/sussess.jpeg', // Replace with your asset image path
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  drawerFunction_2(BuildContext context, String sName, String sContactNo) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
           DrawerHeader(
            decoration: const BoxDecoration(
              // Set background image
              color: Colors.lightBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // User profile image
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/Diu_icon-02.png'),
                ),
                const SizedBox(height: 10),
                // First text (e.g., user name)
                Text(
                  sName,
                  style: AppTextStyle.font16OpenSansRegularBlackTextStyle,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.call,
                    size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      sContactNo,
                      style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ComplaintHomePage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset('assets/images/home_nw.png',
                            width: 25,
                            height: 25,
                            fit: BoxFit.fill,
                        ),
                           // color: Colors.red),
                        const SizedBox(width: 10),
                        Text('Home',
                            style: AppTextStyle
                                .font16penSansExtraboldBlackTextStyle),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 15),
                  // GestureDetector(
                  //   onTap: () async {
                  //     //displayToast("Coming Soon");
                  //
                  //     Navigator.of(context).pushReplacement(
                  //       MaterialPageRoute(builder: (context) => AdvertisementBookingStatus()),
                  //     );
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: <Widget>[
                  //       Image.asset(
                  //         'assets/images/holdicon.jpeg',
                  //         width: 25,
                  //         height: 25,
                  //         fit: BoxFit.fill,
                  //       ),
                  //       const SizedBox(width: 10),
                  //       Text('Advertisement Booking Status',
                  //           style: AppTextStyle
                  //               .font16penSansExtraboldBlackTextStyle),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                     // displayToast("Coming Soon");

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => NotificationPage()),
                      );
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
                        Text(
                          'Notification',
                          style:
                              AppTextStyle.font16penSansExtraboldBlackTextStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildDialogSucces(context);
                        },
                      );

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/deleteaccount.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Delete Account',
                          style:
                          AppTextStyle.font16penSansExtraboldBlackTextStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      // clear all store SharedPreferenceValue :

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear(); // This removes all stored data

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen_2()),
                      );

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
                        Text('Logout',
                            style: AppTextStyle
                                .font16penSansExtraboldBlackTextStyle),
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
                    const Text('Synergy Telematics Pvt.Ltd.',style: TextStyle(
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

  // inter net images
  Widget internetImage(String imageUrl, {double size = 80.0, BoxFit fit = BoxFit.cover}) {
    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: fit,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child; // Image is fully loaded, so display it
          } else {
            // Show a CircularProgressIndicator while the image is loading
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }
        },
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          // Show an error icon if the image fails to load
          return Container(
            height: 50, // Set the height of the container
            width: 50,  // Set the width of the container
            decoration: BoxDecoration(
              color: Colors.grey.shade400, // Background color
              borderRadius: BorderRadius.circular(50), // Make the corners rounded
            ),
            child: ClipOval( // Clip the child to a circle
            ),
          );
          // return Icon(Icons.error, color: Colors.red, size: size / 2);
        },
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

  void displayToastlogout() {
    Fluttertoast.showToast(
        msg: "Someone else has been login with your number.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> launchGoogleMaps(double laititude, double longitude) async {
    double destinationLatitude = laititude;
    double destinationLongitude = longitude;
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {'q': '$destinationLatitude, $destinationLongitude'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }
}
