
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/generalFunction.dart';
import '../../resources/app_text_style.dart';
import 'communityHallStatus.dart';
import 'communityhallRequest.dart';


class CommunityHall extends StatefulWidget {

  final name;
  CommunityHall({super.key, this.name});

  @override
  State<CommunityHall> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<CommunityHall> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String,dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic

  var OnlineTitle = [
    "Community Hall Request",
    "Community Hall Status",
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
  void dispose() {
    super.dispose();
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
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '${widget.name}',
            style: const TextStyle(
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
                          if(title=="Community Hall Request"){
                            var name = "Community Hall Request";
                            var iCategoryCode ="3";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CommunityHallRequest(name:name,iCategoryCode:iCategoryCode)),
                            );
                            // BuildingPlanStatus
                          }else{
                            var name = "Community Hall Status";
                            var iCategoryCode ="3";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CommunityHallStatus(name:name)),
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

