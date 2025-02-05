import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../../../../services/postLicenseRequest.dart';
import '../../../services/BindWaterTaxTypeRepo.dart';
import '../../../services/PostWaterSupplyTaxRequestRepo.dart';
import '../../circle/circle.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';


class WaterSupplyRequest extends StatefulWidget {

  var name, iCategoryCode;
  var name2, iCategoryCode2;
  var name3, iCategoryCode3;

  WaterSupplyRequest({super.key, required this.name});

  @override
  State<WaterSupplyRequest> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WaterSupplyRequest>
    with TickerProviderStateMixin {
  List stateList = [];
  List<dynamic> subCategoryList = [];

  //List<dynamic> bindcommunityHallDate = [];
  List<Map<String, dynamic>> bindcommunityHallDate = [];
  List<dynamic> premisesWardDropDown = [];
  List<dynamic> bindWaterTextTypeDropDown = [];
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

  // bindCommunityHallDate(var hallId) async {
  //   bindcommunityHallDate = (await BindCommunityHallDateRepo()
  //       .bindCommunityHallDate(context, hallId))!;
  //   print(" -----xxxxx-  bindcommunityHallDate--53--> $bindcommunityHallDate");
  //   setState(() {});
  // }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _OwnerNameController = TextEditingController();
  TextEditingController _houseNoController = TextEditingController();
  TextEditingController _applicationNameController = TextEditingController();
  TextEditingController _applicationMobileController = TextEditingController();
  TextEditingController _applicationAddressController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  FocusNode _OwnerNamefocus = FocusNode();
  FocusNode _houseNofocus = FocusNode();
  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMobilefocus = FocusNode();
  FocusNode _applicationAddressfocus = FocusNode();
  FocusNode _remarksfocus = FocusNode();
  FocusNode _amountfocus = FocusNode();
  FocusNode _descriptionfocus = FocusNode();

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
  var _dropDownDocument;
  var _dropDownDocumentCode;
  var _dropDownFinalYear;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final subCategoryFocus = GlobalKey();
  final wardFocus = GlobalKey();
  File? _imageFile;

  //var _selectedWardId;
  var _dropDownPremisesWardCode;
  var _dropDownTradeCategoryCode;
  var _dropDownWaterTaxTypeCode;
  var _dropDownWaterTaxTyperAmount;
  var _dropDownTradeSubCategoryCode;
  var _dropDownTradeSubCategoryFeesCode;
  var _dropDownDocument2;
  var _dropDownDocument2_code;
  var _dropDownTradeCategory;
  var _dropDownWaterTaxType;
  var _dropDownTradeSubCategory;
  var _dropDownFinalYearCode;
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

  // Track selected states
  List<bool> selectedStates = [];
  Set<int> selectedIndices = {}; // To track selected items by index
  List<dynamic>? consuambleItemList = [];
  List<dynamic>? consuambleItemList2 = [];

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
    premisesWardDropDown = await BindCitizenWardRepo().bindCityZenWard();
    print(" -----Premissesward---->>>>-xx--143-----> $premisesWardDropDown");
    setState(() {});
  }
  //BindWaterTextTypeRepo

  bindWaterTextTypeRepo() async {
    /// todo remove the comment and call Community Hall
    bindWaterTextTypeDropDown = await BindWaterTaxtTypeRepo().bindWaterText();
    print(" -----bindWaterTextTypeDropDown---->>>>-xx--143-----> $bindWaterTextTypeDropDown");
    setState(() {});
  }

