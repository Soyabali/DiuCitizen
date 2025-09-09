
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/generalFunction.dart';
import '../../services/aboutdiuRepo.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';
import 'Aboutdiupage.dart';


class AboutDiu extends StatefulWidget {
  final name;

  AboutDiu({super.key, this.name});

  @override
  State<AboutDiu> createState() => _AboutDiuState();
}

class _AboutDiuState extends State<AboutDiu> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse() async {
    emergencyTitleList = await AboutDiuRepo().aboutdiu(context);
    print('------31----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }

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

  // Color getRandomBorderColor() {
  //   final random = Random();
  //   return borderColors[random.nextInt(borderColors.length)];
  // }

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
              'About Diu',
              style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          elevation: 0, // Removes shadow under the AppBar
        ),

        body:
        isLoading
            ? Center(child: Container())
            : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
            ? NoDataScreenPage()
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                            var sPageName = emergencyTitleList![index]['sPageName'];
                            var sPageLink = emergencyTitleList![index]['sPageLink'];

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AboutDiuPage(name:sPageName,sPageLink:sPageLink),
                                ));

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
                              emergencyTitleList![index]['sPageName']!,
                              style: AppTextStyle
                                  .font14OpenSansRegularBlack45TextStyle,
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

