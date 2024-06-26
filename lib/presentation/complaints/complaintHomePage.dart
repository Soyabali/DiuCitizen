
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/presentation/complaints/raiseGrievance/onlineComplaint.dart';
import 'package:puri/presentation/complaints/raiseGrievance/onlineComplaint_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../app/navigationUtils.dart';
import '../aboutpuri/aboutpuri.dart';
import '../birth_death/birthanddeath.dart';
import '../bookAdvertisement/bookAdvertisement.dart';
import '../emergencyContact/emergencyContact.dart';
import '../eventsAndNewsletter/eventsAndNewsletter.dart';
import '../homepage/homepage.dart';
import '../knowyourward/KnowYourWard.dart';
import '../login/loginScreen_2.dart';
import '../marriageCertificate/marriageCertificate.dart';
import '../notification/notification.dart';
import '../parklocator/parklocator.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_style.dart';
import 'grievanceStatus/grievanceStatus.dart';


class ComplaintHomePage extends StatefulWidget {
  const ComplaintHomePage({super.key});

  @override
  State<ComplaintHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ComplaintHomePage> {

  GeneralFunction generalFunction = GeneralFunction();
  String? sCitizenName;
  String? sContactNo;

  @override
  void initState() {
    // TODO: implement initState
    getLocatdata();
    super.initState();
  }
  getLocatdata() async{
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
    return Scaffold(
      backgroundColor: Colors.white,
     // appBar: getAppBarBack(context,"Citizen Services"),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 10,
        shadowColor: Colors.orange,
        toolbarOpacity: 0.5,
        leading: InkWell(
          onTap: () {
          //  Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  HomePage()),
            );
          //   if (Navigator.canPop(context)) {
          //     Navigator.pop(context);
          //   } else {
          //     SystemNavigator.pop();
          //   }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding if necessary
            child: Image.asset(
              "assets/images/back.png",
              fit: BoxFit.contain, // BoxFit.contain ensures the image is not distorted
            ),
          ),
        ),
        title: Text(
          "Citizen Services",
          style: AppTextStyle.font16penSansExtraboldWhiteTextStyle,
        ),
        actions: [
        InkWell(
          onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationPage()),
                        );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
            width: 25,
            height: 25,
            //color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0), // Sets the border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),

            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/notification_123.png',
                width: 25,height: 25,
              fit: BoxFit.cover,
              ),
            ),
                  ),
          ),
        ),

          // Image(
          //   image: AssetImage('assets/images/notification_123.png'),
          //   height: 25,
          //   width: 25,
          //   fit: BoxFit.cover,
          // ),
          // Container(
          //  // color: Colors.white,
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 10),
          //     child: Padding(
          //       padding: const EdgeInsets.all(4.0),
          //       child: IconButton(
          //           icon: Icon(Icons.notification_add,color: Colors.white,size: 25,),
          //           onPressed: () {
          //            //
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => const NotificationPage()),
          //             );
          //           },
          //         ),
          //     ),
          //   ),
          // ),
        ],
        centerTitle: true,
      ),
      drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          middleHeader(context,'Citizen Services'),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(top: 35,left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text('Name',style: AppTextStyle
                      .font14penSansExtraboldGreenTextStyle,),
                  SizedBox(width: 50),
                  Text(':',style: AppTextStyle
                      .font14penSansExtraboldGreenTextStyle,),
                SizedBox(width: 20),
                Text('${sCitizenName}',style: AppTextStyle
                    .font14penSansExtraboldOrangeTextStyle,),
                Spacer(),

                InkWell(
                  onTap: () async {
                    print('-----Open Dialog box-----');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
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
                              onPressed: ()async {

                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.clear();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen_2()),
                                    );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(Icons.logout, size: 20, color: Colors.orange),
                  ),
                ),


                // InkWell(
                //   onTap: () async {
                //     print('-----Open Dialog box-----');
                //     AlertDialog(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //         side: BorderSide(color: Colors.orange, width: 2),
                //       ),
                //       title: Text('Do you want to log out?'),
                //       actions: <Widget>[
                //         ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.grey, // Background color
                //           ),
                //           child: Text('No'),
                //           onPressed: () {
                //             Navigator.of(context).pop(); // Dismiss the dialog
                //           },
                //         ),
                //         ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.orange, // Background color
                //           ),
                //           child: Text('Yes'),
                //           onPressed: () {
                //             // Add your logout functionality here
                //             Navigator.of(context).pop(); // Dismiss the dialog
                //           },
                //         ),
                //       ],
                //     );
                //
                //
                //
                //
                //
                //
                //
                //     // print('---logout---');
                //     // SharedPreferences prefs = await SharedPreferences.getInstance();
                //     // prefs.clear();
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(builder: (context) => const LoginScreen_2()),
                //     // );
                //
                //
                //
                //   },
                //
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 20),
                //     child: Icon(Icons.logout,size: 20,color: AppColors.orange),
                //   ),
                //
                //
                //
                // ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60,left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ContactNo',style: AppTextStyle
                    .font14penSansExtraboldGreenTextStyle,),
                SizedBox(width: 20),
                Text(':',style: AppTextStyle
                    .font14penSansExtraboldGreenTextStyle,),
                SizedBox(width: 20),
                Text('${sContactNo}',style: AppTextStyle
                    .font14penSansExtraboldOrangeTextStyle),

              ],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.only(top: 90, left: 10, right: 10, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          print('-----52------');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OnlineComplaint_2(name: "Raise Grievance")),
                          );
                        },
                        child: Container(
                          height: 100,
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
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Raise Grievance',
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
                          print('-----109------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GrievanceStatus(name: "Grievance Status")),
                          );
                        },
                        child: Container(
                          height: 100,
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
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Grievance Status',
                                      style: AppTextStyle
                                          .font14penSansExtraboldOrangeTextStyle,
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
                          // BookAdvertisement
                          // Add your onTap functionality here
                          print('-----177------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookAdvertisement(
                                    complaintName: "Book Advertisement")),
                          );
                        },
                        child: Container(
                          height: 100,
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
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Book Advertisement',
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
                          print('-----235------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KnowYourWard(
                                    name: "Know Your Ward")),
                          );
                        },
                        child: Container(
                          height: 100,
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
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Know Your Ward',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarriageCertificate(
                                    name: "Marriage Certificate")),
                          );
                        },
                        child: Container(
                          height: 100,
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
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Marriage Certificate',
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
                          //print('-----353------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BirthAndDeathCertificate(
                                    name: "Birth & Death Cert")),
                          );

                        },
                        child: Container(
                          height: 100,
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
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text(
                                      'Birth & Death Cert',
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
                          // ParkLocator
                          print('-----414------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParkLocator(
                                    name: "Park Locator'")),
                          );
                        },
                        child: Container(
                          height: 100,
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
                                side: BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('Park Locator',
                                        style: AppTextStyle
                                            .font14penSansExtraboldOrangeTextStyle),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          print('-----470------');
                          // EmergencyContacts
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmergencyContacts(
                                    name: "Emergency Contacts")),
                          );

                        },
                        child: Container(
                          height: 100,
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
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('Emergency Contacts',
                                        style: AppTextStyle
                                            .font14penSansExtraboldGreenTextStyle),
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
                          print('-----530------');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventsAndNewSletter(
                                    name: "Events / Newsletter")),
                          );
                          },
                        child: Container(
                          height: 100,
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
                                side:
                                    BorderSide(color: Colors.green, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('Events / Newsletter',
                                        style: AppTextStyle
                                            .font14penSansExtraboldGreenTextStyle),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          // Add your onTap functionality here
                          //print('-----586------');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPuri()),
                          );
                        },
                        child: Container(
                          height: 100,
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
                                side: const BorderSide(
                                    color: Colors.orange, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        // half of width and height for a circle
                                        //color: Colors.green
                                        color: Color(0xFFD3D3D3),
                                      ),
                                      child: const Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/complaint_status.png'),
                                        width: 30,
                                        height: 30,
                                      )),
                                    ),
                                    Text('About Puri',
                                        style: AppTextStyle
                                            .font14penSansExtraboldOrangeTextStyle),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height:15),
                  // Image.asset('assets/images/templeelement3.png',
                  //       height: 30.0,
                  //       width: MediaQuery.of(context).size.width),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
