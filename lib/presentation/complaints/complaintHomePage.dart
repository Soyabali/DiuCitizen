
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../aboutDiu/aboutdiu.dart';
import '../bookAdvertisement/bookAdvertisementHome.dart';
import '../emergencyContact/emergencyContact.dart';
import '../helpline_feedback/helplinefeedback.dart';
import '../importantLink/importantlink.dart';
import '../onlineComplaint/onlineComplaint.dart';
import '../onlineService/onlineService.dart';
import '../resources/app_text_style.dart';
import 'grievanceStatus/grievanceStatus.dart';

class ComplaintHomePage extends StatefulWidget {

  const ComplaintHomePage({super.key});

  @override
  State<ComplaintHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ComplaintHomePage> {

  GeneralFunction generalFunction = GeneralFunction();
  //  drawerFunction
  String? sCitizenName;
  String? sContactNo;
  String? sContactNo2;
  String? sContactNo3;
  var token;

  /// todo here you should put notification code and call initState()
  void setupPushNotifications() async {
      print("------41----xxxxx---xxxxx");
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    token = await fcm.getToken();
    print("🔥 Firebase Messaging Instance Info:");
    print("📌 Token:----45----xxx $token");

    NotificationSettings settings = await fcm.getNotificationSettings();
    print("🔔 Notification Permissions:");
    print("  - Authorization Status: ${settings.authorizationStatus}");
    print("  - Alert: ${settings.alert}");
    print("  - Sound: ${settings.sound}");
    print("  - Badge: ${settings.badge}");

    // ✅ Ensure notifications play default sound
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 New foreground notification received!");
      print("📦 Data Payload----563---xx--: ${message.data}");
      if (message.notification != null) {
        _showNotification(message.notification!);
      }
    });

    if (token != null && token!.isNotEmpty) {
      /// todo  here call a api
      //notificationResponse(token);
    } else {
      print("🚨 No Token Received!");
    }
  }

