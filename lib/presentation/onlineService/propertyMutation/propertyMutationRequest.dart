import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:puri/services/BindMutationTypeRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/generalFunction.dart';
import '../../../../app/loader_helper.dart';
import '../../../../services/BindCitizenWardRepo.dart';
import '../../../../services/BindCommunityHallDateRepo.dart';
import '../../../../services/BindDocumentTypeRepo.dart';
import '../../../../services/BindFinancialYearRepo.dart';
import '../../../../services/BindTadeSubCategoryRepo.dart';
import '../../../../services/BindTradeCategoryRepo.dart';
import '../../../../services/baseurl.dart';
import '../../../../services/bindSubCategoryRepo.dart';
import '../../../services/BindDocumentTypePropertyRepo.dart';
import '../../../services/BindMutationRateListRepo.dart';
import '../../../services/PostMutationRequestRepo.dart';
import '../../../services/bindMutationDocListRepo.dart';
import '../../circle/circle.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';

class PropertyMutationRequest extends StatefulWidget {

  var name;

  PropertyMutationRequest({super.key, required this.name});

  @override
  State<PropertyMutationRequest> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PropertyMutationRequest> with TickerProviderStateMixin {

  List stateList = [];
  List<dynamic> subCategoryList = [];

  //List<dynamic> bindcommunityHallDate = [];

  List<Map<String,dynamic>> bindcommunityHallDate = [];

  List<dynamic> premisesWardDropDown = [];
  List<dynamic> finalYearDropDown = [];
  List<dynamic> bindTradeCategory = [];
  List<dynamic> bindMutationTypeList = [];
  List<dynamic> bindTradeSubCategory = [];

  // bindMutationRateList
  List<dynamic> bindMutationRateList = [];
  List<dynamic> bindMutationDocList = [];
  List<dynamic> bindreimouList = [];
  List<dynamic> bindDocumentTypeList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;
  List<dynamic> bindDocumentTypePropertyList = [];

  bool isFormVisible = true; // Track the visibility of the form
  bool isIconRotated = false;
  bool isFormVisible2 = true; // Track the visibility of the form
  bool isIconRotated2 = false;
  bool isFormVisible3 = true; // Track the visibility of the form
  bool isIconRotated3 = false;
  bool isFormVisible4 = true; // Track the visibility of the form
  bool isIconRotated4 = false;

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

  TextEditingController _OwnerNameController = TextEditingController();
  TextEditingController _ApplicantNameController = TextEditingController();
  TextEditingController _applicantFatherNameController = TextEditingController();
  TextEditingController _buildingNoController = TextEditingController();
  TextEditingController _applicationMobileController = TextEditingController();
  TextEditingController _applicationAddressController = TextEditingController();

  FocusNode _OwnerNamefocus = FocusNode();
  FocusNode _ApplicantNamefocus = FocusNode();
  FocusNode _applicantFatherNamefocus = FocusNode();
  FocusNode _premisesAddressfocus = FocusNode();
  FocusNode _buildingNofocus = FocusNode();
  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMobilefocus = FocusNode();
  FocusNode _applicationAddressfocus = FocusNode();
  var sUploadBuildingPlanPath;
  var sUploadSupportingDocPath;
  GeneralFunction? generalFunction;

  String? todayDate;
  String? consumableList;
  int count = 0;
  List? data;
  List? listCon;
  int selectedIndex = -1;

  //var _dropDownSector;
  var dropDownSubCategory;
  var _dropDownPremisesWard;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final subCategoryFocus = GlobalKey();
  final wardFocus = GlobalKey();
  var _dropDownPremisesWardCode;
  var _dropDownTradeSubCategoryFeesCode;
  var _dropDownTypeOfMutationTotalCost;
  var _dropDownRequiredDocumentType;
  var _dropDownRequiredDocumentTypeCode;
  var _dropDownTypeOfMutation;
  var _dropDownTypeOfMutationCode;
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
  //
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

  //  --
  // Track selected states

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
  var secondFromjson;
  var thirdFromJsonData;

  get selectedMonthCode => null;
  var sMuttationFees;
  // set image function
  Widget buildImageWidget(String? imageUrl) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        : const Text(
            'No Image',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          );
  }

