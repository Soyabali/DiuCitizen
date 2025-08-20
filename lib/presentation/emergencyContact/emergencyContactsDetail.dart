import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import '../../../app/generalFunction.dart';
import '../../model/emergencyListModel.dart';
import '../../services/employeeList.dart';
import '../../services/getEmergencyContactListRepo.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';
import 'emergencyContact.dart';

class EmergencyListPage extends StatefulWidget {
  var name, iHeadCode;

  EmergencyListPage({super.key, required this.name, required this.iHeadCode});

  @override
  State<EmergencyListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EmergencyListPage> {

  List<Map<String, dynamic>>? reimbursementStatusList;

  TextEditingController _searchController = TextEditingController();
  double? lat;
  double? long;
  GeneralFunction generalfunction = GeneralFunction();

  DateTime? _date;

  List stateList = [];
  List hrmsReimbursementList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;
  List<Map<String, dynamic>>? emergencyList;
  bool isLoading = true;
  String? sName, sContactNo;

  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyListResponse(String headCode) async {
    emergencyList =
        await GetEmergencyContactListRepo().getEmergencyContactList(context,headCode);
    print('------48--xxxxxxxx--$emergencyList');
    setState(() {
      isLoading = false;
    });
  }

  late Future<List<EmployeeListModel>> reimbursementStatusV3;
  List<EmployeeListModel> _allData = []; // Holds original data
  List<EmployeeListModel> _filteredData = []; // Holds filtered data

  // Distic List
  hrmsReimbursementStatus() async {
    reimbursementStatusV3 = StaffListRepo().staffList(context);

    reimbursementStatusV3.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
  }

  // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allData; // Show all data if search query is empty
      } else {
        _filteredData = _allData.where((item) {
          return item.sEmpName
                  .toLowerCase()
                  .contains(query.toLowerCase()) || // Filter by project name
              item.sDsgName.toLowerCase().contains(query.toLowerCase()) ||
              item.sContactNo.toLowerCase().contains(query.toLowerCase());
          // Filter by employee name
        }).toList();
      }
    });
  }

  // postImage

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();
  String? todayDate;

  List? data;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final sectorFocus = GlobalKey();
  File? _imageFile;
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  String? firstOfMonthDay;
  String? lastDayOfCurrentMonth;
  var fromPicker;
  var toPicker;
  var sTranCode;
  Color? containerColor;
  String? status;
  String? tempDate;
  String? formDate;
  String? toDate;

  // toast
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // InitState

  @override
  void initState() {
    //hrmsReimbursementStatus();
    var headCode = "${widget.iHeadCode}";
    print("----136----xxxxxxxxx-----$headCode");
    getEmergencyListResponse(headCode);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
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
                  print("------back---");
                  //Navigator.pop(context);
                  Navigator.pop(context);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => EmergencyContacts()),
                  // );
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
                ? Center(child: Container())
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

  // Opend Full Screen DialogbOX
  void openFullScreenDialog(
      BuildContext context, String imageUrl, String billDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Makes the dialog full screen
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: [
              // Fullscreen Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Adjust the image to fill the dialog
                ),
              ),

              // White container with Bill Date at the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          billDate,
                          style:
                              AppTextStyle.font12OpenSansRegularBlackTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Close button in the bottom-right corner
              Positioned(
                right: 16,
                bottom: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    padding: EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
