import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/generalFunction.dart';
import '../../../../services/BindCommunityHallDateRepo.dart';
import '../../../../services/BindDocumentTypeRepo.dart';
import '../../../../services/bindSubCategoryRepo.dart';
import '../../../../services/postLicenseRequest.dart';
import '../../services/BindModeOfAdvertismentRepo.dart';
import '../../services/PostAdvertisementRequestRepo.dart';
import '../circle/circle.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';

class BookAdvertisement extends StatefulWidget {

  var name, iCategoryCode;
  var name2, iCategoryCode2;
  var name3, iCategoryCode3;

  BookAdvertisement({super.key, required this.name});

  @override
  State<BookAdvertisement> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BookAdvertisement> with TickerProviderStateMixin {

  List stateList = [];
  List<dynamic> subCategoryList = [];

  //List<dynamic> bindcommunityHallDate = [];
  List<Map<String, dynamic>> bindcommunityHallDate = [];
  List<dynamic> premisesWardDropDown = [];
  List<dynamic> finalYearDropDown = [];
  List<dynamic> bindTradeCategory = [];
  List<dynamic> bindTradeSubCategory = [];
  List<dynamic> bindreimouList = [];
  List<dynamic> bindDocumentTypeList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  bool isFormVisible = true; // Track the visibility of the form
  bool isIconRotated = false;
  bool isFormVisible2 = true; // Track the visibility of the form
  bool isIconRotated2 = false;
  bool isFormVisible3 = true; // Track the visibility of the form
  bool isIconRotated3 = false;
  bool isFormVisible4 = true; // Track the visibility of the form
  bool isIconRotated4 = false;

  final _formKey = GlobalKey<FormState>();

  bindSubCategory(String subCategoryCode) async {
    subCategoryList = (await BindSubCategoryRepo().bindSubCategory(context, subCategoryCode))!;
    print(" -----xxxxx-  subCategoryList--43---> $subCategoryList");
    setState(() {});
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _premisesNameController = TextEditingController();
  TextEditingController _premisesAddressController = TextEditingController();
  TextEditingController _applicationNameController = TextEditingController();
  TextEditingController _applicationMobileController = TextEditingController();
  TextEditingController _applicationAddressController = TextEditingController();
  TextEditingController _advertisementUnitController = TextEditingController();
  TextEditingController _advertisementAmountTypeController = TextEditingController();
  TextEditingController _advertisementAmountController = TextEditingController();
  TextEditingController _sizeOfAdvertisementController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _contentTypeController = TextEditingController();
  TextEditingController _contenDescriptionController = TextEditingController();
  TextEditingController _advertisementAddressController = TextEditingController();

  FocusNode _premisesNamefocus = FocusNode();
  FocusNode _premisesAddressfocus = FocusNode();
  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMobilefocus = FocusNode();
  FocusNode _applicationAddressfocus = FocusNode();
  FocusNode _advertisementUnitfocus = FocusNode();
  FocusNode _sizeOfAdvertisementfocus = FocusNode();
  FocusNode _daysfocus = FocusNode();
  FocusNode _totalAmountfocus = FocusNode();
  FocusNode _contentTypefocus = FocusNode();
  FocusNode _contentDescriptionfocus = FocusNode();
  FocusNode _advertisementAddressfocus = FocusNode();
  var sUploadBuildingPlanPath;
  var sUploadSupportingDocPath;

  String? todayDate;
  String? consumableList;
  int count = 0;
  List? data;
  List? listCon;
  int selectedIndex = -1;

  //var _dropDownSector;
  var dropDownSubCategory;
  var _dropDownPremisesWard;
  var _dropDownFinalYear;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final subCategoryFocus = GlobalKey();
  final wardFocus = GlobalKey();
  var _dropDownPremisesWardCode;
  var _dropDownfAmount;
  var _dropDownsAdvertisementUnit;
  var _dropDownsAdvertisementAmountType;
  var _dropDowniAdSpaceCode;



  var _dropDownFinalYearCode;
  var _selectedRatePerDay;
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;
  double? lat, long;
  List<String> selectedDates = []; // List to store selected dates

  bool isSuccess = false;
  bool isLoading = false;
  var iCommunityHallName;
  var firstStatus;
  File? image2;
  var _fromDate;
  var _toDate;
  DateTime? _fromDateValue;
  DateTime? _toDateValue;
  List<bool> selectedStates = [];
  Set<int> selectedIndices = {}; // To track selected items by index
  List<dynamic>? consuambleItemList = [];

  // firstPage secondPage and ThirdPage

  bool isFirstFormVisible = true;
  bool isSecondFormVisible = false;
  bool isThirdFormVisible = false;

  bool isFirstIconRotated = false;
  bool isSecondIconRotated = false;
  bool isThirdIconRotated = false;

  String? dropdownValue;
  final List<File> _imageFiles = []; // To store selected images
  final List<String> _imageUrls = [];
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> firstFormCombinedList = [];
  List<Map<String, dynamic>> secondFormCombinedList = [];
  List<Map<String, dynamic>> thirdFormCombinedList = [];
  List<Map<String, dynamic>> _imageFiles2 = [];
  var secondFromjson;
  var thirdFromJsonData;
  num totalamout=0;

  get selectedMonthCode => null;
  var sizeOfAdvertisementValue;
  var totalAmountValue;
  String? sCreatedBy;

  // set image function


  // permises Ward Api call
  bindModeOfAdvertisement() async {
    /// todo remove the comment and call Community Hall
    premisesWardDropDown = await BindModeOfAdvertismenttRepo().bindMondOfAdvertisemet();
    print(" -----Premissesward---->>>>-xx--181-----> $premisesWardDropDown");
    setState(() {});
  }

  // Bind Supporting Documents
  bindSupportingDocumentApi() async {
    /// todo remove the comment and call Community Hall
    bindDocumentTypeList = await BindDocumentTypeRepo().bindDocumentyType();
    print(
        " -----bindDocumnent Repo---->>>>-xx--154-----> $bindDocumentTypeList");
    setState(() {});
  }

  // DropdownButton Ward
  Widget _bindPremisesWard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 42,
          color: Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true,
                // Reduces the vertical size of the button
                isExpanded: true,
                // Allows the DropdownButton to take full width
                dropdownColor: Colors.white,
                // Set dropdown list background color
                onTap: () {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
                hint: RichText(
                  text: TextSpan(
                    text: "Select Advertisement Place Type",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownPremisesWard,
                onChanged: (newValue) {
                  setState(() {
                    // clear all TextFields
                    _sizeOfAdvertisementController.clear();
                    _daysController.clear();
                    _totalAmountController.clear();

                    _dropDownPremisesWard = newValue;
                    premisesWardDropDown.forEach((element) {
                      if (element["sAdSpacePlace"] == _dropDownPremisesWard) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownfAmount = element['fAmount'];
                        _dropDownsAdvertisementUnit = element['sAdvertisementUnit'];
                        _dropDownsAdvertisementAmountType = element['sAdvertisementAmountType'];
                        _dropDowniAdSpaceCode = element['iAdSpaceCode'];
                        // to fill these value into TextFormField
                        _advertisementUnitController.text=_dropDownsAdvertisementUnit;
                        _advertisementAmountTypeController.text=_dropDownsAdvertisementAmountType;
                        _advertisementAmountController.text = _dropDownfAmount.toString();

                      }
                    });
                    if (_dropDownfAmount != null) {
                      /// remove the comment
                      setState(() {
                        // call a api if needs
                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                    }
                    print("------157---Amount----$_dropDownfAmount");
                    print("------157---AdverTisement----$_dropDownsAdvertisementUnit");
                    print("------157---AmountType----$_dropDownsAdvertisementAmountType");

                  });
                },

                items: premisesWardDropDown.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sAdSpacePlace"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sAdSpacePlace'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle
                                .font14OpenSansRegularBlack45TextStyle,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> bindCommunityHallDate(var hallId) async {
    setState(() {
      isLoading = true; // Start the progress bar
    });

    try {
      bindcommunityHallDate = await BindCommunityHallDateRepo()
          .bindCommunityHallDate(context, hallId, selectedMonthCode);
      print('-----232---->>>>---$bindcommunityHallDate');
      // If the response is not empty or null, set isSuccess to true
      if (bindcommunityHallDate.isNotEmpty) {
        setState(() {
          isSuccess = true; // API call was successful
          isLoading = false; // Stop the progress bar
        });
      } else {
        setState(() {
          isSuccess = false; // No data found
          isLoading = false; // Stop the progress bar
        });
      }
    } catch (e) {
      setState(() {
        isSuccess = false; // If error occurs, mark as failed
        isLoading = false; // Stop the progress bar
      });
      // Handle error (you can show a toast or a Snackbar if needed)
      print('Error: $e');
    }
  }

  Widget buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(), // Show progress bar while loading
      );
    }

    if (isSuccess) {
      // Show the list if the data is fetched successfully
      return AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Visibility(
          visible: true, // Change as per your conditions
          child: Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (bindcommunityHallDate.length / 2).ceil(),
              itemBuilder: (context, index) {
                int firstIndex = index * 2;
                int secondIndex = firstIndex + 1;

                if (firstIndex >= bindcommunityHallDate.length)
                  return SizedBox.shrink(); // No item for firstIndex
                Map<String, dynamic> firstItem =
                    bindcommunityHallDate[firstIndex];

                // Determine color for the first date
                int firstStatus = firstItem['iStatus'];
                Color firstColor;
                if (firstStatus == 0) {
                  firstColor = Colors.blue;
                } else if (firstStatus == 1) {
                  firstColor = Colors.green;
                } else if (firstStatus == 2) {
                  firstColor = Colors.red;
                } else {
                  firstColor = Colors.grey;
                }

                Map<String, dynamic>? secondItem;
                Color? secondColor;
                if (secondIndex < bindcommunityHallDate.length) {
                  secondItem = bindcommunityHallDate[secondIndex];
                  int secondStatus = secondItem['iStatus'];
                  secondColor = (secondStatus == 0)
                      ? Colors.blue
                      : (secondStatus == 1)
                          ? Colors.green
                          : (secondStatus == 2)
                              ? Colors.red
                              : Colors.grey;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateTile(
                      firstItem['dDate'],
                      selectedStates[firstIndex],
                      firstColor,
                      () {
                        setState(() {
                          var status = firstItem['iStatus'];
                          if (status == 0 || status == 1) {
                            selectedStates[firstIndex] =
                                !selectedStates[firstIndex];
                            if (selectedStates[firstIndex]) {
                              selectedDates.add(firstItem['dDate']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Selected: ${firstItem['dDate']}")),
                              );
                            } else {
                              selectedDates.remove(firstItem['dDate']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Deselected: ${firstItem['dDate']}")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Booked already")),
                            );
                          }
                        });
                      },
                    ),
                    if (secondItem != null)
                      _buildDateTile(
                        secondItem['dDate'],
                        selectedStates[secondIndex],
                        secondColor!,
                        () {
                          setState(() {
                            var status = secondItem?['iStatus'];
                            if (status == 0 || status == 1) {
                              selectedStates[secondIndex] =
                                  !selectedStates[secondIndex];
                              if (selectedStates[secondIndex]) {
                                selectedDates.add(secondItem?['dDate']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Selected: ${secondItem?['dDate']}")),
                                );
                              } else {
                                selectedDates.remove(secondItem?['dDate']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Deselected: ${secondItem?['dDate']}")),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Booked already")),
                              );
                            }
                          });
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text(
          "No Data Available ",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }
  }

  @override
  void initState() {
    bindModeOfAdvertisement();
    //bindSupportingDocumentApi();
    getSaveValue();
    super.initState();
    _premisesNamefocus = FocusNode();
    _premisesAddressfocus = FocusNode();
    _applicationNamefocus = FocusNode();
    _applicationMobilefocus = FocusNode();
    _applicationAddressfocus = FocusNode();
    _advertisementUnitfocus = FocusNode();
    _sizeOfAdvertisementfocus = FocusNode();
    _daysfocus = FocusNode();
    _totalAmountfocus=FocusNode();
    _contentTypefocus= FocusNode();
    _contentDescriptionfocus=FocusNode();
    _advertisementAddressfocus=FocusNode();


    if (bindcommunityHallDate.isNotEmpty) {
      selectedStates = List.generate(bindcommunityHallDate.length, (index) => false);
    }
  }
  getSaveValue()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sContactNo = prefs.getString('sContactNo');
    var sCitizenName = prefs.getString('sCitizenName');
    //set value on a TextFormField
    _applicationNameController.text=sCitizenName!;
    _applicationMobileController.text=sContactNo!;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _premisesNamefocus.dispose();
    _premisesAddressfocus.dispose();
    _applicationNamefocus.dispose();
    _applicationMobilefocus.dispose();
    _applicationAddressfocus.dispose();
    _advertisementUnitfocus.dispose();
    _sizeOfAdvertisementfocus.dispose();
    _daysfocus.dispose();
    _totalAmountfocus.dispose();
    _contentTypefocus.dispose();
    _contentDescriptionfocus.dispose();
    _advertisementAddressfocus.dispose();
    FocusScope.of(context).unfocus();
  }

  // Api call Function
  void validateAndCallApi() async {

    firstFormCombinedList = [];
    DateTime now = DateTime.now();
    // Format the date as yyyyMMddHHmmssSS
    String formattedDate = DateFormat('yyyyMMddHHmmssSS').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
     sCreatedBy = prefs.getString('sContactNo');
    // TextFormField values

    var premisesName = _premisesNameController.text.trim();
    var premisesAddress = _premisesAddressController.text.trim();
    // ------ first form is done  ----
    var applicationName = _applicationNameController.text.trim(); // Applicant Name
    var applicationMobileNo = _applicationMobileController.text.trim();// Applicant Moboile No.
    var applicationAddress = _applicationAddressController.text.trim();// _applicationAddressController
    // ------ first form is done  ----
    //----------Second Form is start-------
   // _dropDowniAdSpaceCode
    var advertisementUnit = _advertisementUnitController.text.trim();
    var advertisementAmountType = _advertisementAmountTypeController.text.trim();
    var advertisementAmount = _advertisementAmountController.text.trim();
    var sizeOfAdevertisement = _sizeOfAdvertisementController.text.trim();
    var days = _daysController.text.trim();
    var totalAmount = _totalAmountController.text.trim();
    var contentType = _contentTypeController.text.trim();
    var contentDescription = _contenDescriptionController.text.trim();
    var advertisementAddress = _advertisementAddressController.text.trim();
    // -----Third Form------
    //   _toDate
    //  _fromDate

    print('---Applicant Name ---$applicationName');
    print('---Applicant Mobile No ---$applicationMobileNo');
    print('---Applicant Address ---$applicationAddress');
    print('-------------Second form----Start---');
    print('---dropDowniAdSpaceCode ---$_dropDowniAdSpaceCode');
    print('---advertisementUnit---$advertisementUnit');
    print('---advertisementAmountType---$advertisementAmountType');
    print('---advertisementAmount---$advertisementAmount');
    print('---sizeOfAdevertisement---$sizeOfAdevertisement');
    print('---days---$days');
    print('---totalAmount---$totalAmount');
    print('---contentType---$contentType');
    print('---contentDescription---$contentDescription');
    print('---advertisementAddress---$advertisementAddress');
    print('-------------Second form----End---');
    print('---_fromDate---$_fromDate');
    print('---_toDate---$_toDate');

     //   _dropDowniAdSpaceCode != null
    if (applicationName.isNotEmpty &&
        applicationMobileNo.isNotEmpty &&
        applicationAddress.isNotEmpty &&
        _dropDowniAdSpaceCode !=null &&
        advertisementUnit.isNotEmpty &&
        advertisementAmountType.isNotEmpty &&
        advertisementAmount.isNotEmpty &&
        sizeOfAdevertisement.isNotEmpty &&
        days.isNotEmpty &&
        totalAmount.isNotEmpty &&
        contentType.isNotEmpty &&
        contentDescription.isNotEmpty &&
        advertisementAddress.isNotEmpty &&
        _fromDate !=null &&
        _toDate !=null

    ) {
      // All conditions met; call the API
      print('---Call API---');
      /// put these value into the list
      firstFormCombinedList.add({
        "sRequestNo":formattedDate,
        "sApplicantName": applicationName, // Applicant Name
        "sApplicantMobileNo": applicationMobileNo,
        "sApplicantAddress": applicationAddress,
         // "iAdSpaceTypeCode": _dropDowniAdSpaceCode,
        "iAdSpaceCode":_dropDowniAdSpaceCode,
        "sAdvSize": advertisementUnit,
        "sAdvAmountType": advertisementAmountType,
        "fAdvAmount": advertisementAmount,
        "sSizeOfAdv": sizeOfAdevertisement,
        "sDays": days,
        "fTotalAmount": totalAmount,
        "sContent": contentType,
        "sAdType":contentDescription,
        "sAdvAddress":advertisementAddress,
        "dFromDate":_fromDate,
        "dToDate":_toDate,
        "sPostedBy":sCreatedBy
      });
      // lIST to convert json string
      String allThreeFormJson = jsonEncode(firstFormCombinedList);
      print("----606---json response---$allThreeFormJson");
      // Call your API logic here
      var onlineComplaintResponse = await PostAdvertisementRequestRepo()
          .postAdvertisementRequest(context, allThreeFormJson);
      print('----610---$onlineComplaintResponse');
      result2 = onlineComplaintResponse['Result'];
      msg2 = onlineComplaintResponse['Msg'];
      if (result2 == "1") {
        displayToast(msg2);
        Navigator.pop(context);
      } else {
        displayToast(msg2);
      }
      // Call your API here
    } else {
      // If conditions fail, display appropriate error messages
      print('--Not Call API--');

      // if (_dropDownPremisesWard == null) {
      //   displayToast('Please Select Premises Ward');
      //   return;
      // }
      if (applicationName.isEmpty) {
        displayToast('Please Enter Applicant Name');
        return;
      }
      if (applicationMobileNo.isEmpty) {
        displayToast('Please Enter Mobile No');
        return;
      }
      if (applicationAddress.isEmpty) {
        displayToast('Please Enter Applicant Address');
      }
      if (_dropDowniAdSpaceCode == null) {
        displayToast('Please Select Advertisement Place Type');
        return;
      }

      if (advertisementUnit.isEmpty) {
        displayToast('Please Enter Advertisement Unit');
        return;
      }
      if (advertisementAmountType.isEmpty) {
        displayToast('Please Enter Advertisement Amount Type');
        return;
      }
      if (advertisementAmount.isEmpty) {
        displayToast('Please Enter Advertisement Amount');
        return;
      }
      if (sizeOfAdevertisement.isEmpty) {
        displayToast('Size Of Advertisement');
        return;
      }
      if (days.isEmpty) {
        displayToast('Please Enter days');
        return;
      }
      if (totalAmount.isEmpty) {
        displayToast('Please Enter Total Amount');
        return;
      }
      if (contentType.isEmpty) {
        displayToast('Please Enter Content Type');
        return;
      }
      if (contentDescription.isEmpty) {
        displayToast('Please Enter Content Description');
        return;
      }
      if (advertisementAddress.isEmpty) {
        displayToast('Please Enter Advertisement Address');
        return;
      }
      if (_fromDate == null) {
        displayToast('Please Pick a From Date');
        return;
      }
      if (_toDate == null) {
        displayToast('Please Pick a To Date');
        return;
      }
    }
  }

  Widget _buildDateTile(
      String dDate, bool isSelected, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          height: 40.0, // Fixed height
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20.0),
              right: Radius.circular(20.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show a check symbol if selected
              if (isSelected)
                Container(
                  width: 24.0, // Circle size
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.5), // Background color for circle
                    shape: BoxShape.circle, // Ensures the container is circular
                  ),
                  child: const Icon(
                    Icons.check, // Check symbol icon
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),
              if (isSelected)
                SizedBox(width: 8.0), // Space between icon and text
              // Always show the date text
              Text(
                dDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
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
                // appBar: getAppBarBack(context,"Online Complaint"),
                appBar: AppBar(
                  // statusBarColore
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Color(0xFF12375e),
                    statusBarIconBrightness: Brightness.dark,
                    // For Android (dark icons)
                    statusBarBrightness:
                        Brightness.light, // For iOS (dark icons)
                  ),
                  // backgroundColor: Colors.blu
                  centerTitle: true,
                  backgroundColor: Color(0xFF255898),
                  leading: GestureDetector(
                    onTap: () {
                      print("------back---");
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "Book Advertisement",
                      style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //centerTitle: true,
                  elevation: 0, // Removes shadow under the AppBar
                ),
                body: Stack(
                  children: [
                    // Scrollable ListView
                    ListView(
                      padding: EdgeInsets.only(bottom: 80),
                      // Prevent overlap with button
                      children: [
                        // First Section Header
                        _buildSectionHeader(
                          title: "1. Application Details",
                          isVisible: isFirstFormVisible,
                          isIconRotated: isFirstIconRotated,
                          onToggle: () {
                            setState(() {
                              isFirstFormVisible = !isFirstFormVisible;
                              isFirstIconRotated = !isFirstIconRotated;
                            });
                          },
                        ),
                        // First Form Content
                        if (isFirstFormVisible) _buildFirstForm(),
                        // Second Section Header
                        _buildSectionHeader(
                          title: "2. Advertisement Detail",
                          isVisible: isSecondFormVisible,
                          isIconRotated: isSecondIconRotated,
                          onToggle: () {
                            setState(() {
                              isSecondFormVisible = !isSecondFormVisible;
                              isSecondIconRotated = !isSecondIconRotated;
                            });
                          },
                        ),
                        // Second Form Content
                        if (isSecondFormVisible) _buildSecondForm(),

                        // Third Section Header
                        _buildSectionHeader(
                          title: "3. Other",
                          isVisible: isThirdFormVisible,
                          isIconRotated: isThirdIconRotated,
                          onToggle: () {
                            setState(() {
                              isThirdFormVisible = !isThirdFormVisible;
                              isThirdIconRotated = !isThirdIconRotated;
                            });
                          },
                        ),
                        // Third Form Content
                        if (isThirdFormVisible)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Card(
                                    elevation: 4, // Adjust the shadow level
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // Rounded corners for the card
                                    ),
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        // Inner padding for the container
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          // Background color for the container
                                          borderRadius: BorderRadius.circular(5),
                                          // Rounded corners for the container
                                          border: Border.all(color: Colors.grey, // Border color
                                            width: 1, // Border width
                                          ),
                                        ),
                                        child: Container(
                                          height: 80,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25, right: 25),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () async {
                                                    DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      // Set the current date as the initial date
                                                      firstDate: DateTime.now(),
                                                      // Prevent selection of past dates
                                                      lastDate: DateTime(2101), // Set the maximum selectable date
                                                    );

                                                    if (pickedDate != null) {
                                                      if (_toDateValue != null && pickedDate.isAfter(_toDateValue!)) {
                                                        // ❌ Invalid: From Date > To Date
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('From Date cannot be later than To Date')),
                                                        );
                                                      } else {
                                                        // ✅ Valid selection
                                                        String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                                        setState(() {
                                                          _fromDate = formattedDate;
                                                          _fromDateValue = pickedDate;
                                                        });
                                                      }
                                                    }
                                                    //   String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                                    //   setState(() {
                                                    //     _fromDate = formattedDate; // Update the selected date
                                                    //     _fromDateValue = pickedDate;
                                                    //   });
                                                    //   print(
                                                    //       "----1285------$_fromDate");
                                                    // }
                                                    // print("---From Date----");
                                                  },
                                                  child: Container(
                                                      height: 60,
                                                      child: Column(
                                                        children: [
                                                          // Asset Image
                                                          Image.asset(
                                                            'assets/images/calendar.png',
                                                            // Replace with your asset path
                                                            height: 40,
                                                            width: 40,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          // Spacer between image and text
                                                          // Text Widget
                                                          Text(
                                                          _fromDate != null && _fromDate.isNotEmpty ? _fromDate : 'From Date',
                                                          style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                       )
                                                        ],
                                                      )),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    // to date
                                                    DateTime? pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: DateTime.now(),
                                                      // Set the current date as the initial date
                                                      firstDate: DateTime.now(),
                                                      // Prevent selection of past dates
                                                      lastDate: DateTime(2101), // Set the maximum selectable date
                                                    );

                                                    if (pickedDate != null) {
                                                      if (_fromDateValue != null && pickedDate.isBefore(_fromDateValue!)) {
                                                        // Show validation error
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('To Date cannot be earlier than From Date')),
                                                        );
                                                      } else {
                                                        String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                                        setState(() {
                                                          _toDate = formattedDate;
                                                          _toDateValue = pickedDate;
                                                        });
                                                      }
                                                    }
                                                    //   String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                                    //   setState(() {
                                                    //     _toDate = formattedDate; // Update the selected date
                                                    //   });
                                                    //   print("----1327------$_toDate");
                                                    // }
                                                  },
                                                  child: Container(
                                                      height: 60,
                                                      child: Column(
                                                        children: [
                                                          // Asset Image
                                                          Image.asset(
                                                            'assets/images/calendar.png',
                                                            // Replace with your asset path
                                                            height: 40,
                                                            width: 40,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          // SizedBox(height: 10), // Spacer between image and text
                                                          // Text Widget
                                                         // Text(_toDate, style: AppTextStyle.font14OpenSansRegularBlack45TextStyle)
                                                          Text(
                                                            _toDate != null && _toDate.isNotEmpty ? _toDate : 'To Date',
                                                            style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                    // Fixed Bottom Button
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          validateAndCallApi();
                        },
                        child: Container(
                          width: double.infinity,
                          // Make container fill the width of its parent
                          height: AppSize.s45,
                          padding: EdgeInsets.all(AppPadding.p5),
                          decoration: BoxDecoration(
                            color: Color(0xFF255898),
                            // Background color using HEX value
                            borderRadius: BorderRadius.circular(
                                AppMargin.m10), // Rounded corners
                          ),
                          //  #00b3c7
                          child: Center(
                            child: Text(
                              "Submit",
                              style: AppTextStyle
                                  .font16OpenSansRegularWhiteTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))));
  }

  // Section Header Widget
  Widget _buildSectionHeader({
    required String title,
    required bool isVisible,
    required bool isIconRotated,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFF96DFE8), // Custom background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
          ),
          IconButton(
            icon: AnimatedRotation(
              turns: isIconRotated ? 0.5 : 0.0, // Rotates the icon
              duration: Duration(milliseconds: 300),
              child: const Icon(Icons.arrow_drop_down, color: Colors.black),
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }

  // FIRST FORM
  Widget _buildFirstForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          // applicant name
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Applicant Name',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _applicationNamefocus,
                        controller: _applicationNameController,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Applicant Mobile No
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Applicant Mobile No',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _applicationMobilefocus,
                        controller: _applicationMobileController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // Allow only digits
                          LengthLimitingTextInputFormatter(10),
                          // Restrict input to a maximum of 10 digits
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Applicant Address
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Applicant Address',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              height: 70,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _applicationAddressfocus,
                        controller: _applicationAddressController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Second Form
  Widget _buildSecondForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // Align items vertically
            children: <Widget>[
              CircleWithSpacing(),
              // Space between the circle and text
              RichText(
                text: TextSpan(
                  text: 'Advertisement Place Type', // The normal text
                  style: AppTextStyle
                      .font14OpenSansRegularBlack45TextStyle, // Default style
                  children: const [
                    TextSpan(
                      text: ' *', // The asterisk
                      style: TextStyle(
                        color: Colors.red, // Red color for the asterisk
                        fontWeight:
                            FontWeight.bold, // Optional: Make the asterisk bold
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          // Premises Ward dropDown
          _bindPremisesWard(),
          SizedBox(height: 5),
          // Advertisement Unit
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Advertisement Unit',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _advertisementUnitfocus,
                        controller: _advertisementUnitController,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          filled: true, // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Advertisement Amount Type
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Advertisement Amount Type',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _advertisementAmountTypeController,
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // advertisement Amount
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Advertisement Amount',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _advertisementAmountController,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        onChanged: (value) {
                          // Update the current text
                          var amount = _advertisementAmountController.text;
                          setState(() {
                            num number = num.parse(amount);
                            totalamout+=number;
                            print('----->>>>>>----$totalamout');

                          });
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Size of Advertisement (Sq. Mtr).
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Size Of Advertisement(Sq.Mtr)',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _sizeOfAdvertisementfocus,
                        controller: _sizeOfAdvertisementController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          // Update the current text
                          setState(() {
                            num number = num.parse(value);
                            sizeOfAdvertisementValue = number;
                           // totalamout+=number;
                            print('----->>>>>>----$sizeOfAdvertisementValue');

                          });
                          },
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // Allow only digits
                          LengthLimitingTextInputFormatter(10),
                          // Restrict input to a maximum of 10 digits
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //  Days
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Days',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              height: 70,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _daysfocus,
                        controller: _daysController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number, // Numeric keyboard
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Accept only digits
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          // Update the current text
                          setState(() {
                            num number = num.parse(value);
                          var daysValue = number;
                            // totalamout+=number;
                            print('----->>>>>>--days-----$daysValue');
                            print('----->>>>>>--sizeOfAdvertisementValue----$sizeOfAdvertisementValue');
                            print('----->>>>>>--AdvertisementAmount----$_dropDownfAmount');
                            totalAmountValue = daysValue*sizeOfAdvertisementValue*_dropDownfAmount;
                            print("-----1551---$totalAmountValue");
                            _totalAmountController.text=totalAmountValue.toString();

                          });
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Total Amount
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Total Amount',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              height: 70,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _totalAmountfocus,
                        controller: _totalAmountController,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content Type
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Content Type',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              height: 70,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _contentTypefocus,
                        controller: _contentTypeController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content Description
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Content Description',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              height: 70,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _contentDescriptionfocus,
                        controller: _contenDescriptionController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Advertisement Address
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Advertisement Address',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              height: 70,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _advertisementAddressfocus,
                        controller: _advertisementAddressController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                              0xFFf2f3f5), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Container(
        height: 80,
        child: Row(
          children: [
            // First Container
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime
                        .now(), // Set the current date as the initial date
                    firstDate:
                        DateTime.now(), // Prevent selection of past dates
                    lastDate: DateTime(2101), // Set the maximum selectable date
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd/MMM/yyyy').format(pickedDate);
                    setState(() {
                      _fromDate = formattedDate; // Update the selected date
                    });
                    print("-----803---$_fromDate");
                  }
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/calendar.png'),
                          width: 30.0,
                          height: 30.0,
                        ),
                        SizedBox(height: 5),
                        Text(
                          _fromDate,
                          style: AppTextStyle
                              .font14OpenSansRegularBlack45TextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            // Second Container
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime
                        .now(), // Set the current date as the initial date
                    firstDate:
                        DateTime.now(), // Prevent selection of past dates
                    lastDate: DateTime(2101), // Set the maximum selectable date
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd/MMM/yyyy').format(pickedDate);
                    setState(() {
                      _toDate = formattedDate; // Update the selected date
                    });
                    print("----859--$_toDate");
                  }
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/calendar.png'),
                          width: 30.0,
                          height: 30.0,
                        ),
                        SizedBox(height: 5),
                        Text(
                          _toDate,
                          style:
                              AppTextStyle.font14OpenSansRegularBlackTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../app/generalFunction.dart';
// import '../../services/advertisementPlaceRepo.dart';
// import '../../services/advertisementPlaceTypeRepo.dart';
// import '../../services/advertisementplanRepo.dart';
// import '../../services/bookladvertisementRepo.dart';
// import '../circle/circle.dart';
// import '../resources/app_text_style.dart';
// import '../resources/values_manager.dart';
//
// class BookAdvertisement extends StatefulWidget {
//
//   final complaintName;
//   var bookAdvertisement;
//
//   BookAdvertisement(this.bookAdvertisement, {super.key, this.complaintName});
//
//   @override
//   State<BookAdvertisement> createState() => _BookAdvertisementState();
// }
//
// class _BookAdvertisementState extends State<BookAdvertisement> {
//
//   // Date PICKER
//   DateTime selectedDate = DateTime.now();
//   GeneralFunction generalFunction = GeneralFunction();
//   final _formKey = GlobalKey<FormState>();
//   String _toDate = 'To Date';
//   String _fromDate = 'From Date';
//
//   File? image;
//   List distList = [];
//   var _dropDownValueDistric;
//   List stateList = [];
//   List blockList = [];
//   List marklocationList = [];
//   List<dynamic> advertisementPlaceType = [];
//   List<dynamic> advertisementPlace = [];
//   List<dynamic> advertisementPlan = [];
//   var _dropDownValueMarkLocation;
//   var _dropDownValueAdvertisementPlaceType;
//   var _dropDownValueAdvertisementPlace;
//   var _dropDownValueAdvertisementPlan;
//   var _dropDownValueAdvertisementPlaceTypeValue;
//   var _dropDownValueAdvertisementPlaceValue;
//   var _dropDownValueAdvertisementPlanValue;
//
//   // Focus
//   FocusNode namefieldfocus = FocusNode();
//   final distDropdownFocus = GlobalKey();
//
//   // controller
//   TextEditingController contentController = TextEditingController();
//   TextEditingController contentDescriptionController = TextEditingController();
//
//   // focus
//   FocusNode contentfocus = FocusNode();
//   FocusNode contentDescriptionfocus = FocusNode();
//
//   //----- Api call Advertisement Place Type -----
//
//   advertisementPlaceTypeApi() async {
//     advertisementPlaceType = await AdvertiseMentPlaceTypeRepo().advertisementPlaceType(context);
//     print(" -----xxxxx-  advertisementPlaceType--79---> $advertisementPlaceType");
//     setState(() {});
//   }
//   // ---Api call Advertisement Place------
//   advertisementPlaceApi(dropDownValueAdvertisementPlaceType) async {
//     advertisementPlace = await AdvertiseMentPlaceRepo().advertisementPlace(dropDownValueAdvertisementPlaceType);
//     print(" -----76---> $advertisementPlace");
//     setState(() {});
//   }
//   // ------Api---call Advertisement Plan-----
//   advertisementPlanApi(dropDownValueAdvertisementPlaceValue) async {
//     advertisementPlan = await AdvertisementPlanRepo().advertisementPlan(dropDownValueAdvertisementPlaceValue);
//     print(" -----xxxxx-  79-------> $advertisementPlan");
//     setState(() {});
//   }
//   /// Todo bind Advertisement place Type
//
//   Widget _bindAdvertisementPlaceType() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width - 50,
//       height: 42, // Add height constraint
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             dropdownColor: Colors.white,
//             hint: Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Text(
//                 "Select Advertisement Place Type",
//                 style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
//               ),
//             ),
//             value: _dropDownValueAdvertisementPlaceTypeValue, // Ensure this is valid
//             onChanged: (newValue) {
//               setState(() {
//                 _dropDownValueAdvertisementPlaceTypeValue = newValue;
//                 // Find and update the corresponding ID
//                 final selectedItem = advertisementPlaceType.firstWhere(
//                       (element) => element["sAdSpaceTypeName"] == newValue,
//                   orElse: () => null,
//                 );
//                 if (selectedItem != null) {
//                   _dropDownValueAdvertisementPlaceType = selectedItem['iAdSpaceTypeCode'];
//                   print('-------$_dropDownValueAdvertisementPlaceType');
//                   if(_dropDownValueAdvertisementPlaceType!=null && _dropDownValueAdvertisementPlaceType!='')
//                   setState(() {
//                     advertisementPlaceApi(_dropDownValueAdvertisementPlaceType);
//                   });
//
//                 }
//               });
//             },
//             items: advertisementPlaceType.map<DropdownMenuItem<String>>((dynamic item) {
//               return DropdownMenuItem<String>(
//                 value: item["sAdSpaceTypeName"].toString(),
//                 child:  SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.7,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20),
//                     child: Text(
//                       item["sAdSpaceTypeName"].toString(),
//                       overflow: TextOverflow.ellipsis, // Avoid text overflow
//                       maxLines: 1,
//                       style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
//                     ),
//                   ),
//                 )
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // bind Advertisement place
//   Widget _bindAdvertisementPlace() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width - 50,
//       height: 42, // Add height constraint
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             dropdownColor: Colors.white,
//             hint: Padding(padding: const EdgeInsets.only(left: 20),
//               child: Text("Select Advertisement Place",
//                 style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
//               ),
//             ),
//             value: _dropDownValueAdvertisementPlace, // Ensure this is valid
//             onChanged: (newValue) {
//               setState(() {
//                 _dropDownValueAdvertisementPlace = newValue;
//                 // Find and update the corresponding ID
//                 final selectedItem = advertisementPlace.firstWhere(
//                       (element) => element["sAdSpacePlace"] == newValue,
//                   orElse: () => null,
//                 );
//                 if (selectedItem != null) {
//                   _dropDownValueAdvertisementPlaceValue = selectedItem['iAdSpaceCode'];
//                   print('----172-----$_dropDownValueAdvertisementPlaceValue');
//                   if(_dropDownValueAdvertisementPlaceValue!=null && _dropDownValueAdvertisementPlaceValue!=""){
//                     // call api
//                     advertisementPlanApi(_dropDownValueAdvertisementPlaceValue);
//                   }
//                  //9871950881 advertisementPlaceApi(_dropDownValueAdvertisementPlace);
//                 }
//               });
//             },
//             items: advertisementPlace.map<DropdownMenuItem<String>>((dynamic item) {
//               return DropdownMenuItem<String>(
//                   value: item["sAdSpacePlace"].toString(),
//                   child:  SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.7,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Text(
//                         item["sAdSpacePlace"].toString(),
//                         overflow: TextOverflow.ellipsis, // Avoid text overflow
//                         maxLines: 1,
//                         style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
//                       ),
//                     ),
//                   )
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
//   // bind Advertisement plan
//   Widget _bindAdvertisementPlan() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width - 50,
//       height: 42, // Add height constraint
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             dropdownColor: Colors.white,
//             hint: Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Text("Select Advertisement Plan",
//                 style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
//               ),
//             ),
//             value: _dropDownValueAdvertisementPlan, // Ensure this is valid
//             onChanged: (newValue) {
//               setState(() {
//                 _dropDownValueAdvertisementPlan = newValue;
//                 // Find and update the corresponding ID
//                 final selectedItem = advertisementPlan.firstWhere(
//                       (element) => element["sPlanName"] == newValue,
//                   orElse: () => null,
//                 );
//                 if (selectedItem != null) {
//                   _dropDownValueAdvertisementPlanValue = selectedItem['iPlanCode'];
//
//                   print('----306-----$_dropDownValueAdvertisementPlanValue');
//                   if(_dropDownValueAdvertisementPlanValue!=null && _dropDownValueAdvertisementPlanValue!=''){
//                     setState(() {
//                       // call api
//                     });
//                   }
//                   //9871950881 advertisementPlaceApi(_dropDownValueAdvertisementPlace);
//                 }
//               });
//             },
//             items: advertisementPlan.map<DropdownMenuItem<String>>((dynamic item) {
//               return DropdownMenuItem<String>(
//                   value: item["sPlanName"].toString(),
//                   child:  SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.7,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Text(
//                         item["sPlanName"].toString(),
//                         overflow: TextOverflow.ellipsis, // Avoid text overflow
//                         maxLines: 1,
//                         style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
//                       ),
//                     ),
//                   )
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     print('-----27--${widget.bookAdvertisement}');
//     super.initState();
//     advertisementPlaceTypeApi();
//     contentController = TextEditingController();
//     contentDescriptionController = TextEditingController();
//   }
//
//   String generateRandom20DigitNumber() {
//     final Random random = Random();
//     String randomNumber = '';
//
//     for (int i = 0; i < 10; i++) {
//       randomNumber += random.nextInt(10).toString();
//     }
//     return randomNumber;
//   }
//   // toast
//   void displayToast(String msg){
//     Fluttertoast.showToast(
//         msg: msg,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }
//
//   @override
//   void dispose() {
//     contentController.dispose();
//     contentDescriptionController.dispose();
//     contentfocus.dispose();
//     contentDescriptionfocus.dispose();
//     super.dispose();
//   }
//   // submit button function
//   void validateAndCallBookAdvertisementApi() async {
//     // Validate form inputs
//     final isFormValid = _formKey.currentState!.validate();
//
//     // Get shared preferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sPostedBy = prefs.getString('sContactNo');
//     String sRequestNo = generateRandom20DigitNumber();
//
//     // TextField inputs
//     var contentTypeText = contentController.text.trim();
//     var contentDescriptionText = contentDescriptionController.text.trim();
//
//     print('-----471----$_fromDate');
//     print('-----472----$_toDate');
//     print('-----474----$sPostedBy');
//
//     // Validate all required fields
//     if (!isFormValid) {
//       print('--Form Validation Failed--');
//       return;
//     }
//
//     if (_dropDownValueAdvertisementPlaceType == null) {
//       displayToast('Select Advertisement Place Type');
//       return;
//     }
//
//     if (contentTypeText.isEmpty) {
//       displayToast('Please Enter Content Type');
//       return;
//     }
//
//     if (_fromDate.isEmpty || _fromDate == "From Date") {
//       displayToast('Please Select From Date');
//       return;
//     }
//
//     if (_toDate.isEmpty || _toDate == "To Date") {
//       displayToast('Please Select To Date');
//       return;
//     }
//
//     if (sPostedBy == null) {
//       displayToast('User not logged in. Please log in to proceed.');
//       return;
//     }
//
//     // All validations passed; proceed to call API
//     print('---Call API---');
//
//     try {
//       // Simulate API call here (Uncomment and replace with actual logic)
//       var bookresponse = await BookAadvertisementRepo().bookadvertisement(
//         context,
//         sRequestNo,
//         _dropDownValueAdvertisementPlaceType,
//         _dropDownValueAdvertisementPlace,
//         contentTypeText,
//         _dropDownValueAdvertisementPlan,
//         _fromDate,
//         _toDate,
//         sPostedBy,
//       );
//
//       // Example response handling (Modify based on your actual API response)
//       var result = "${bookresponse['Result']}";
//       var msg = "${bookresponse['Msg']}";
//       //
//       if (result == "1") {
//         displayToast(msg);
//         Navigator.pop(context);
//       } else {
//         displayToast(msg);
//       }
//      // displayToast("API Called Successfully"); // Temporary Success Message
//     } catch (e) {
//       print('Error calling API: $e');
//       displayToast('Failed to book advertisement. Please try again later.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: getAppBarBack(context, '${widget.bookAdvertisement}'),
//        // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
//
//         body: GestureDetector(
//           onTap: (){
//             FocusScope.of(context).unfocus();
//           },
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 //SizedBox(height: 12),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 0, bottom: 10),
//                   child: SizedBox(
//                     height: 120, // Height of the container
//                     width: MediaQuery.of(context).size.width,
//                     // width: 200, // Width of the container
//                     //step3.jpg
//                     child: Image.asset(
//                       'assets/images/complaints_header.png',
//                       // Replace 'image_name.png' with your asset image path
//                       fit: BoxFit.fill, // Adjust the image fit to cover the container
//                     ),
//                   ),
//                 ),
//                 // SizedBox(
//                 //   height: 120, // Height of the container
//                 //   width: MediaQuery.of(context).size.width,
//                 //   child: Image.asset(
//                 //     'assets/images/onlinecomplaint.jpeg',
//                 //     fit: BoxFit.cover, // Adjust the image fit to cover the container
//                 //   ),
//                 // ),
//                // SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 15, right: 15, bottom: 100, top: 5),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width - 30,
//                     decoration: BoxDecoration(
//                         color: Colors.white, // Background color of the container
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             // Color of the shadow
//                             spreadRadius: 5,
//                             // Spread radius
//                             blurRadius: 7,
//                             // Blur radius
//                             offset: Offset(0, 3), // Offset of the shadow
//                           ),
//                         ]),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(height: 10),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   margin:
//                                       EdgeInsets.only(left: 0, right: 10, top: 10),
//                                   child: Image.asset(
//                                     'assets/images/ic_expense.png',
//                                     // Replace with your image asset path
//                                     width: 24,
//                                     height: 24,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 10),
//                                   child: Text('Fill the below details',
//                                       style: AppTextStyle
//                                           .font16OpenSansRegularBlackTextStyle),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               // Align items vertically
//                               children: <Widget>[
//                                 CircleWithSpacing(),
//                                 // Space between the circle and text
//                                 Text('Advertisement Place Type',style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             _bindAdvertisementPlaceType(),
//                             SizedBox(height: 5),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               // Align items vertically
//                               children: <Widget>[
//                                 CircleWithSpacing(),
//                                 // Space between the circle and text
//                                 Text(
//                                   'Advertisement Place',
//                                   style: AppTextStyle
//                                       .font14OpenSansRegularBlack45TextStyle,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             _bindAdvertisementPlace(),
//                            // _bindAdvertisementPlaceType(),
//                             SizedBox(height: 5),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               // Align items vertically
//                               children: <Widget>[
//                                 CircleWithSpacing(),
//                                 // Space between the circle and text
//                                 Text('Advertisement Plan',
//                                   style: AppTextStyle
//                                       .font14OpenSansRegularBlack45TextStyle,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             _bindAdvertisementPlan(),
//                            // _bindAdvertisementPlaceType(),
//                             SizedBox(height: 5),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               // Align items vertically
//                               children: <Widget>[
//                                 CircleWithSpacing(),
//                                 // Space between the circle and text
//                                 Text(
//                                   'Content Type',
//                                   style: AppTextStyle
//                                       .font14OpenSansRegularBlack45TextStyle,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 0, right: 0),
//                               child: Container(
//                                 height: 42,
//                                 color: Color(0xFFf2f3f5),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: TextFormField(
//                                     focusNode: contentfocus,
//                                     controller: contentController,
//                                     textInputAction: TextInputAction.next,
//                                     onEditingComplete: () =>
//                                         FocusScope.of(context).nextFocus(),
//                                     decoration: const InputDecoration(
//                                       border: InputBorder.none,
//                                       // labelText: AppStrings.txtMobile,
//                                       // border: OutlineInputBorder(),
//                                       contentPadding: EdgeInsets.symmetric(
//                                           vertical: AppPadding.p10),
//                                     ),
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     // validator: (value) {
//                                     //   if (value!.isEmpty) {
//                                     //     return 'Enter location';
//                                     //   }
//                                     //   return null;
//                                     // },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               // Align items vertically
//                               children: <Widget>[
//                                 CircleWithSpacing(),
//                                 // Space between the circle and text
//                                 Text(
//                                   'Content Type Description',
//                                   style: AppTextStyle
//                                       .font14OpenSansRegularBlack45TextStyle,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 0, right: 0),
//                               child: Container(
//                                 height: 42,
//                                 color: Color(0xFFf2f3f5),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: TextFormField(
//                                     focusNode: contentDescriptionfocus,
//                                     controller: contentDescriptionController,
//                                     textInputAction: TextInputAction.next,
//                                     onEditingComplete: () =>
//                                         FocusScope.of(context).nextFocus(),
//                                     decoration: const InputDecoration(
//                                       border: InputBorder.none,
//                                       contentPadding: EdgeInsets.symmetric(
//                                           vertical: AppPadding.p10),
//                                     ),
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             /// TODO pick date and as a ui TO Date and FromDATE
//                             Container(
//                               height: 80,
//                               child: Row(
//                                 children: [
//                                   // First Container
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () async {
//                                         DateTime? pickedDate = await showDatePicker(
//                                           context: context,
//                                           initialDate: DateTime.now(), // Set the current date as the initial date
//                                           firstDate: DateTime.now(), // Prevent selection of past dates
//                                           lastDate: DateTime(2101), // Set the maximum selectable date
//                                         );
//                                         if (pickedDate != null) {
//                                           String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
//                                           setState(() {
//                                             _fromDate = formattedDate; // Update the selected date
//                                           });
//                                           print("-----803---$_fromDate");
//                                         }
//                                       },
//                                       child: Container(
//                                         height: 80,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(10),
//                                           boxShadow: const [
//                                             BoxShadow(
//                                               color: Colors.black26,
//                                               blurRadius: 4,
//                                               offset: Offset(2, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               const Image(
//                                                 image: AssetImage(
//                                                     'assets/images/calendar.png'),
//                                                 width: 30.0,
//                                                 height: 30.0,
//                                               ),
//                                               SizedBox(height: 5),
//                                               Text(
//                                                 _fromDate,
//                                                 style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   // Second Container
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () async {
//                                         DateTime? pickedDate = await showDatePicker(
//                                           context: context,
//                                           initialDate: DateTime.now(), // Set the current date as the initial date
//                                           firstDate: DateTime.now(), // Prevent selection of past dates
//                                           lastDate: DateTime(2101), // Set the maximum selectable date
//                                         );
//
//                                         if (pickedDate != null) {
//                                           String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
//                                           setState(() {
//                                             _toDate = formattedDate; // Update the selected date
//                                           });
//                                           print("----859--$_toDate");
//                                         }
//                                       },
//                                       child: Container(
//                                         height: 80,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(10),
//                                           boxShadow: const [
//                                             BoxShadow(
//                                               color: Colors.black26,
//                                               blurRadius: 4,
//                                               offset: Offset(2, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               const Image(
//                                                 image: AssetImage(
//                                                     'assets/images/calendar.png'),
//                                                 width: 30.0,
//                                                 height: 30.0,
//                                               ),
//                                               SizedBox(height: 5),
//                                               Text(
//                                                 _toDate,
//                                                 style: AppTextStyle
//                                                     .font14OpenSansRegularBlackTextStyle,
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 15),
//                             GestureDetector(
//                               onTap: (){
//                                 validateAndCallBookAdvertisementApi();
//                               },
//                               child: Center(
//                                 child: Container(
//                                   width: double.infinity,
//                                   // Make container fill the width of its parent
//                                   height: AppSize.s45,
//                                   padding: EdgeInsets.all(AppPadding.p5),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xFF255898),
//                                     // Background color using HEX value
//                                     borderRadius: BorderRadius.circular(
//                                         AppMargin.m10), // Rounded corners
//                                   ),
//                                   //  #00b3c7
//                                   child: Center(
//                                     child: Text(
//                                       "Submit",
//                                       style: AppTextStyle
//                                           .font16OpenSansRegularWhiteTextStyle,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
