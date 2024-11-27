
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../aboutDiu/aboutdiu.dart';
import '../birth_death/birthanddeath.dart';
import '../bookAdvertisement/bookAdvertisement.dart';
import '../emergencyContact/emergencyContact.dart';
import '../helpline_feedback/helplinefeedback.dart';
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
      // appBar
     appBar: appBarFunction(context,"Diu Citizen "),

     drawer: generalFunction.drawerFunction_2(context,"Soyab","soayabali64@gmail.com"),

      body: Stack(
       // fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          /// todo here you applh border Image
          Container(
            height: 120, // Set the height of the container
            width: double.infinity, // Optionally set width to full screen
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/temples.png"), // Path to your image
                fit: BoxFit.fill, // Adjust the image to fill the container
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.only(top: 150, left: 10, right: 10, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          // Add your onTap functionality here
                          print('-----52------');

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           NotificationPage(),
                          // ));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OnlineComplaint(name: "Online Complaint")),
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
                                    // complaint_status
                                    Text(
                                      'Online Complaint',
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
                                    // complaint_status.png
                                    Text(
                                      'Complaint List',
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
                          // Add your onTap functionality here
                          print('-----52------');
                         // displayToast("Coming Soon");
                          var name="Birth & Death Cert";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BirthAndDeathCertificate(name:name),
                          ));

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           OnlineComplaint_2(name: "Raise Grievance")),
                          // );
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
                                side:
                                BorderSide(color: Colors.orange, width: 0.5),
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
                                      'Birth & Death Cert',
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BookAdvertisement("Book Advertisement")),
                          );

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           GrievanceStatus(name: "Grievance Status")),
                          // );
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
                                side: BorderSide(
                                    color: Colors.green, width: 0.5),
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
                                side: BorderSide(
                                    color: Colors.green, width: 0.5),
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
                                side:
                                    BorderSide(color: Colors.orange, width: 0.5),
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
                                side: BorderSide(
                                    color: Colors.green, width: 0.5),
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
        ],
      ),
    );
  }
}
