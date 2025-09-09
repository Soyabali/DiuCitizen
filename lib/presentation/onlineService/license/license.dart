
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/generalFunction.dart';
import '../../complaints/complaintHomePage.dart';
import '../../resources/app_text_style.dart';
import 'licenseRequest/licenseRequest.dart';
import 'licenseStatus/licenseStatus.dart';
import 'onlinelicense/onlineLicense.dart';


class License extends StatefulWidget {

  final name;
  License({super.key, this.name});

  @override
  State<License> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<License> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String,dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo,sCitizenName;

  var OnlineTitle = [
    "License Request",
    "Online License",
    "License Status",
  ];

  final List<Color> borderColors =
  [
    Colors.red,
    Colors.blue,
    Colors.green,
  ];

  Color getRandomBorderColor() {
    final random = Random();
    return borderColors[random.nextInt(borderColors.length)];
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocatdata();
    super.initState();
  }

  getLocatdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sCitizenName = prefs.getString('sCitizenName');
    sContactNo = prefs.getString('sContactNo');
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
            );
          },
          child: Icon(Icons.arrow_back_ios,
            color: Colors.white,),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'License',
            style: TextStyle(
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
      ),
      drawer:
      generalFunction.drawerFunction(context, '$sCitizenName', '$sContactNo'),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // middleHeader(context, '${widget.name}'),
          Container(
            height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: OnlineTitle?.length ?? 0,
              itemBuilder: (context, index) {
                final color = borderColors[index % borderColors.length];
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: GestureDetector(
                        onTap: () {
                          var title = OnlineTitle[index];
                          // sIcon
                          if(title=="Online License"){
                            //  PropertyTax
                            var name = "Online License";

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Onlinelicense(name:name)),
                            );

                            //print('------209---Property Tax');
                          }else if(title=="License Status"){
                            //   BuildingPlan
                            // print('------211---Building Plan');
                            //  LicenseStatus
                            var name ="License Status";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LicenseStatus(name:name)),
                            );
                          }else{
                            var name = "License Request";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LicenseRequest(name:name)),
                            );
                          }
                        },
                        child: ListTile(
                          leading: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: color, // Set the dynamic color
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(Icons.ac_unit,
                                color: Colors.white,
                              )
                          ),
                          title: Text(
                            //emergencyTitleList![index]['sHeadName']!,
                            // "Property Tax",
                            OnlineTitle[index],
                            style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/arrow.png',
                                height: 12,
                                width: 12,
                                color: color,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Container(
                        height: 1,
                        color: Colors.grey, // Gray color for the bottom line
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