  Future<void> uploadImage(String token, File imageFile) async {
    print("--------225---tolen---$token");
    print("--------226---imageFile---$imageFile");
    var baseURL = BaseRepo().baseurl;
    var endPoint = "PostImage/PostImage";
    var uploadImageApi = "$baseURL$endPoint";
    try {
      print('-----xx-x----214----');
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$uploadImageApi'),
      );
      // Add headers
      //request.headers['token'] = '04605D46-74B1-4766-9976-921EE7E700A6';
      request.headers['token'] = token;
      request.headers['sFolder'] = 'CompImage';
      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'sFolder',
        imageFile.path,
      ));
      // Send the request
      var streamedResponse = await request.send();
      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body); // No explicit type casting
      print("---------248-----$responseData");
      if(response.statusCode==401){
        generalFunction?.logout(context);
      }
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        uplodedImage = responseData['Data'][0]['sImagePath'];
        if (uplodedImage != null) {
          setState(() {
            uplodedImage = responseData['Data'][0]['sImagePath'];
            //   buildImageWidget(uplodedImage);
            //  _imageUrls.add(uplodedImage);
            // thirdFormCombinedList.add({
            //   'iDocumentTypeId': "${_dropDownDocument2_code}",
            //   'sDocumentName': "$_dropDownDocument2",
            //   'sDocumentUrl': uplodedImage,
            // });
          });
          print("-----283-ThirdList--$thirdFormCombinedList");
        }
        //
        // setState(() {
        //   thirdFormCombinedList.add({
        //     'iDocumentTypeId': "${_dropDownDocument2_code}",
        //     'sDocumentName': "$_dropDownDocument2",
        //     'sDocumentUrl': uplodedImage,
        //   });
        // });
        print("------250----image list--$_imageUrls");

        /// todo you should store image path here in a list
        ///
        print('Uploaded Image Path----222--: $uplodedImage');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }
  // add item to list
  // permises Ward Api call

  premisesWard() async {
    /// todo remove the comment and call Community Hall
    premisesWardDropDown = await BindCitizenWardRepo().bindCityZenWard(context);
    print(" -----Premissesward---->>>>-xx--143-----> $premisesWardDropDown");
    setState(() {});
  }

  // Financial Year Api call
  finalYearApi() async {
    /// todo remove the comment and call Community Hall
    finalYearDropDown = await BindFinalYearRepo().bindFinalYearWard(context);
    print(" -----finalYearDropDown---->>>>-xx--154-----> $finalYearDropDown");
    setState(() {});
  }

  // Bind Trade Category Item Api call
  bindTradeCategoryApi() async {
    /// todo remove the comment and call Community Hall
    bindTradeCategory = await BindTradeCategoryRepo().bindTradeCategory();
    print(
        " -----bindTradeCategory Repo---->>>>-xx--154-----> $bindTradeCategory");
    setState(() {});
  }
  // Types Of Mutation.
  bindMutationApi() async {
    /// todo remove the comment and call Community Hall
    bindMutationTypeList = await BindMutationTypeRepo().bindMutationTypeRepo();
    print(" -----bindMutationTypeList Repo---->>>>-xx--154-----> $bindMutationTypeList");
    setState(() {});
  }
  // Bind Sub Category Itrem Api call

  bindTradeSubCategoryApi(dropDownTradeCategoryCode) async {
    /// todo remove the comment and call Community Hall
    bindTradeSubCategory = [];
    bindTradeSubCategory = await BindTradeSubCategoryRepo()
        .bindTradeSubCategory(dropDownTradeCategoryCode);
    print(" -----bindTradeSubCategory Repo---->>>>-xx--154-----> $bindTradeSubCategory");
    setState(() {});
  }
  // BindMutationDocsList Api
  BindMutationDocsListApi(_dropDownTypeOfMutationCode) async {
    /// todo remove the comment and call Community Hall
    bindMutationDocList = [];
    bindMutationDocList = await BindMutationDocListRepo().bindMutationDoc(_dropDownTypeOfMutationCode);
    print(" -----bindMutationDocList Repo---->>>>-xx--360-----> $bindMutationDocList");
    setState(() {});
  }
  bindSupportingDocumentPropertyApi() async {
    /// todo remove the comment and call Community Hall
    bindDocumentTypePropertyList = await BindDocumentTypePropertyRepo().bindDocumentyTypeProperty();
    print(" -----bindDocumnent Property Repo---->>>>-xx--154-----> $bindDocumentTypePropertyList");
    setState(() {});
  }
  // BindMutationRateList Api
  BindMutationRateListApi(_dropDownTypeOfMutationCode) async {
    /// todo remove the comment and call Community Hall
    bindMutationRateList = [];
    bindMutationRateList = await BindMutationRateListRepo().bindMutationRate(_dropDownTypeOfMutationCode);
    print(" -----bindMutationRateList Repo---->>>>-xx--360-----> $bindMutationRateList");
    setState(() {
      sMuttationFees = "${bindMutationRateList[0]['TotalCost']}";
      print("-------384---xxx--xxxx--xxx-----$sMuttationFees");
    });
  }
  // Bind Supporting Documents
  bindSupportingDocumentApi() async {
    /// todo remove the comment and call Community Hall
    bindDocumentTypeList = await BindDocumentTypeRepo().bindDocumentyType();
    print(" -----bindDocumnent Repo---->>>>-xx--154-----> $bindDocumentTypeList");
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
                    text: "Select Ward",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownPremisesWard,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownPremisesWard = newValue;
                    premisesWardDropDown.forEach((element) {
                      if (element["sWardName"] == _dropDownPremisesWard) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownPremisesWardCode = element['sWardCode'];
                      }
                    });
                    if (_dropDownPremisesWardCode != null) {
                      /// remove the comment
                      setState(() {
                        // call a api if needs

                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                    }
                    print("------157---hallId--$_dropDownPremisesWardCode");
                  });
                },

                items: premisesWardDropDown.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sWardName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sWardName'].toString(),
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
  // Type Of Mutation
  Widget _bindTypeOfMutation() {
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
                    text: "Select Type of Property Transfer",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownTypeOfMutation,
                onChanged: (newValue) {
                //  bindTradeSubCategory = [];
                //  _dropDownTradeSubCategory = null;
                  setState(() {
                    _dropDownTypeOfMutation = newValue;
                    bindMutationTypeList.forEach((element) {
                      if (element["sMutationType"] == _dropDownTypeOfMutation) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownTypeOfMutationCode = element['iMutationCode'];
                        //  _dropDownTradeSubCategoryFeesCode
                        _dropDownTypeOfMutationTotalCost = element['TotalCost'];
                      }
                    });
                    print("------677--cost---$_dropDownTypeOfMutationTotalCost");
                    print("------678--code---$_dropDownTypeOfMutationCode");
                    if (_dropDownTypeOfMutationCode != null) {
                      /// remove the comment
                      print("-----523----$_dropDownTypeOfMutationCode");
                      setState(() {
                        // call a api if needs
                        BindMutationRateListApi(_dropDownTypeOfMutationCode);
                        //BindMutationDocsListApi(_dropDownTypeOfMutationCode);
                      //  BindMutationDocsListApi(_dropDownTypeOfMutationCode);
                       // bindTradeSubCategoryApi(_dropDownTradeCategoryCode);

                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                     // print("Invalid Trade Category Code");
                    }
                    //print("------373--DropDownnCategory Code----$_dropDownTradeCategoryCode");
                  });
                },
                items: bindMutationTypeList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sMutationType"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sMutationType'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
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
      bindcommunityHallDate = await BindCommunityHallDateRepo().bindCommunityHallDate(context, hallId, selectedMonthCode);
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
      return const Center(
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

  void openPdf(BuildContext context, String pdfUrl) async {
    if (await canLaunchUrl(Uri.parse(pdfUrl))) {
      await launchUrl(Uri.parse(pdfUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open PDF")),
      );
    }
  }

  @override
  void initState() {
    premisesWard();
    finalYearApi();
    bindTradeCategoryApi();
    bindSupportingDocumentApi();
    bindMutationApi();
    bindSupportingDocumentPropertyApi();
    thirdFormCombinedList = [];
    super.initState();
    _OwnerNamefocus = FocusNode();
    _premisesAddressfocus = FocusNode();
    _applicationNamefocus = FocusNode();
    _applicationMobilefocus = FocusNode();
    _applicationAddressfocus = FocusNode();
    if (bindcommunityHallDate.isNotEmpty) {
      selectedStates = List.generate(bindcommunityHallDate.length, (index) => false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _OwnerNamefocus.dispose();
    _premisesAddressfocus.dispose();
    _applicationNamefocus.dispose();
    _applicationMobilefocus.dispose();
    _applicationAddressfocus.dispose();
    FocusScope.of(context).unfocus();
  }
  // Api call Function

  void validateAndCallApi() async {
    firstFormCombinedList = [];
    DateTime now = DateTime.now();
    // Format the date as yyyyMMddHHmmssSS
    String formattedDate = DateFormat('yyyyMMddHHmmssSS').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sCreatedBy = prefs.getString('sContactNo');

    // TextFormField values
    var ownerName = _OwnerNameController.text.trim();
    var applicationName = _ApplicantNameController.text.trim();
    var applicationFatherName = _applicantFatherNameController.text.trim();
    var buildingNo = _buildingNoController.text.trim();
    var applicationMobileNo = _applicationMobileController.text.trim();
    var applicationAddress = _applicationAddressController.text.trim();

    if (_dropDownPremisesWardCode != null &&
        ownerName.isNotEmpty &&
        applicationName.isNotEmpty &&
        applicationFatherName.isNotEmpty &&
        buildingNo.isNotEmpty &&
        applicationMobileNo.isNotEmpty &&
        applicationAddress.isNotEmpty) {
      // All conditions met; call the API
      print('---Call API---');

      print("---1147----sTranNo----$formattedDate");
      print("---1147----sApplicantName----$applicationName");
      print("---1147----applicationFatherName----$applicationFatherName");
      print("---1147----sApplicationAddr----$applicationAddress");
      print("---1147----sApplicantMobile----$applicationMobileNo");
      print("---1147----sBuildingNo----$buildingNo");
      print("---1147----sMohalla----$_dropDownPremisesWardCode");
      print("---1147----sCurOwner----$ownerName");
      print("---1147----iMutationCode----$_dropDownTypeOfMutationCode");
      print("---1147----fMutationFee----$_dropDownTypeOfMutationTotalCost");
      print("---1147----dEntryBy----$sCreatedBy");
      print("---1147----DocmentArray----$thirdFormCombinedList");


      /// put these value into the list
      firstFormCombinedList.add({
        "sTranNo": formattedDate,
        "sApplicantName": applicationName,
        "sFathersName": applicationFatherName,
        "sApplicationAddr": applicationAddress,
        "sApplicantMobile": applicationMobileNo,
        "sBuildingNo": buildingNo,
        "iWardCode": "$_dropDownPremisesWardCode",
        "sCurOwner": ownerName,
        "iMutationCode": "$_dropDownTypeOfMutationCode",
        "fMutationFee":  sMuttationFees,
        "dEntryBy":sCreatedBy,
        "DocmentArray": thirdFormCombinedList
      });

      // lIST to convert json string
      String allThreeFormJson = jsonEncode(firstFormCombinedList);
      print("----778---FINAL LIST jsson response---$allThreeFormJson");

      // Call your API logic here
      var onlineComplaintResponse = await PostMutationRequestRepo()
          .postMutationRequest(context, allThreeFormJson);
      print('----1020---$onlineComplaintResponse');

      //
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
      if (_dropDownPremisesWard == null) {
        displayToast('Please Select Premises Ward');
        return;
      }
      if (ownerName.isEmpty) {
        displayToast('Please Enter Owner Name');
        return;
      }
      if (applicationName.isEmpty) {
        displayToast('Please Enter Applicant Name');
        return;
      }
      if (applicationFatherName.isEmpty) {
        displayToast('Please Enter Father Name');
        return;
      }
      if (buildingNo.isEmpty) {
        displayToast('Please Enter Building No');
        return;
      }
      if (applicationMobileNo.isEmpty) {
        displayToast('Please Enter Applicant Mobile No');
        return;
      }
      if (applicationAddress.isEmpty) {
        displayToast('Please Enter Address');
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
                    color: Colors.white.withOpacity(0.5),
                    // Background color for circle
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
                      "${widget.name}",
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
                          title: "2. Property Transfer Detail",
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
                        if (isSecondFormVisible)
                          _buildSecondForm(),

                        // Third Section Header
                        _buildSectionHeader(
                          title: "3. Upload Photos",
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
                          _buildThirdForm(),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // Align items vertically
            children: <Widget>[
              CircleWithSpacing(),
              // Space between the circle and text
              RichText(
                text: TextSpan(
                  text: 'Ward', // The normal text
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
          // Owner Name
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
                    text: 'Owner Name',
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
                        focusNode: _OwnerNamefocus,
                        controller: _OwnerNameController,
                        textInputAction: TextInputAction.next,
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
          // Permises Address
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
                        focusNode: _ApplicantNamefocus,
                        controller: _ApplicantNameController,
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
          // application name
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
                    text: 'Applicant Father Name',
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
                        focusNode: _applicantFatherNamefocus,
                        controller: _applicantFatherNameController,
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
          // Applicant Building No.
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
                    text: 'Building No',
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
                        focusNode: _buildingNofocus,
                        controller: _buildingNoController,
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
          // Application Mobile No.
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
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          filled: true,
                          fillColor: Color(0xFFf2f3f5),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        // 🔹 Validation logic
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (value.length < 10) {
                            return 'length is less than 10 digit';
                          }
                          return null; // valid
                        },

                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),

                    // Expanded(
                    //   child: TextFormField(
                    //     focusNode: _applicationMobilefocus,
                    //     controller: _applicationMobileController,
                    //     keyboardType: TextInputType.number,
                    //     textInputAction: TextInputAction.next,
                    //     onEditingComplete: () =>
                    //         FocusScope.of(context).nextFocus(),
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       contentPadding: EdgeInsets.symmetric(
                    //           vertical: 10.0, horizontal: 10.0),
                    //       filled: true,
                    //       // Enable background color
                    //       fillColor: Color(
                    //           0xFFf2f3f5), // Set your desired background color here
                    //     ),
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     inputFormatters: [
                    //       FilteringTextInputFormatter.digitsOnly,
                    //       // Allow only digits
                    //       LengthLimitingTextInputFormatter(10),
                    //       // Restrict input to a maximum of 10 digits
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          //
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
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            // Add a list to added item on a Add Item
            // if (consuambleItemList!.isNotEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Card(
                    elevation: 4, // Adjust the shadow level
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), // Rounded corners for the card
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      // Inner padding for the container
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // Background color for the container
                        borderRadius: BorderRadius.circular(5),
                        // Rounded corners for the container
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // Auto height based on children
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Align children to the start
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/uplodeTrade.jpeg'),
                                    // Use AssetImage here
                                    fit: BoxFit.cover, // Adjusts how the image is fitted
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              const Text(
                                "Transfer Detail",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 16),
                              ),
                              Spacer(),
                              IconButton(
                                icon: AnimatedRotation(
                                  turns: isIconRotated4 ? 0.5 : 0.0,
                                  // Rotates the icon
                                  duration: Duration(milliseconds: 300),
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    // Toggle form visibility and icon rotation
                                    isFormVisible4 = !isFormVisible4;
                                    isIconRotated4 = !isIconRotated4;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (isFormVisible4)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // Align items vertically
                                  children: <Widget>[
                                    CircleWithSpacing(),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Type Of Transfer',
                                        // The normal text
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                        // Default style
                                        children: const [
                                          TextSpan(
                                            text: ' *', // The asterisk
                                            style: TextStyle(
                                              color: Colors.red,
                                              // Red color for the asterisk
                                              fontWeight: FontWeight.bold, // Optional: Make the asterisk bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                _bindTypeOfMutation(),
                                SizedBox(height: 10),
                                if(bindMutationRateList.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent, // Set the dynamic color
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: const Icon(Icons.ac_unit,
                                            color: Colors.white,
                                          )
                                      ),
                                      SizedBox(width: 10),
                                      Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text("Transfer Fee List",style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                                          )),
                                    ],
                                  ),
                                SizedBox(height: 5),

                                ListView.builder(
                                  shrinkWrap: true,
                                  // Makes ListView take up only the needed height
                                  physics: NeverScrollableScrollPhysics(),
                                  // Disable ListView scrolling if the outer widget scrolls
                                  itemCount: bindMutationRateList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final color = borderColors[index % borderColors.length];
                                    final item = bindMutationRateList![index];
                                    // _dropDownTradeSubCategoryFeesCode =  item['TotalCost'];
                                    _dropDownTradeSubCategoryFeesCode =   bindMutationRateList![0]['TotalCost'];
                                    print("------1833---Fees-$_dropDownTradeSubCategoryFeesCode");

                                    //  print("--------2183--->>>>>----$_dropDownTradeSubCategoryFeesCode");
                                     return GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          // iTranId = notificationData.iTranId;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 1.0),
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
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
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 251, // Set the desired width for the box
                                                      padding: EdgeInsets.all(8.0), // Optional: Add padding inside the box
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey), // Optional: Add a border to the box
                                                        borderRadius: BorderRadius.circular(4.0), // Optional: Add rounded corners
                                                        color: Colors.white, // Optional: Background color
                                                      ),
                                                      child: Text(
                                                        item['sDescription'],
                                                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                        softWrap: true, // Ensures text wraps to the next line
                                                        overflow: TextOverflow.visible, // Ensures text remains visible
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // Align items vertically
                                  children: <Widget>[
                                    CircleWithSpacing(),
                                    // Space between the circle and text
                                    RichText(
                                      text: TextSpan(
                                        text: 'Transfer Fee',
                                        // The normal text
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                        // Default style
                                        children: const [
                                          TextSpan(
                                            text: ' *', // The asterisk
                                            style: TextStyle(
                                              color: Colors.red,
                                              // Red color for the asterisk
                                              fontWeight: FontWeight
                                                  .bold, // Optional: Make the asterisk bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 0),
                                  child: Container(
                                    height: 70,
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [

                                          Expanded(
                                            child: Text(
                                              "${sMuttationFees ?? 0}",
                                              style: AppTextStyle.font14penSansBlack45TextStyle,
                                            ),
                                          ),
                                          // Expanded(
                                          //   child: Text(
                                          //     "${bindMutationRateList[0]['TotalCost'] ?? 0}",
                                          //     style: AppTextStyle
                                          //         .font14penSansBlack45TextStyle,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     count++;
                                //     // Registration
                                //     // consuambleItemList=[];
                                //     print('-----1354---');
                                //     print(
                                //         "--------1535--fees--$_dropDownTradeSubCategoryFeesCode");
                                //     print(
                                //         "-----DropDown Trade Category-----$_dropDownTradeCategory");
                                //     print(
                                //         "-----DropDown Sub Trade Category-----$_dropDownTradeSubCategory");
                                //     if (_dropDownTradeCategoryCode == null) {
                                //       displayToast("Pick a Trade Category");
                                //       return;
                                //     }
                                //     if (_dropDownTradeSubCategory == null) {
                                //       displayToast("Pick a Trade Sub Category");
                                //       return;
                                //     }
                                //     setState(() {
                                //       consuambleItemList ??=
                                //           []; // Initialize the list if it's null
                                //       consuambleItemList!.add({
                                //         'SrNo': count,
                                //         'sTradeCategory':
                                //             _dropDownTradeCategory,
                                //         'sTradeSubCategory':
                                //             _dropDownTradeSubCategory,
                                //         'feesCode':
                                //             _dropDownTradeSubCategoryFeesCode,
                                //       });
                                //     });
                                //     displayToast("Item Added");
                                //     // Added Item into secondFormList
                                //
                                //     secondFormCombinedList.add({
                                //       "TradeCategoryId":
                                //           "$_dropDownTradeCategoryCode",
                                //       "TradeId":
                                //           "$_dropDownTradeSubCategoryCode",
                                //       "NoOfRoom": "",
                                //       "LicenceFee":
                                //           "$_dropDownTradeSubCategoryFeesCode"
                                //     });
                                //     firstFormCombinedList
                                //         .addAll(secondFormCombinedList);
                                //     print(
                                //         "----2045---com first + second list---$firstFormCombinedList");
                                //     setState(() {
                                //       secondFromjson =
                                //           jsonEncode(secondFormCombinedList);
                                //     });
                                //     print(
                                //         "-----2067---secondFormData--...---: $secondFromjson");
                                //
                                //     //  _dropDownTradeSubCategory
                                //   },
                                //   child: Center(
                                //     child: Container(
                                //       padding: EdgeInsets.all(10.0),
                                //       // 10dp padding around the text
                                //       decoration: BoxDecoration(
                                //         border: Border.all(
                                //             color: Color(0xFF255899)),
                                //         // Gray border color
                                //         borderRadius: BorderRadius.circular(
                                //             8.0), // Rounded corners for the border
                                //       ),
                                //       child: Text(
                                //         "Add Item",
                                //         style: AppTextStyle
                                //             .font14penSansBlackTextStyle,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  // Third Form
  Widget _buildThirdForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            print("------DialogPop----");
            // _openDialog();
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 50, left: 10, right: 10, bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleWithSpacing(),
                                          // Space between the circle and text
                                          Text(
                                            "Required Document Type",
                                            style: AppTextStyle
                                                .font14OpenSansRegularBlack45TextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Document DropDown
                                    Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width -
                                              50,
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
                                                  FocusScope.of(context)
                                                      .unfocus(); // Dismiss keyboard
                                                },
                                                hint: RichText(
                                                  text: TextSpan(
                                                    text:
                                                    "Select Document Type",
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularBlack45TextStyle,
                                                  ),
                                                ),
                                                value:
                                                _dropDownRequiredDocumentType,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _dropDownRequiredDocumentType =
                                                        newValue;
                                                    bindDocumentTypePropertyList
                                                        .forEach((element) {
                                                      if (element["sDocumentTypeName"] ==
                                                          _dropDownRequiredDocumentType) {
                                                        // RatePerDay
                                                        //_selectedWardId = element['iCommunityHallId'];
                                                        // iTradeCode   fLicenceFees
                                                        _dropDownRequiredDocumentTypeCode = element['iDocumentTypeCode'];
                                                        print("----$_dropDownRequiredDocumentTypeCode");
                                                        // _dropDownTradeSubCategoryFeesCode = element['fLicenceFees'];
                                                      }
                                                    });

                                                    if (_dropDownRequiredDocumentTypeCode !=
                                                        null) {
                                                      /// remove the comment
                                                      setState(() {
                                                        // call a api if needs
                                                        print(
                                                            "---2497--Fees----$_dropDownRequiredDocumentTypeCode");
                                                        //  _dropDownDocument2
                                                        //print("---587------$_dropDownDocument2");
                                                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                                                      });
                                                    } else {
                                                      //toast
                                                    }
                                                    // print("------373--DropDownnCategory Code----$_dropDownTradeCategoryCode");
                                                  });
                                                },
                                                items: bindDocumentTypePropertyList
                                                    .map((dynamic item) {
                                                  return DropdownMenuItem(
                                                    value: item["sDocumentTypeName"].toString(),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            item['sDocumentTypeName'].toString(),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
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
                                    ),
                                    // Material(
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.circular(10.0),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.only(left: 10),
                                    //     child: Container(
                                    //       width: MediaQuery.of(context).size
                                    //               .width -
                                    //           50,
                                    //       height: 42,
                                    //       color: Color(0xFFf2f3f5),
                                    //
                                    //       child: DropdownButtonHideUnderline(
                                    //         child: ButtonTheme(
                                    //           alignedDropdown: true,
                                    //           child: DropdownButton(
                                    //             isDense: true,
                                    //             // Reduces the vertical size of the button
                                    //             isExpanded: true,
                                    //             // Allows the DropdownButton to take full width
                                    //             dropdownColor: Colors.white,
                                    //             // Set dropdown list background color
                                    //             onTap: () {
                                    //               FocusScope.of(context)
                                    //                   .unfocus(); // Dismiss keyboard
                                    //             },
                                    //             hint: RichText(
                                    //               text: TextSpan(
                                    //                 text:
                                    //                     "Select Document Type",
                                    //                 style: AppTextStyle
                                    //                     .font14OpenSansRegularBlack45TextStyle,
                                    //               ),
                                    //             ),
                                    //             value: _dropDownRequiredDocumentType,
                                    //             onChanged: (newValue) {
                                    //               setState(() {
                                    //                 _dropDownRequiredDocumentType = newValue;
                                    //                 bindMutationDocList.forEach((element) {
                                    //                   if (element["sDocReq"] == _dropDownRequiredDocumentType) {
                                    //                     // RatePerDay
                                    //                     //_selectedWardId = element['iCommunityHallId'];
                                    //                     // iTradeCode   fLicenceFees
                                    //                      _dropDownRequiredDocumentTypeCode = element['iDocCode'];
                                    //                     // _dropDownTradeSubCategoryFeesCode = element['fLicenceFees'];
                                    //                   }
                                    //                 });
                                    //
                                    //                 if (_dropDownRequiredDocumentTypeCode != null) {
                                    //                   /// remove the comment
                                    //                   setState(() {
                                    //                     // call a api if needs
                                    //                     print("---2497--Fees----$_dropDownRequiredDocumentTypeCode");
                                    //                     //  _dropDownDocument2
                                    //                     //print("---587------$_dropDownDocument2");
                                    //                     // bindCommunityHallDate(_dropDownPremisesWardCode);
                                    //                   });
                                    //                 } else {
                                    //                   //toast
                                    //                 }
                                    //                // print("------373--DropDownnCategory Code----$_dropDownTradeCategoryCode");
                                    //               });
                                    //             },
                                    //             items: bindMutationDocList.map((dynamic item) {
                                    //               return DropdownMenuItem(
                                    //                 value: item["sDocReq"].toString(),
                                    //                 child: Row(
                                    //                   children: [
                                    //                     Expanded(
                                    //                       child: Text(
                                    //                         item['sDocReq']
                                    //                             .toString(),
                                    //                         overflow:
                                    //                             TextOverflow
                                    //                                 .ellipsis,
                                    //                         style: AppTextStyle
                                    //                             .font14OpenSansRegularBlack45TextStyle,
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               );
                                    //             }).toList(),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleWithSpacing(),
                                          const SizedBox(width: 8),
                                          // Space between the circle and text
                                          Text('Supporting Document',
                                              style: AppTextStyle
                                                  .font14OpenSansRegularBlack45TextStyle),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Selected Images
                                    GestureDetector(
                                      onTap: () {
                                        if (uplodedImage!
                                            .toLowerCase()
                                            .endsWith(
                                          '.pdf',
                                        )) {
                                          print(
                                            "PDF tapped: $uplodedImage",
                                          );
                                          // Open PDF in browser or PDF viewer
                                          openPdf(
                                            context,
                                            uplodedImage!,
                                          );
                                        } else {
                                          print(
                                            "Image tapped: $uplodedImage",
                                          );
                                          // Open image in full screen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Scaffold(
                                                appBar: AppBar(
                                                  title: const Text(
                                                    "Image Preview",
                                                  ),
                                                ),
                                                body: Center(
                                                  child: Image.network(
                                                    uplodedImage!,
                                                    width: double.infinity, // take full width
                                                    fit: BoxFit.cover, // cover the available space
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 150,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors
                                                .grey,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child:
                                        image !=
                                            null
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child:
                                          image!.path.toLowerCase().endsWith(
                                            '.pdf',
                                          )
                                              ? Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: Icon(
                                                Icons.picture_as_pdf,
                                                color: Colors.red,
                                                size: 60,
                                              ),
                                            ),
                                          )
                                              : Image.file(
                                            image!,
                                            width: 200,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                            : const Center(
                                          child: Text(
                                            'No File Available',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        // First Container
                                        GestureDetector(
                                          onTap: () async {
                                            //_pickImageCamra();
                                            SharedPreferences
                                            prefs =
                                            await SharedPreferences.getInstance();
                                            String?
                                            sToken = prefs
                                                .getString(
                                              'sToken',
                                            );

                                            final pickFileid = await _picker.pickImage(
                                              source:
                                              ImageSource.camera,
                                              imageQuality:
                                              65,
                                            );

                                            setState(() {
                                              image = File(
                                                pickFileid!
                                                    .path,
                                              );
                                            });
                                            print(
                                              "----171----pic path : ---$image",
                                            );
                                            if (pickFileid !=
                                                null) {
                                              setState(() {
                                                _imageFiles.add(
                                                  File(
                                                    pickFileid.path,
                                                  ),
                                                ); // Add selected image to list
                                                uploadImage(
                                                  sToken!,
                                                  image!,
                                                );
                                              });
                                              print(
                                                "---173--ImageFile--List----$_imageFiles",
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(
                                              8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .black12,
                                              borderRadius:
                                              BorderRadius.circular(
                                                8,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/ic_camera.PNG',
                                                  width:
                                                  25,
                                                  height:
                                                  25,
                                                  fit:
                                                  BoxFit.fill,
                                                ),
                                                const SizedBox(
                                                  width:
                                                  8,
                                                ),
                                                const Text(
                                                  "Photo",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Second Container
                                        GestureDetector(
                                          onTap: () async {
                                            // _pickImageGallry();
                                            File?
                                            selectedFile;
                                            SharedPreferences
                                            prefs =
                                            await SharedPreferences.getInstance();
                                            String?
                                            sToken = prefs
                                                .getString(
                                              'sToken',
                                            );

                                            try {
                                              // Open gallery or file picker
                                              FilePickerResult?
                                              result = await FilePicker.platform.pickFiles(
                                                type:
                                                FileType.custom,
                                                allowedExtensions: [
                                                  'jpg',
                                                  'jpeg',
                                                  'png',
                                                  'pdf',
                                                ],
                                              );

                                              if (result !=
                                                  null &&
                                                  result.files.single.path !=
                                                      null) {
                                                image = File(
                                                  result.files.single.path!,
                                                );
                                                String
                                                filePath =
                                                    image!.path;
                                                print(
                                                  'cted File Path: Sele$filePath',
                                                );

                                                if (filePath.toLowerCase().endsWith(
                                                  '.pdf',
                                                )) {
                                                  print(
                                                    "✅ PDF file selected",
                                                  );
                                                  displayToast(
                                                    'Pdf file is selected',
                                                  );
                                                  setState(() {
                                                    _imageFiles.add(
                                                      File(
                                                        image!.path,
                                                      ),
                                                    ); // Add selected image to list
                                                    uploadImage(
                                                      sToken!,
                                                      image!,
                                                    );
                                                  });
                                                  // Optionally, show PDF icon or preview
                                                } else {
                                                  print(
                                                    "✅ Image file selected",
                                                  );
                                                  setState(() {
                                                    _imageFiles.add(
                                                      File(
                                                        image!.path,
                                                      ),
                                                    ); // Add selected image to list
                                                    uploadImage(
                                                      sToken!,
                                                      image!,
                                                    );
                                                  });
                                                  // Optionally, show image preview in UI
                                                }

                                                // ✅ Upload File
                                                if (sToken !=
                                                    null) {
                                                  print(
                                                    "-----------581---------",
                                                  );
                                                  print(
                                                    "-----------selectedPath---------$image",
                                                  );

                                                  uploadImage(
                                                    sToken,
                                                    image!,
                                                  );
                                                } else {
                                                  print(
                                                    "❌ Token not found",
                                                  );
                                                }
                                              } else {
                                                print(
                                                  '❌ No file selected',
                                                );
                                              }
                                            } catch (
                                            e
                                            ) {
                                              print(
                                                "❌ Error picking file: $e",
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(
                                              8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .black12,
                                              borderRadius:
                                              BorderRadius.circular(
                                                8,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/ic_camera.PNG',
                                                  width:
                                                  25,
                                                  height:
                                                  25,
                                                  fit:
                                                  BoxFit.cover,
                                                ),
                                                const SizedBox(
                                                  width:
                                                  8,
                                                ),
                                                const Text(
                                                  "Gallery",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Container(
                                    //   height: 150,
                                    //   width: 200,
                                    //   decoration: BoxDecoration(
                                    //     border: Border.all(color: Colors.grey),
                                    //     borderRadius: BorderRadius.circular(10),
                                    //   ),
                                    //   child: image != null
                                    //       ? ClipRRect(
                                    //           borderRadius:
                                    //               BorderRadius.circular(10),
                                    //           child: Image.file(
                                    //             image!,
                                    //             width: 200,
                                    //             height: 150,
                                    //             fit: BoxFit.cover,
                                    //           ),
                                    //         )
                                    //       : const Center(
                                    //           child: Text(
                                    //             'No Image Available',
                                    //             style: TextStyle(
                                    //                 fontSize: 16,
                                    //                 color: Colors.grey),
                                    //           ),
                                    //         ),
                                    // ),
                                    // const SizedBox(height: 10),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceEvenly,
                                    //   children: [
                                    //     // First Container
                                    //     GestureDetector(
                                    //       onTap: () async {
                                    //         // _pickImageCamra();
                                    //         // ----PICK IMAGE FROM A Camera--
                                    //         SharedPreferences prefs =
                                    //             await SharedPreferences
                                    //                 .getInstance();
                                    //         String? sToken =
                                    //             prefs.getString('sToken');
                                    //
                                    //         final pickFileid =
                                    //             await _picker.pickImage(
                                    //                 source: ImageSource.camera,
                                    //                 imageQuality: 65);
                                    //
                                    //         setState(() {
                                    //           image = File(pickFileid!.path);
                                    //         });
                                    //         // image2 = ${pickedFile?.path};
                                    //         // image2 = pickedFile!.path as File?;
                                    //
                                    //         print("----171----pic path : ---$image");
                                    //         if (pickFileid != null) {
                                    //           setState(() {
                                    //             _imageFiles.add(File(pickFileid.path)); // Add selected image to list
                                    //             uploadImage(sToken!, image!);
                                    //           });
                                    //           print(
                                    //               "---2507--ImageFile--List----$_imageFiles");
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         padding: const EdgeInsets.all(8.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.black12,
                                    //           borderRadius:
                                    //               BorderRadius.circular(8),
                                    //         ),
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               'assets/images/ic_camera.PNG',
                                    //               width: 25,
                                    //               height: 25,
                                    //               fit: BoxFit.fill,
                                    //             ),
                                    //             const SizedBox(width: 8),
                                    //             const Text(
                                    //               "Photo",
                                    //               style: TextStyle(
                                    //                   fontSize: 16,
                                    //                   fontWeight:
                                    //                       FontWeight.bold),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     // Second Container
                                    //     GestureDetector(
                                    //       onTap: () async {
                                    //         // _pickImageGallry();
                                    //         //----PickImage Gallery----
                                    //         SharedPreferences prefs = await SharedPreferences
                                    //                 .getInstance();
                                    //         String? sToken = prefs.getString('sToken');
                                    //
                                    //         final pickFileid = await _picker.pickImage(source: ImageSource.gallery,
                                    //                 imageQuality: 65 // Change to `ImageSource.camera` for camera
                                    //                 );
                                    //
                                    //         setState(() {
                                    //           image = File(pickFileid!.path);
                                    //         });
                                    //         if (pickFileid != null) {
                                    //           setState(() {
                                    //             _imageFiles.add(File(pickFileid.path)); // Add selected image to list
                                    //             // to take a image with a path
                                    //             // to update image on a api
                                    //             uploadImage(sToken!, image!);
                                    //           });
                                    //           print(
                                    //               "---185--ImageFile---list---$_imageFiles");
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         padding: const EdgeInsets.all(8.0),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.black12,
                                    //           borderRadius:
                                    //               BorderRadius.circular(8),
                                    //         ),
                                    //         child: Row(
                                    //           children: [
                                    //             Image.asset(
                                    //               'assets/images/ic_camera.PNG',
                                    //               width: 25,
                                    //               height: 25,
                                    //               fit: BoxFit.cover,
                                    //             ),
                                    //             const SizedBox(width: 8),
                                    //             const Text(
                                    //               "Gallery",
                                    //               style: TextStyle(
                                    //                   fontSize: 16,
                                    //                   fontWeight:
                                    //                       FontWeight.bold),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),


                                    const SizedBox(height: 10),

                                    ElevatedButton(
                                      onPressed: () {
                                        if (_dropDownRequiredDocumentTypeCode == null) {
                                          displayToast("Please Select Document");
                                        } else if (uplodedImage == null) {
                                          displayToast(
                                              "Please pick a Document");
                                        } else {
                                          setState(() {
                                            thirdFormCombinedList.add({
                                              'iDocCode': "$_dropDownRequiredDocumentTypeCode",
                                              'sFileName': "$_dropDownRequiredDocumentType",
                                              'sDocUrl': uplodedImage,
                                            });
                                          });
                                          print("Updated List: $thirdFormCombinedList");
                                          // clear parameter
                                          image = null;
                                          uplodedImage = null;
                                          _dropDownRequiredDocumentType = null;
                                          _dropDownRequiredDocumentTypeCode = null;
                                          Navigator.of(context)
                                              .pop(); // Close dialog after updating state
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Positioned(
                                top: -40,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                    'assets/images/licenseRequestuplode.jpeg',
                                  ), // Replace with your image
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: Color(0xFF0098a6),
              padding: const EdgeInsets.all(8.0),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add Photo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.add, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        _imageFiles.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection:
              Axis.horizontal,
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                String filePath =
                    _imageFiles[index].path;
                bool isPdf = filePath.toLowerCase().endsWith('.pdf');

                return Container(
                  margin:
                  const EdgeInsets.only(
                    right: 10.0,
                  ),
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(
                      8.0,
                    ),
                    child: isPdf
                        ? GestureDetector(
                      onTap: (){
                        print('-----Open Pdf--');
                        var pdfFile =   _imageFiles[index];
                        print("pdf path : $pdfFile");

                      },
                          child: Container(
                                                color: Colors
                            .grey[200],
                                                child: const Center(
                          child: Icon(
                            Icons
                                .picture_as_pdf,
                            color: Colors
                                .red,
                            size: 50,
                          ),
                                                ),
                                              ),
                        )
                        : Image.file(
                      _imageFiles[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        )
            : const Center(
          child: Text('No files selected.'),
        ),
        // _imageFiles.isNotEmpty
        //     ? Padding(
        //       padding: const EdgeInsets.only(left: 10,right: 10),
        //       child: SizedBox(
        //                 height: 120,
        //
        //         // Set a fixed height for the horizontal list
        //                 child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       itemCount: _imageFiles.length,
        //       itemBuilder: (context, index) {
        //         return Container(
        //           margin: EdgeInsets.only(right: 10.0),
        //           width: 140, // Set fixed width for the image container
        //           height: 140, // Set fixed height for the image container
        //           decoration: BoxDecoration(
        //             border: Border.all(color: Colors.blue, width: 2.0),
        //             borderRadius: BorderRadius.circular(10.0),
        //           ),
        //           child: ClipRRect(
        //             borderRadius: BorderRadius.circular(8.0),
        //             child: Image.file(
        //               _imageFiles[index],
        //               fit: BoxFit.cover,
        //             ),
        //           ),
        //         );
        //       },
        //                 ),
        //               ),
        //     )
        //     : Center(
        //   child: Text('No images selected.'),
        // ),


        // if (thirdFormCombinedList != null && thirdFormCombinedList.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.only(left: 15, right: 15),
        //     child: Container(
        //         height: 200,
        //         decoration: BoxDecoration(
        //           color: Colors.white, // Optional background color
        //           border: Border.all(
        //             color: Colors.grey, // Gray border color
        //             width: 2.0, // Border width
        //           ),
        //           borderRadius: BorderRadius.circular(10), // Rounded corners
        //         ),
        //         // child: ListView.builder(
        //         //   itemCount: thirdFormCombinedList.length,
        //         //   itemBuilder: (context, index) {
        //         //     final item = thirdFormCombinedList[index];
        //         //     return ListTile(
        //         //       title: Text(item['sDocumentName']),
        //         //       subtitle: Text(item['sDocumentUrl']),
        //         //     );
        //         //   },
        //         // )
        //
        //         child: ListView.builder(
        //           scrollDirection: Axis.horizontal, // Horizontal scrolling
        //           itemCount: thirdFormCombinedList.length,
        //           itemBuilder: (context, index) {
        //             final document = thirdFormCombinedList[index];
        //             final imageUrl = document['sDocumentUrl'] as String?;
        //             final documentName = document['sDocumentName'] as String?;
        //
        //             return Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   Container(
        //                     width: 150,
        //                     height: 150,
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(10),
        //                       border: Border.all(color: Colors.grey),
        //                     ),
        //                     child: imageUrl != null && imageUrl.isNotEmpty
        //                         ? ClipRRect(
        //                       borderRadius: BorderRadius.circular(10),
        //                       child: Image.network(
        //                         imageUrl,
        //                         fit: BoxFit.cover,
        //                         loadingBuilder: (context, child, loadingProgress) {
        //                           if (loadingProgress == null) {
        //                             return child;
        //                           } else {
        //                             return const Center(
        //                               child: CircularProgressIndicator(),
        //                             );
        //                           }
        //                         },
        //                         errorBuilder: (context, error, stackTrace) {
        //                           return const Center(
        //                             child: Text(
        //                               'Error Loading Image',
        //                               style: TextStyle(fontSize: 14, color: Colors.grey),
        //                             ),
        //                           );
        //                         },
        //                       ),
        //                     )
        //                         : const Center(
        //                       child: Text(
        //                         'No Image',
        //                         style: TextStyle(fontSize: 14, color: Colors.grey),
        //                       ),
        //                     ),
        //                   ),
        //                   const SizedBox(height: 5),
        //                   Center(
        //                     child: Text(
        //                       documentName ?? 'Unknown Document',
        //                       style: const TextStyle(
        //                         fontSize: 14,
        //                         color: Colors.black,
        //                       ),
        //                       maxLines: 1,
        //                       overflow: TextOverflow.ellipsis, // Handle long names gracefully
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             );
        //           },
        //         ),
        //         ),
        //   ),
      ],
    );
  }

}