// ✅ Show Notification with Default Sound
  void _showNotification(RemoteNotification notification) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true, // 🔊 Ensure sound is enabled
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentSound: true, // 🔊 Enable sound for iOS
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      notification.title,
      notification.body,
      details,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    setupPushNotifications();
    getLocatdata();
    super.initState();
  }
  getLocatdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCitizenName = prefs.getString('sCitizenName');
    sContactNo = prefs.getString('sContactNo');
    print('---46--$sCitizenName');
    print('---47--$sContactNo');
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget logoutDialogBox(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.orange, width: 2),
      ),
      title: Text('Do you want to log out?'),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // Background color
          ),
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Background color
          ),
          child: Text('Yes'),
          onPressed: () {
            // Add your logout functionality here
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar
       appBar: appBarFunction(context,"Diu Citizen"),
       drawer: generalFunction.drawerFunction_2(context,"$sCitizenName","$sContactNo"),
       body: Stack(
         // fit: StackFit.expand, // Make the stack fill the entire screen
          children: [
            /// todo here you applh border Image
            Container(
              height: 210, // Set the height of the container
              width: double.infinity, // Optionally set width to full screen
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/onlinecomplaint.jpeg"), // Path to your image
                  fit: BoxFit.fill, // Adjust the image to fill the container
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 200, left: 0, right: 0, bottom: 5),
              child:Container(
                 // width: 300, // Set the width of the container
                  height: MediaQuery.of(context).size.height, // Set the height of the container
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/background.png'), // Your asset path
                      fit: BoxFit.cover, // Adjust how the image fits the container
                    ),
                    borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
                    // boxShadow: const [
                    //   BoxShadow(
                    //     color: Colors.black12, // Shadow color
                    //     blurRadius: 10, // Spread of the shadow
                    //     offset: Offset(0, 5), // Position of the shadow
                    //   ),
                    // ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: ListView(
                     // mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.watch_later_rounded),
                            SizedBox(width: 15),
                            Text("Funtional Activites",style: AppTextStyle.font16penSansExtraboldBlack45TextStyle),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {

                                // Navigator.push(context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           OnlineComplaint(name: "Online Complaint")),
                                // );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  OnlineComplaint(name: "Online Complaint")),
                                );
                                },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  // border
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  // border radiouse
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomLeft: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(5.0),
                                    shadowColor: Colors.green,
                                    // shape
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                              image: AssetImage(
                                                  'assets/images/online_Complain.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          SizedBox(height: 10),
                                         // divider or line
                                          Container(
                                           height: 1,
                                           color: Colors.black12,
                                         ),
                                          SizedBox(height: 5),
                                          // complaint_status
                                          Text('Online Complaint',
                                            style: AppTextStyle.font14penSansExtraboldGreenTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                                print('-----109------');
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           PendingComplaintScreen()),
                                // );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GrievanceStatus(name: "Complaint List")),
                                );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  // border
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.orange,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  // border Radiouse
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomRight: Radius.circular(10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.orange,
                                    // shape
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.orange, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              // decoration images
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_2.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                              // images
                                                child: Image(
                                              image: AssetImage('assets/images/complaint_list.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          // complaint_status.png
                                          SizedBox(height: 10),
                                          // divider
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          // text
                                          Text(
                                            'Complaint List',
                                            style: AppTextStyle
                                                .font14penSansExtraboldOrangeTextStyle,

                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                                print('-----52------');
                               // displayToast("Coming Soon");
                                var name="Important Links";

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Importantlink(name:name),
                                ));

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           OnlineComplaint_2(name: "Raise Grievance")),
                                // );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.orange,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomLeft: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(5.0),
                                    shadowColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      side:
                                      BorderSide(color: Colors.orange, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_4.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            // decoration: BoxDecoration(
                                            //   borderRadius: BorderRadius.circular(25),
                                            //   // half of width and height for a circle
                                            //   //color: Colors.green
                                            //   color: Color(0xFFD3D3D3),
                                            // ),
                                            child: const Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/holdicon.jpeg'),
                                                  width: 45,
                                                  height: 45,
                                                )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Important Links',
                                            style: AppTextStyle
                                                .font14penSansExtraboldOrangeTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                                //print('-----109------');
                              //  displayToast("Coming Soon");
                                var name = "Book Advertisement";

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookadvertisementHome(name: name)),
                                );

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           GrievanceStatus(name: "Grievance Status")),
                                // );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.green,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomRight: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_4.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/register.png'),
                                                  width: 45,
                                                  height: 45,
                                                )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Book Advertisement',
                                            style: AppTextStyle
                                                .font14penSansExtraboldGreenTextStyle,
                                            // style: GoogleFonts.lato(
                                            //     textStyle: Theme.of(context).textTheme.titleSmall,
                                            //     fontSize: 14,
                                            //     fontWeight: FontWeight.w700,
                                            //     fontStyle: FontStyle.italic,
                                            //     color:Colors.orange
                                            // ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                               // displayToast("Coming Soon");
                                // BookAdvertisement
                                // Add your onTap functionality here
                                print('-----177------');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmergencyContacts(name: "Emergency Contacts")),
                                );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomLeft: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(5.0),
                                    shadowColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_9.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            // decoration: BoxDecoration(
                                            //   borderRadius: BorderRadius.circular(25),
                                            //   // half of width and height for a circle
                                            //   //color: Colors.green
                                            //   color: Color(0xFFD3D3D3),
                                            // ),
                                            child: const Center(
                                                child: Image(
                                              image: AssetImage(
                                                  'assets/images/emergencyContact.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Emergency Contacts',
                                            style: AppTextStyle
                                                .font14penSansExtraboldGreenTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                                print('-----235------');
                               // displayToast("Coming Soon");
                                // OnlineServives
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OnlineServives(
                                          name: "Online Services")),
                                );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.orange,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomRight: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.orange, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_6.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            // decoration: BoxDecoration(
                                            //   borderRadius: BorderRadius.circular(25),
                                            //   // half of width and height for a circle
                                            //   //color: Colors.green
                                            //   color: Color(0xFFD3D3D3),
                                            // ),
                                            child: const Center(
                                                child: Image(
                                              image: AssetImage('assets/images/events_newsletter.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Online Services',
                                            style: AppTextStyle
                                                .font14penSansExtraboldOrangeTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HelpLineFeedBack(
                                          name: "Marriage Certificate", image: '',)),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => MarriageCertificate(
                                //           name: "Marriage Certificate")),
                                // );
                              },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.orange,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomLeft: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(5.0),
                                    shadowColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_8.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                              image: AssetImage(
                                                  'assets/images/helpline_feedback.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Helpline/Feedback',
                                            style: AppTextStyle
                                                .font14penSansExtraboldOrangeTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                // Add your onTap functionality here
                                //print('-----353------');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutDiu(
                                          name: "About DIU")),
                                );
                                },
                              child: Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width / 2 - 14,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.green,
                                      // Specify your desired border color here
                                      width: 5.0, // Adjust the width of the border
                                    ),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    // Adjust the radius for the top-left corner
                                    bottomRight: Radius.circular(
                                        10.0), // Adjust the radius for the bottom-left corner
                                  ),
                                ),
                                // color: Colors.black,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.green, width: 0.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                image: AssetImage('assets/images/background_circle_1.png'), // Path to the asset
                                                fit: BoxFit.cover, // Adjust how the image fits within the container
                                              ),
                                              borderRadius: BorderRadius.circular(12), // Optional: Adds rounded corners
                                            ),
                                            child: const Center(
                                                child: Image(
                                              image: AssetImage(
                                                  'assets/images/about_diu.png'),
                                              width: 45,
                                              height: 45,
                                            )),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'About DIU',
                                            style: AppTextStyle
                                                .font14penSansExtraboldGreenTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