  // Financial Year Api call
  finalYearApi() async {
    /// todo remove the comment and call Community Hall
    finalYearDropDown = await BindFinalYearRepo().bindFinalYearWard();
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

  // Bind Sub Category Itrem Api call
  bindTradeSubCategoryApi(dropDownTradeCategoryCode) async {
    /// todo remove the comment and call Community Hall
    bindTradeSubCategory = [];
    bindTradeSubCategory = await BindTradeSubCategoryRepo()
        .bindTradeSubCategory(dropDownTradeCategoryCode);
    print(
        " -----bindTradeSubCategory Repo---->>>>-xx--154-----> $bindTradeSubCategory");
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

  // bind TradeCategory Item
  Widget _bindTradeCategory() {
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
                    text: "Select Trade Category",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownTradeCategory,
                onChanged: (newValue) {
                  bindTradeSubCategory = [];
                  _dropDownTradeSubCategory = null;
                  setState(() {
                    _dropDownTradeCategory = newValue;
                    bindTradeCategory.forEach((element) {
                      if (element["sTradeCategoryName"] ==
                          _dropDownTradeCategory) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownTradeCategoryCode =
                        element['sTradeCategoryCode'];
                      }
                    });
                    if (_dropDownTradeCategoryCode != null) {
                      /// remove the comment
                      print("-----523----$_dropDownTradeCategoryCode");
                      setState(() {
                        // call a api if needs
                        bindTradeSubCategoryApi(_dropDownTradeCategoryCode);

                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                      print("Invalid Trade Category Code");
                    }
                    print(
                        "------373--DropDownnCategory Code----$_dropDownTradeCategoryCode");
                  });
                },

                items: bindTradeCategory.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sTradeCategoryName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sTradeCategoryName'].toString(),
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
  // bindWaterTaxType
  Widget _bindWaterTaxType() {
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
                    text: "Select Water Tax Type",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownWaterTaxType,
                onChanged: (newValue) {
                 // bindTradeSubCategory = [];
                  _dropDownTradeSubCategory = null;
                  setState(() {
                    _dropDownWaterTaxType = newValue;
                    bindWaterTextTypeDropDown.forEach((element) {
                      if (element["sWaterTaxType"] == _dropDownWaterTaxType) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownWaterTaxTypeCode = element['iWaterTaxTypeCode'];
                        _dropDownWaterTaxTyperAmount = element['fAmount'];
                      }
                    });
                    if (_dropDownWaterTaxTypeCode != null) {
                      /// remove the comment
                      print("-----523----$_dropDownWaterTaxTypeCode");
                      setState(() {
                        // call a api if needs
                       // bindTradeSubCategoryApi(_dropDownTradeCategoryCode);

                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                      print("Invalid Trade Category Code");
                    }
                    //print("------373--DropDownnCategory Code----$_dropDownTradeCategoryCode");
                  });
                },

                items: bindWaterTextTypeDropDown.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sWaterTaxType"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sWaterTaxType'].toString(),
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
          .bindCommunityHallDate(context, hallId,selectedMonthCode);
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
    premisesWard();
    finalYearApi();
    bindTradeCategoryApi();
    bindSupportingDocumentApi();
    bindWaterTextTypeRepo();
    super.initState();
    _OwnerNamefocus = FocusNode();
    _houseNofocus = FocusNode();
    _applicationNamefocus = FocusNode();
    _applicationMobilefocus = FocusNode();
    _applicationAddressfocus = FocusNode();
    _remarksfocus = FocusNode();
    _amountfocus = FocusNode();
    if (bindcommunityHallDate.isNotEmpty) {
      selectedStates = List.generate(bindcommunityHallDate.length, (index) => false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _OwnerNamefocus.dispose();
    _houseNofocus.dispose();
    _applicationNamefocus.dispose();
    _applicationMobilefocus.dispose();
    _applicationAddressfocus.dispose();
    _remarksfocus.dispose();
    _amountfocus.dispose();
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
    var OwnerName = _OwnerNameController.text.trim();
    var houseNo = _houseNoController.text.trim();
    var applicationMobileNo = _applicationMobileController.text.trim();
    var applicationAddress = _applicationAddressController.text.trim();
    var remarks = _remarksController.text.trim();
    var amount = _amountController.text.trim();

    //------
    print("-----ward Name-----$_dropDownPremisesWardCode");
    print("-----Owner Name-----$OwnerName");
    print("-----houseNo -----$houseNo");
    // applicationMobileNo
    print("-----applicationMobileNo -----$applicationMobileNo");
    print("-----applicationAddress -----$applicationAddress");
    print("-----remarks -----$remarks");
    print("----list data ---815----$consuambleItemList");


    if (_dropDownPremisesWardCode != null &&
        OwnerName.isNotEmpty &&
        houseNo.isNotEmpty &&
        applicationMobileNo.isNotEmpty &&
        applicationAddress.isNotEmpty &&
        consuambleItemList !=null && consuambleItemList!.isNotEmpty && consuambleItemList!=[]
    ) {
      // All conditions met; call the API
      print('---Call API---');

      /// put these value into the l
      print("-----ward Name-----$_dropDownPremisesWardCode");
      print("-----Owner Name-----$OwnerName");
      print("-----houseNo -----$houseNo");
      // applicationMobileNo
      print("-----applicationMobileNo -----$applicationMobileNo");
      print("-----applicationAddress -----$applicationAddress");
      print("-----remarks -----$remarks");

      firstFormCombinedList.add({
        "iWaterTaxReqId": "$formattedDate",
        "iWardCode": "$_dropDownPremisesWardCode",
        "sHouseOwnerName": OwnerName,
        "sHouseNo": houseNo,
        "sMobileNo": applicationMobileNo,
        "sAddress": applicationAddress,
        "sRemarks": remarks,
        "sCreatedBy": sCreatedBy,
        "WaterSupplyArray": consuambleItemList
      });
      // lIST to convert json string
      String allThreeFormJson = jsonEncode(firstFormCombinedList);
      print("----836---FINAL LIST jsson response---$allThreeFormJson");

      // Call your API logic here
      var onlineComplaintResponse = await PostWaterSupplyTaxRequestRepo()
          .postWaterSupplyTax(context, allThreeFormJson);
      print('----842---xx---$onlineComplaintResponse');
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

      if (_dropDownPremisesWardCode == null) {
        displayToast('Please Select Ward');
        return;
      }
      if (OwnerName.isEmpty) {
        displayToast('Please Enter Owner Name');
        return;
      }
      if (houseNo.isEmpty) {
        displayToast('Please Enter House No');
        return;
      }
      if (applicationMobileNo.isEmpty) {
        displayToast('Please Enter Mobile No');
        return;
      }
      if (applicationAddress.isEmpty) {
        displayToast('Please Enter Address');
        return;
      }if(consuambleItemList!.isEmpty){
        displayToast('Please Uplode Water Supply');
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
                          title: "1. House Owner Details",
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
                        if (isFirstFormVisible)
                          _buildFirstForm(),
                        // Second Section Header
                        _buildSectionHeader(
                          title: "2. Water Supply Detail",
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
                      ]
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

          // Premises Name
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
                    text: 'House No',
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
                        focusNode: _houseNofocus,
                        controller: _houseNoController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
          // Mobile No.
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
                    text: 'Mobile No',
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
                    text: 'Address',
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
          // remarks
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
                    text: 'Remarks',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: '', // The asterisk
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
                        focusNode: _remarksfocus,
                        controller: _remarksController,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add a list to added item on a Add Item
            // if (consuambleItemList!.isNotEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/uplodeTrade.jpeg',
                      height: 25,
                      width: 25,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(width: 10),
                    Text('Uplode Water Supply Item',
                        style:
                        AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  // Makes ListView take up only the needed height
                  physics: NeverScrollableScrollPhysics(),
                  // Disable ListView scrolling if the outer widget scrolls
                  itemCount: consuambleItemList2?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = consuambleItemList2![index];
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          // iTranId = notificationData.iTranId;
                        });
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return _deleteItemDialog(context);
                        //   },
                        // );
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
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    'assets/images/uplodeTrade.jpeg',
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Icon(Icons.error, size: 25);
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['iWardTypeTaxCode'].toString(),
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle),
                                    Text('Water Tax Name',
                                        style: AppTextStyle
                                            .font12OpenSansRegularBlack45TextStyle),
                                  ],
                                ),
                                // Spacer(),
                                // Text(
                                //     'Quantity: ${item['SrNo']}',
                                //     style: AppTextStyle
                                //         .font14OpenSansRegularBlack45TextStyle),
                              ],
                            ),
                            Divider(),
                            Container(
                              height: 45,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 14,
                                              width: 14,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                BorderRadius.circular(7),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(item['sDescription'],
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlackTextStyle),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 15),
                                          child: Text('Description',
                                              style: AppTextStyle
                                                  .font12OpenSansRegularBlack45TextStyle),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    color: Color(0xFF0098a6),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      '₹ ${item['fAmount']}',
                                      style: AppTextStyle
                                          .font14OpenSansRegularWhiteTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Card(
                    elevation: 4, // Adjust the shadow level
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Rounded corners for the card
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
                                    fit: BoxFit
                                        .cover, // Adjusts how the image is fitted
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Uplode Water Supply Item ${consuambleItemList?.length}",
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
                                    // Space between the circle and text
                                    Text('Water Tax Type',
                                      style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                //_bindTradeCategory(),
                                _bindWaterTaxType(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // Align items vertically
                                  children: <Widget>[
                                    CircleWithSpacing(),
                                    // Space between the circle and text
                                    Text(
                                      'Amount',
                                      style: AppTextStyle
                                          .font14OpenSansRegularBlack45TextStyle,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0, right: 0,top: 5),
                                  child: Container(
                                    height: 45,
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 14, right: 14),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child:  Container(
                                              height: 45,
                                              width: MediaQuery.of(context).size.height-20,
                                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFf2f3f5), // Background color
                                                border: Border.all(color: Colors.grey), // Border styling
                                                borderRadius: BorderRadius.circular(4.0), // Border radius
                                              ),
                                              child: Text(
                                                _dropDownWaterTaxTyperAmount == null ? "0" : _dropDownWaterTaxTyperAmount!.toString(), // Apply null-check logic
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            // child: TextFormField(
                                            //   focusNode: _amountfocus,
                                            //   controller: _amountController,
                                            //   textInputAction: TextInputAction.next,
                                            //   onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                            //   decoration: const InputDecoration(
                                            //     border: OutlineInputBorder(),
                                            //     contentPadding: EdgeInsets.symmetric(
                                            //         vertical: 10.0,
                                            //         horizontal: 10.0),
                                            //     filled: true,
                                            //     // Enable background color
                                            //     fillColor: Color(
                                            //         0xFFf2f3f5), // Set your desired background color here
                                            //   ),
                                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                               // _bindTradeSubCategory(),
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
                                          text: 'Description',
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
                                  padding: const EdgeInsets.only(left: 0, right: 0,top: 5),
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
                                              focusNode: _descriptionfocus,
                                              controller: _descriptionController,
                                              textInputAction: TextInputAction.next,
                                              onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
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
                                GestureDetector(
                                  onTap: () {
                                    count++;
                                    // Registration
                                    // consuambleItemList=[];

                                    //   _dropDownWaterTaxTypeCode
                                    var description = _descriptionController.text;
                                    print('-----1354---');
                                    print("--------DropDownTaxType----$_dropDownWaterTaxType");
                                    print("-----WaterTaxType Amount-----$_dropDownWaterTaxTyperAmount");
                                    print("-----Description-----$description");

                                    if (_dropDownWaterTaxType == null) {
                                      displayToast("Pick a Water Tax Type");
                                      return;
                                    }
                                    if (description=="" && description.isEmpty) {
                                      displayToast("Please Enter Description");
                                      return;
                                    }
                                    setState(() {
                                      consuambleItemList ??= []; // Initialize the list if it's null
                                      consuambleItemList2 ??= [];
                                      consuambleItemList!.add({
                                        'iWardTypeTaxCode': _dropDownWaterTaxTypeCode,
                                        'fAmount': _dropDownWaterTaxTyperAmount,
                                        'sDescription': description,
                                      });
                                      consuambleItemList2!.add({
                                        'iWardTypeTaxCode': _dropDownWaterTaxType,
                                        'fAmount': _dropDownWaterTaxTyperAmount,
                                        'sDescription': description,
                                      });
                                    });
                                    displayToast("Item Added");
                                    // Added Item into secondFormList

                                    print("----1876--ConSuambleItemList------$consuambleItemList");

                                    // consuambleItemList!.add({
                                    //   'iWardTypeTaxCode': _dropDownWaterTaxTypeCode,
                                    //   'fAmount': _dropDownWaterTaxTyperAmount,
                                    //   'sDescription': description,
                                    // });
                                   // print("Item lIST : --$consuambleItemList");

                                    // firstFormCombinedList.addAll(secondFormCombinedList);
                                    // print("----2045---com first + second list---$firstFormCombinedList");
                                    // setState(() {
                                    //   secondFromjson = jsonEncode(secondFormCombinedList);
                                    // });
                                    // print("-----2067---secondFormData--...---: $secondFromjson");

                                    //  _dropDownTradeSubCategory
                                  },
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      // 10dp padding around the text
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF255899)),
                                        // Gray border color
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Rounded corners for the border
                                      ),
                                      child: Text(
                                        "Add Item",
                                        style: AppTextStyle
                                            .font14penSansBlackTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
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
}
