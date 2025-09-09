
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puri/presentation/onlineService/waterSupply/waterSupplyRequest.dart';
import 'package:puri/presentation/onlineService/waterSupply/waterSupplyStatus.dart';
import '../../../app/generalFunction.dart';
import '../../resources/app_text_style.dart';
import 'onlineWaterSupply.dart';


class WaterSupply extends StatefulWidget {

  final name;

  WaterSupply({super.key, this.name});

  @override
  State<WaterSupply> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<WaterSupply> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String,dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  // GeneralFunction generalFunction = GeneralFunction();

  var OnlineTitle = [
    "Water Supply Request",
    "Online Water Supply",
    "Water Supply Status"
  ];


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
   // getEmergencyTitleResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          },
          child: const Icon(Icons.arrow_back_ios,
            color: Colors.white,),
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Water Supply',
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

      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
                          if(title=="Water Supply Request"){
                            //  PropertyTax
                            var name = "Water Supply Request";

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WaterSupplyRequest(name:name)),
                            );

                            //print('------209---Property Tax');
                          // }else if(title=="Building Plan"){
                          //   //   BuildingPlan
                          //   // print('------211---Building Plan');
                          //   var name ="Building Plan";
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => BuildingPlan(name:name)),
                          //   );
                          // }else if(title=="Property Assessment"){
                          //   // PropertyAssessment
                          //   var sName = "Property Assessment";
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => PropertyAssessment(name:sName,iCategoryCode:"")),
                          //   );
                          //   print('------213---Property Assessment');
                          // }else if(title=="License"){
                          //
                          //   print('------215---License');
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => License()),
                          //   );
                          //
                          // }else if(title=="Community Hall"){
                          //   print('------217---Community Hall');
                          //   // CommunityHall
                          //   var sName = "Community Hall";
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => CommunityHall(name:sName)),
                          //   );
                          // }else if(title=="Water Supply"){
                          //   print('------219---Water Supply');
                          //   var sName = "Water Supply";
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => CommunityHall(name:sName)),
                          //   );
                          //
                          // }else if(title=="Electricity Bill"){
                          //   print("-------221--Electricity Bill--");
                          //   var sPageName = "Electricity Bill";
                          //   var sPageLink = "https://connect.torrentpower.com/tplcp/index.php/crCustmast/quickpay";
                          //
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => AboutDiuPage(name:sPageName,sPageLink:sPageLink)),
                          //   );

                          }else if(title=="Online Water Supply") {

                            var name = "Online Water Supply";
                            var sPageLink = "https://sugam.dddgov.in/mamlatdar-diu";
                            // AboutDiuPage(name:sPageName,sPageLink:sPageLink);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OnlineWaterSupply(name:name)),
                              );
                          }else{
                            //  WaterSupplyStatus
                            var name = "Water Supply Status";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WaterSupplyStatus(name:name)),
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

