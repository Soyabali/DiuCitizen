import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/notificationRepo.dart';
import '../complaints/complaintHomePage.dart';
import '../otp/otpverification.dart';
import '../resources/app_text_style.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map<String, dynamic>>? notificationList;

  String? sName, sContactNo;
  GeneralFunction generalFunction = GeneralFunction();
  getnotificationResponse() async {
    notificationList = await NotificationRepo().notification(context);
    print('------39----$notificationList');
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getlocalvalue();
    getnotificationResponse();
    super.initState();
  }
  getlocalvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sName = prefs.getString('sName') ?? "";
      sContactNo = prefs.getString('sContactNo') ?? "";
      print("------148---$sName");
      print("------1149---$sContactNo");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 10,
          shadowColor: Colors.orange,
          toolbarOpacity: 0.5,
          leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
              );
             // Navigator.pop(context);
             //  Navigator.push(
             //    context,
             //    MaterialPageRoute(builder: (context) => const OtpPage(phone:"")),
             //  );
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
            "Notification",
            style: AppTextStyle.font16penSansExtraboldWhiteTextStyle,
          ),
          centerTitle: true,
        ),
        drawer: generalFunction.drawerFunction(context,'$sName','$sContactNo'),

        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height,

                  child: ListView.separated(
                      itemCount: notificationList != null ? notificationList!.length : 0,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(); // Example separator, you can customize this
                      },
                      itemBuilder: (context, index) {
                        return  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  child: const Icon(
                                    Icons.notification_important, size: 25, color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(notificationList?[index]['sCategoryName'].toString() ?? '',
                                    style: const TextStyle(
                                                          fontFamily: 'Montserrat',
                                                          color: Color(0xff3f617d),
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                  SizedBox(height: 2),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 32,
                                    child: Text(
                                      notificationList?[index]['sNotification'].toString() ?? '',
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff3f617d),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.calendar_month,size:18,
                                      color: Color(0xff3f617d),),
                                      SizedBox(width: 5),
                                      Text(notificationList?[index]['dRecivedAt'].toString() ?? '',
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xff3f617d),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                        );
                      }
                  ),
                ),
              )
            
              ]
            ),
          ),
        )


    );

  }
}
