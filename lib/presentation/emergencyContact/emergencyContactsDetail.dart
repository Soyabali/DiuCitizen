import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/generalFunction.dart';
import '../../services/getEmergencyContactListRepo.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';


class EmergencyListPage extends StatefulWidget {
  var name, iHeadCode;

  EmergencyListPage({super.key, required this.name, required this.iHeadCode});

  @override
  State<EmergencyListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmergencyListPage> {

  List<Map<String, dynamic>>? reimbursementStatusList;
  List<Map<String, dynamic>>? emergencyList;
  bool isLoading = true;

  getEmergencyListResponse(String headCode) async {
    emergencyList =
        await GetEmergencyContactListRepo().getEmergencyContactList(context,headCode);
    print('------48--xxxxxxxx--$emergencyList');
    setState(() {
      isLoading = false;
    });
  }
  var msg;

  @override
  void initState() {
    super.initState();
    var headCode = "${widget.iHeadCode}";
    getEmergencyListResponse(headCode);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
            isLoading
                ? buildShimmerList()
                : (emergencyList == null || emergencyList!.isEmpty)
                ? NoDataScreenPage()
                :
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: emergencyList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 1,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Consistent border radius
                              side: const BorderSide(
                                color: Colors.grey, // Border color
                                width: 0.2,         // Border width
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0), // Padding inside the card
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // change a image
                                      GestureDetector(
                                        onTap: () {
                                          // Handle image tap
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            color: Colors.grey, // Fallback color if image doesn't load
                                            child: Image.network(
                                              emergencyList![index]['sImageUrl']!, // Path to your asset image
                                              fit: BoxFit.cover, // Ensures the image fills the circle properly
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              emergencyList![index]['sName']!,
                                              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Designation : ",
                                                  style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  emergencyList![index]['sDesignation']!,
                                                  style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Color(0xFF255898),
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Contact No : ",
                                              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              emergencyList![index]['sContactNo']!,
                                              style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            var sEmpName = "${emergencyList![index]['sName']!}";
                                            var sContactNo = "${emergencyList![index]['sContactNo']!}";
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return buildDialogCall(context, sEmpName, sContactNo);
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF255898),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            'Call',
                                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        ))
              ],
            ),
          ),
        ));
  }
}
