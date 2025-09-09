
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puri/presentation/onlineService/propertyAssessment/propertyAssessment.dart';
import 'package:puri/presentation/onlineService/propertyAssessment/propertyAssessmentStatus.dart';
import '../../resources/app_text_style.dart';

class PropertyAssessmentHome extends StatefulWidget {

  final name;
  PropertyAssessmentHome({super.key, this.name});

  @override
  State<PropertyAssessmentHome> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<PropertyAssessmentHome> {

  var OnlineTitle = [
    "Property Assessment Request",
    "Property Assessment Status",
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

  @override
  void initState() {
    // TODO: implement initState
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
            // );
          },
          child: Icon(Icons.arrow_back_ios,
            color: Colors.white,),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '${widget.name}',
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
          // middleHeader(context, '${widget.name}'),
          Container(
            height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: OnlineTitle.length ?? 0,
              itemBuilder: (context, index) {
                final color = borderColors[index % borderColors.length];
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: GestureDetector(
                        onTap: () {
                          var title = OnlineTitle[index];
                          if(title=="Property Assessment Request"){
                            //  PropertyTax
                            var name = "Property Assessment Request";
                            /// todo here open a new activity

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PropertyAssessment(name:name)),
                            );
                          }else{
                            var name = "Property Assessment Status";
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PropertyAssessmentStatus(name:name)),
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

