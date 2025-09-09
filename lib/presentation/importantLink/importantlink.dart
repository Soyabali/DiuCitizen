
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/generalFunction.dart';
import '../aboutDiu/Aboutdiupage.dart';
import '../birth_death/birthanddeath.dart';
import '../resources/app_text_style.dart';

class Importantlink extends StatefulWidget {

  final name;
  Importantlink({super.key, this.name});

  @override
  State<Importantlink> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<Importantlink> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String, dynamic>>? emergencyTitleList;

  bool isLoading = true; // logic
  String? sName, sContactNo;


  final List<Map<String, dynamic>> itemList2 = [
    {
      'title': 'Birth & Death Certificate',
    },
    {
      'title': 'Collectorate Diu',
    },
    {
      'title': 'Electricity Bill',
    },
    {
      'title': 'E-Procurement',
    },
    {
      'title': 'Mamlatdar Diu',
    },
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF12375e),
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          backgroundColor: Color(0xFF255898),
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              print("------back---");
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios,
              color: Colors.white,),
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Important Link',
              style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
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
                itemCount: itemList2?.length ?? 0,
                itemBuilder: (context, index) {
                  final color = borderColors[index % borderColors.length];
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: GestureDetector(
                          onTap: () {
                            var title = itemList2![index]['title'];
                            if(title=="Birth & Death Certificate"){
                             // BirthAndDeathCertificate
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BirthAndDeathCertificate(name: "Birth & Death Certificate")),
                              );
                              return;
                            }else if(title=="Collectorate Diu"){

                              var sPageName = "Collectorate Diu";
                              var sPageLink = "https://swp.dddgov.in/collectorate-dnhdd";
                              // AboutDiuPage(name:sPageName,sPageLink:sPageLink);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    AboutDiuPage(
                                        name: sPageName, sPageLink: sPageLink)),
                              );
                              return;
                            }else if(title=="Electricity Bill")
                            {
                               print("-------221--Electricity Bill--");
                              var sPageName = "Electricity Bill";
                              var sPageLink = "https://connect.torrentpower.com/tplcp/index.php/crCustmast/quickpay";

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AboutDiuPage(name:sPageName,sPageLink:sPageLink)),
                              );
                              return;
                            }else if(title=="E-Procurement"){
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
                              return;
                            }else{
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
                            },
                          child: ListTile(
                            // leading Icon
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
                            // Title
                            title: Text(
                              itemList2[index]['title']!,
                              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                            ),
                            //  traling icon
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                    'assets/images/arrow.png',
                                    height: 12,
                                    width: 12,
                                    color: color
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

