import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/notificationRepo.dart';


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
  // get api response
  getnotificationResponse() async {
    notificationList = await NotificationRepo().notification(context);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF255899),
          title: const Text(
            'Notification',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        // drawer
       // drawer: generalFunction.drawerFunction(context,'$sName','$sContactNo'),

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
                              const Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Icon(
                                  Icons.notification_important, size: 30, color: Color(
                                    0xFF255899),),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(notificationList?[index]['sTitle'].toString() ?? '',
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
