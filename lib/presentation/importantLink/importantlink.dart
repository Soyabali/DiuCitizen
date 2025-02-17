
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../app/generalFunction.dart';
import '../../services/bindComplaintCategoryRepo.dart';
import '../aboutDiu/Aboutdiupage.dart';
import '../birth_death/birthanddeath.dart';
import '../complaints/complaintHomePage.dart';
import '../resources/app_text_style.dart';
import '../nodatavalue/NoDataValue.dart';


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
  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse() async {
    emergencyTitleList = await BindComplaintCategoryRepo().bindComplaintCategory(context);
    print('------31----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }


  final List<Map<String, dynamic>> itemList2 = [
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'Birth & Death Certificate',
      'subtitle': 'Utility & Bill Payments',
      'transactions': '1 transaction',
      'amount': ' 7,86,698',
      'temple': 'Fire Emergency'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'Collectorate Diu',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 1,69,800',
      'temple': 'Police'
    },
    {
      //'leadingIcon': Icons.account_box,
      'leadingIcon': 'assets/images/shopping-bag2.png',
      'title': 'Electricity Bill',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 30,752',
      'temple': 'Women Help'
    },
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'E-Procurement',
      'subtitle': 'Medical',
      'transactions': '1 transaction',
      'amount': '@ 27,556',
      'temple': 'Medical Emergency'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'Mamlatdar Diu',
      'subtitle': 'UPI Payment',
      'transactions': '1 transaction',
      'amount': '@ 25,000',
      'temple': 'Other Important Numbers'
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
          backgroundColor: Color(0xFF255898),
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              print("------back---");
              Navigator.pop(context);
              //  Navigator.push(
              //    context,
              //    MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
              //  );
            },
            child: Icon(Icons.arrow_back_ios,
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
        //appBar: getAppBarBack(context, '${widget.name}'),
        // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body: isLoading
            ? Center(child: Container())
            : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
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
                              print("----Collectroate Diu---");
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
                              print('----Electricity Bill---');
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

                              print("----E- Procurement---");
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

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         OnlineComplaintForm(name:sCategoryName,iCategoryCode:iCategoryCode),
                            //   ),
                            // );

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
                              itemList2![index]['title']!,
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

