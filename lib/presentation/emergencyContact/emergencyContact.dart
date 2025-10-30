import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/generalFunction.dart';
import '../../services/getEmergencyContactTitleRepo.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';
import 'emergencyContactsDetail.dart';

class EmergencyContacts extends StatefulWidget {
  final name;

  EmergencyContacts({super.key, this.name});

  @override
  State<EmergencyContacts> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<EmergencyContacts> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true;
  String? sName, sContactNo;
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

  getEmergencyTitleResponse() async {
    emergencyTitleList = await GetEmergencyContactTitleRepo().getEmergencyContactTitle(context);
    print('------31----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }


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
    super.dispose();
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
          // backgroundColor: Colors.blu
          centerTitle: true,
          backgroundColor: Color(0xFF255898),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios,
              color: Colors.white,),
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Department List',
              style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          //centerTitle: true,
          elevation: 0, // Removes shadow under the AppBar
        ),
        body:
        isLoading
            ? buildShimmerList()
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
                          itemCount: emergencyTitleList?.length ?? 0,
                          itemBuilder: (context, index) {
                         final color = borderColors[index % borderColors.length];
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      var sHeadName = emergencyTitleList![index]['sHeadName'];
                                      var iHeadCode = emergencyTitleList![index]['iHeadCode'];
                                    //
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EmergencyListPage(name:sHeadName,iHeadCode:iHeadCode)
                                             // FireEmergency(name: name,iHeadCode:iHeadCode,sIcon:sIcon),
                                        ),
                                      );
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
                                        emergencyTitleList![index]['sHeadName']!,
                                        style: AppTextStyle.font14OpenSansRegularBlackTextStyle,

                                      ),
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
                                    color: Colors
                                        .grey, // Gray color for the bottom line
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

