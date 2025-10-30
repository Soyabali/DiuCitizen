
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:puri/presentation/onlineService/propertyAssessment/property_AssessmentHome.dart';
import 'package:puri/presentation/onlineService/propertyMutation/propertyMutation.dart';
import 'package:puri/presentation/onlineService/propertyTax/propertyTax.dart';
import 'package:puri/presentation/onlineService/waterSupply/waterSupply.dart';
import '../../app/generalFunction.dart';
import '../../services/getEmergencyContactTitleRepo.dart';
import '../aboutDiu/Aboutdiupage.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';
import 'buildingPlan/buildingPlan.dart';
import 'communityHall/communityHall.dart';
import 'license/license.dart';


class OnlineServives extends StatefulWidget {

  final name;
  OnlineServives({super.key, this.name});

  @override
  State<OnlineServives> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<OnlineServives> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String,dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse() async {
    emergencyTitleList = await GetEmergencyContactTitleRepo().getEmergencyContactTitle(context);
    print('------34----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }


  final List<Map<String, dynamic>> itemList2 = [
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'ICICI BANK CC PAYMENT',
      'subtitle': 'Utility & Bill Payments',
      'transactions': '1 transaction',
      'amount': ' 7,86,698',
      'temple': 'Fire Emergency'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'APTRONIX',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 1,69,800',
      'temple': 'Police'
    },
    {
      //'leadingIcon': Icons.account_box,
      'leadingIcon': 'assets/images/shopping-bag2.png',
      'title': 'MICROSOFT INDIA',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 30,752',
      'temple': 'Women Help'
    },
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'SARVODAYA HOSPITAL U O',
      'subtitle': 'Medical',
      'transactions': '1 transaction',
      'amount': '@ 27,556',
      'temple': 'Medical Emergency'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'MOHAMMED ZUBER',
      'subtitle': 'UPI Payment',
      'transactions': '1 transaction',
      'amount': '@ 25,000',
      'temple': 'Other Important Numbers'
    },
  ];
  var OnlineTitle = [
    "Property Tax",
    // "Building Plan",
    "Property Assessment",
    "License",
    "Community Hall",
    "Property Transfer",
    "Water Supply",
    // "Electricity Bill",
    // "Mamlatdar Diu",
    // "Collectorate Diu",
    // "E-Procurement"
  ];
  // "Water Supply",
  // "Electricity Bill",
  // "Mamlatdar Diu"

  final List<Color> borderColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
  ];

  Color getRandomBorderColor() {
    final random = Random();
    return borderColors[random.nextInt(borderColors.length)];
  }

  @override
  void initState() {
    // TODO: implement initState
    getEmergencyTitleResponse();
    super.initState();
  }

  @override
  void dispose() {
    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
              // );
            },
            child: Icon(Icons.arrow_back_ios,
              color: Colors.white,),
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Online Services',
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
        //appBar: getAppBarBack(context, '${widget.name}'),

        // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),

        body:
        isLoading
            ? buildShimmerList()
            : (OnlineTitle == null || OnlineTitle!.isEmpty)
            ? NoDataScreenPage()
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // middleHeader(context, '${widget.name}'),
            Container(
              height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
              child: ListView.builder(
                shrinkWrap: true,
                // itemCount: emergencyTitleList?.length ?? 0,
                itemCount: OnlineTitle?.length ?? 0,
                itemBuilder: (context, index) {
                  final color = borderColors[index % borderColors.length];
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: GestureDetector(
                          onTap: () {
                            // var name = emergencyTitleList![index]['sHeadName'];
                            // var iHeadCode = emergencyTitleList![index]['iHeadCode'];
                            // var sIcon = emergencyTitleList![index]['sIcon'];

                            var title = OnlineTitle[index];
                            // sIcon
                            print('----title---207---$title');
                            if(title=="Property Tax"){
                              //  PropertyTax
                              var name = "Property Tax";

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PropertyTaxDiu(name:name)),
                              );

                              //print('------209---Property Tax');
                            }else if(title=="Building Plan"){
                              //   BuildingPlan
                              // print('------211---Building Plan');
                              var name ="Building Plan";
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BuildingPlan(name:name)),
                              );
                            }else if(title=="Property Assessment"){
                              // PropertyAssessment
                              var sName = "Property Assessment";
                              //  PropertyAssessmentHome
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => PropertyAssessment(name:sName)),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PropertyAssessmentHome(name:sName)),
                              );

                              print('------213---Property Assessment');
                            }else if(title=="License"){

                              print('------215---License');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => License()),
                              );

                            }else if(title=="Community Hall"){
                              print('------217---Community Hall');
                              // CommunityHall
                              var sName = "Community Hall";
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CommunityHall(name:sName)),
                              );
                            }else if(title=="Water Supply"){
                              // WaterSupply
                              var sName = "Water Supply";
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WaterSupply(name:sName)),
                              );

                            }else if(title=="Electricity Bill"){
                              print("-------221--Electricity Bill--");
                              var sPageName = "Electricity Bill";
                              var sPageLink = "https://connect.torrentpower.com/tplcp/index.php/crCustmast/quickpay";

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AboutDiuPage(name:sPageName,sPageLink:sPageLink)),
                              );

                            }else if(title=="Mamlatdar Diu") {
                              print("-------223--Mamlatdar Diu--");
                              var sPageName = "Mamlatdar Diu";
                              var sPageLink = "https://sugam.dddgov.in/mamlatdar-diu";
                              // AboutDiuPage(name:sPageName,sPageLink:sPageLink);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    AboutDiuPage(
                                        name: sPageName, sPageLink: sPageLink)),
                              );
                            }
                            //  PropertyMutation
                            else if(title=="Collectorate Diu"){
                              var sPageName = "Collectorate Diu";
                              var sPageLink = "https://swp.dddgov.in/collectorate-dnhdd";
                              // AboutDiuPage(name:sPageName,sPageLink:sPageLink);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    AboutDiuPage(
                                        name: sPageName, sPageLink: sPageLink)),
                              );
                            }
                            else if(title=="Property Transfer"){
                              var sPageName = "Property Transfer";

                              print('---316----$sPageName');

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PropertyMutation(name:sPageName)),
                              );
                            }
                            else if(title=="E-Procurement"){
                              var eProcurement="E-Procurement";
                              print("-----320---$eProcurement");
                              var sPageName = "E-Procurement";
                              var sPageLink = "https://ddtenders.gov.in/nicgep/app";
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    AboutDiuPage(
                                        name: sPageName, sPageLink: sPageLink)),
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

      ),
    );
  }
}