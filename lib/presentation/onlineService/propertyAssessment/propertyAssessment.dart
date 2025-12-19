import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/generalFunction.dart';
import '../../../../app/loader_helper.dart';
import '../../../../services/BindCitizenWardRepo.dart';
import '../../../../services/baseurl.dart';
import '../../../../services/bindSubCategoryRepo.dart';
import '../../../services/BindDocumentTypePropertyRepo.dart';
import '../../../services/PostHouseHoldDetailRequestRepo.dart';
import '../../circle/circle.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';

class PropertyAssessment extends StatefulWidget {

  var name;
  PropertyAssessment({super.key, required this.name});

  @override
  State<PropertyAssessment> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PropertyAssessment> with TickerProviderStateMixin {

  List stateList = [];
  List<dynamic> subCategoryList = [];
  List<Map<String, dynamic>> bindcommunityHallDate = [];
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
  List<dynamic> bindDocumentTypePropertyList = [];

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
    subCategoryList = (await BindSubCategoryRepo().bindSubCategory(
      context,
      subCategoryCode,
    ))!;
    setState(() {});
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _houseNoController = TextEditingController();
  TextEditingController _surveyNoController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _houseAddressController = TextEditingController();
  TextEditingController _totalCarpetAreaController = TextEditingController();

  //-------------Residental Details TextFormField Controller.-----

  TextEditingController _basementSqFtController = TextEditingController();
  TextEditingController _groundFloorSqFtController = TextEditingController();
  TextEditingController _firstFloorSqFtController = TextEditingController();
  TextEditingController _secondFloorSqFtController = TextEditingController();
  TextEditingController _thirdFloorSqFtController = TextEditingController();

  TextEditingController _totalResidentialProperySqFtController =
      TextEditingController();
  TextEditingController _residentalRentalAreaController =
      TextEditingController();
  TextEditingController _rentOfTheResidentialRentalPropertyController =
      TextEditingController();
  TextEditingController _nonResidentialPropertyController =
      TextEditingController();
  TextEditingController _useOfNonResidentialPropertyController =
      TextEditingController();

  //  ------Commercial Property Detail--------

  TextEditingController _basementSqFtCommercialController =
      TextEditingController();
  TextEditingController _groundFloorSqFtCommercialController =
      TextEditingController();
  TextEditingController _firstFloorSqFtCommercialController =
      TextEditingController();
  TextEditingController _secondFloorSqFtCommercialController =
      TextEditingController();
  TextEditingController _thirdFloorSqFtCommercialController =
      TextEditingController();
  TextEditingController _mezzanineFloorsProperyController =
      TextEditingController();
  TextEditingController _totalResidentialPropertyCommercialController =
      TextEditingController();
  TextEditingController _residentalRentalAreaCommercialController =
      TextEditingController();
  TextEditingController
  _rentOfTheResidentialRentalPropertyCommercialController =
      TextEditingController();
  TextEditingController _nonResidentialPropertyCommercialController =
      TextEditingController();
  TextEditingController _useOfNonResidentialCommercialController =
      TextEditingController();

  // Focus on a TextForm

  FocusNode _houseNofocus = FocusNode();
  FocusNode _surveyNofocus = FocusNode();
  FocusNode _ownerNamefocus = FocusNode();
  FocusNode _mobileNofocus = FocusNode();
  FocusNode _houseAddressfocus = FocusNode();
  FocusNode _totalCarpetAreafocus = FocusNode();
  // Residentaial Details
  FocusNode _basementSqFtfocus = FocusNode();
  FocusNode _groundFloorSqFtfocus = FocusNode();
  FocusNode _firstFloorSqFtfocus = FocusNode();
  FocusNode _secondFloorSqFtfocus = FocusNode();
  FocusNode _thirdFloorSqFtfocus = FocusNode();
  FocusNode _totalResidentialProperySqFtfocus = FocusNode();
  FocusNode _residentalRentalAreafocus = FocusNode();
  FocusNode _rentOfTheResidentialRentalPropertyfocus = FocusNode();
  FocusNode _nonResidentialPropertyfocus = FocusNode();
  FocusNode _useOfNonResidentialPropertyfocus = FocusNode();
  // Commercial Property focus
  FocusNode _basementSqFtCommercialfocus = FocusNode();
  FocusNode _groundFloorSqFtCommercialfocus = FocusNode();
  FocusNode _firstFloorSqFtCommercialfocus = FocusNode();
  FocusNode _secondFloorSqFtCommercialfocus = FocusNode();
  FocusNode _thirdFloorSqFtCommercialfocus = FocusNode();
  FocusNode _mezzanineFloorsProperyCommercialfocus = FocusNode();
  FocusNode _totalResidentialPropertyCommercialfocus = FocusNode();
  FocusNode _residentalRentalAreaCommercialfocus = FocusNode();
  FocusNode _rentOfTheResidentialRentalPropertyCommercialfocus = FocusNode();
  FocusNode _nonResidentialPropertyCommercialfocus = FocusNode();
  FocusNode _useOfNonResidentialCommercialfocus = FocusNode();

  FocusNode _OwnerNamefocus = FocusNode();
  FocusNode _premisesAddressfocus = FocusNode();
  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMobilefocus = FocusNode();
  FocusNode _applicationAddressfocus = FocusNode();
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
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final subCategoryFocus = GlobalKey();
  final wardFocus = GlobalKey();
  var _dropDownPremisesWardCode;
  var _dropDownTradeCategoryCode;
  var _dropDownDocument2;
  var _dropDownRequiredDocumentType;
  var _dropDownRequiredDocumentTypeCode;
  var _dropDownDocument2_code;
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
  //FilePickerResult? result;

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
  // Track selected states

  List<bool> selectedStates = [];
  Set<int> selectedIndices = {}; // To track selected items by index
  List<dynamic>? consuambleItemList = [];

  // firstPage secondPage and ThirdPage

  bool isFirstFormVisible = true;
  bool isSecondFormVisible = true;
  bool isCommercialFormVisible = true;
  bool isThirdFormVisible = true;

  bool isFirstIconRotated = false;
  bool isSecondIconRotated = false;
  bool isCommercialIconRotated = false;
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
  String _selectedOption = "";
  //
  DateTime? _selectedDate; // To store the selected date
  String _formattedDate = '';
  var countTextFieldValue = 0;
  var residentialCount;
  var commercialCount;
  var uplodePhoto = "3";
  //
  num thirdVariable = 0;
  // int thirdVariable = 0;
  num commercialVariable = 0;
  double basementPreviousValue = 0;
  double groundFloorPreviousValue = 0;
  double firstFloorPreviousValue = 0;
  double secondFloorPreviousValue = 0;
  double thirdFloorPreviousValue = 0;
  // Commercial Property
  double basementCommercialPreviousValue = 0;
  double groundFloorCommercialPreviousValue = 0;
  double firstFloorCommercialPreviousValue = 0;
  double secondFloorCommercialPreviousValue = 0;
  double thirdFloorCommercialPreviousValue = 0;
  double mazzanineCommercialPreviousValue = 0;
  String selectedUnit = 'Sq Ft';

  // ---selectDate---

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date as default
      firstDate: DateTime(2000), // Earliest allowed date
      lastDate: DateTime(2100), // Latest allowed date
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // Update selected date
        _formattedDate = DateFormat(
          'dd/MMM/yyyy',
        ).format(_selectedDate!); // Format the date
      });
    }
    print("----Selected Date ---- $_formattedDate");
  }

  Widget buildImageWidget(String? imageUrl) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(imageUrl, width: 200, height: 200, fit: BoxFit.cover)
        : const Text(
            'No Image',
            style: TextStyle(fontSize: 16, color: Colors.grey),
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
      var request = http.MultipartRequest('POST', Uri.parse('$uploadImageApi'));
      // Add headers
      //request.headers['token'] = '04605D46-74B1-4766-9976-921EE7E700A6';
      request.headers['token'] = token;
      request.headers['sFolder'] = 'CompImage';
      // Add the image file as a part of the request
      request.files.add(
        await http.MultipartFile.fromPath('sFolder', imageFile.path),
      );
      // Send the request
      var streamedResponse = await request.send();
      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body); // No explicit type casting
      print("---------544--------$responseData");
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        setState(() {
          uplodedImage = responseData['Data'][0]['sImagePath'];
          // update list

        });
        print('Uploaded Image Path----548----xxxxx----: $uplodedImage');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  premisesWard() async {
    /// todo remove the comment and call Community Hall
    premisesWardDropDown = await BindCitizenWardRepo().bindCityZenWard(context);
    print(" -----Premissesward---->>>>-xx--143-----> $premisesWardDropDown");
    setState(() {});
  }

  bindSupportingDocumentPropertyApi() async {
    /// todo remove the comment and call Community Hall
    bindDocumentTypePropertyList = await BindDocumentTypePropertyRepo()
        .bindDocumentyTypeProperty();
    print(" -----bindDocumnent Property Repo---->>>>-xx--154-----> $bindDocumentTypePropertyList",
    );
    setState(() {});
  }

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

  // logic to TextFormField to calculate value
  void _updateValue(
    String value,
    double previousValue,
    Function(double) setPreviousValue,
  ) {
    double newValue = double.tryParse(value) ?? 0.0;
    setState(() {
      // Adjust the thirdVariable by subtracting the previous value and adding the new one
      thirdVariable = thirdVariable - previousValue + newValue;
      setPreviousValue(newValue);
    });
  }

  void _updateValueCommercial(
      String value,
      double previousValue,
      Function(double) setPreviousValue,
      ) {
    //int newValue = int.tryParse(value) ?? 0;
    double newValue = double.tryParse(value) ?? 0.0;
    setState(() {
      // Adjust the thirdVariable by subtracting the previous value and adding the new one
      commercialVariable = commercialVariable - previousValue + newValue;
      setPreviousValue(newValue);
    });
  }

  @override
  void initState() {
    premisesWard();
    bindSupportingDocumentPropertyApi();
    thirdFormCombinedList = [];
    super.initState();
    _OwnerNamefocus = FocusNode();
    _premisesAddressfocus = FocusNode();
    _applicationNamefocus = FocusNode();
    _applicationMobilefocus = FocusNode();
    _applicationAddressfocus = FocusNode();

    if (bindcommunityHallDate.isNotEmpty) {
      selectedStates = List.generate(
        bindcommunityHallDate.length,
        (index) => false,
      );
    }
    // Focus node
    _houseNofocus = FocusNode();
    _surveyNofocus = FocusNode();
    _ownerNamefocus = FocusNode();
    _mobileNofocus = FocusNode();
    _houseAddressfocus = FocusNode();
    _totalCarpetAreafocus = FocusNode();
    // Residential Details.
    _basementSqFtfocus = FocusNode();
    _groundFloorSqFtfocus = FocusNode();
    _firstFloorSqFtfocus = FocusNode();
    _secondFloorSqFtfocus = FocusNode();
    _thirdFloorSqFtfocus = FocusNode();
    _totalResidentialProperySqFtfocus = FocusNode();
    _residentalRentalAreafocus = FocusNode();
    _rentOfTheResidentialRentalPropertyfocus = FocusNode();
    _nonResidentialPropertyfocus = FocusNode();
    _useOfNonResidentialPropertyfocus = FocusNode();
    // CommercialProperty
    _basementSqFtCommercialfocus = FocusNode();
    _groundFloorSqFtCommercialfocus = FocusNode();
    _firstFloorSqFtCommercialfocus = FocusNode();
    _secondFloorSqFtCommercialfocus = FocusNode();
    _thirdFloorSqFtCommercialfocus = FocusNode();
    _mezzanineFloorsProperyCommercialfocus = FocusNode();
    _totalResidentialPropertyCommercialfocus = FocusNode();
    _residentalRentalAreaCommercialfocus = FocusNode();
    _rentOfTheResidentialRentalPropertyCommercialfocus = FocusNode();
    _nonResidentialPropertyCommercialfocus = FocusNode();
    _useOfNonResidentialCommercialfocus = FocusNode();
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
    // controllerDispose
    _houseNoController.dispose();
    _surveyNoController.dispose();
    _ownerNameController.dispose();
    _mobileNoController.dispose();
    _houseAddressController.dispose();
    _totalCarpetAreaController.dispose();
    _basementSqFtController.dispose();
    _groundFloorSqFtController.dispose();
    _firstFloorSqFtController.dispose();
    _secondFloorSqFtController.dispose();
    _thirdFloorSqFtController.dispose();
    _totalResidentialProperySqFtController.dispose();
    _residentalRentalAreaController.dispose();
    _rentOfTheResidentialRentalPropertyController.dispose();
    _nonResidentialPropertyController.dispose();
    _useOfNonResidentialPropertyController.dispose();
    _basementSqFtCommercialController.dispose();
    _groundFloorSqFtCommercialController.dispose();
    _firstFloorSqFtCommercialController.dispose();
    _secondFloorSqFtCommercialController.dispose();
    _thirdFloorSqFtCommercialController.dispose();
    _mezzanineFloorsProperyController.dispose();
    _totalResidentialPropertyCommercialController.dispose();
    _residentalRentalAreaCommercialController.dispose();
    _rentOfTheResidentialRentalPropertyCommercialController.dispose();
    _nonResidentialPropertyCommercialController.dispose();
    _useOfNonResidentialCommercialController.dispose();

    FocusScope.of(context).unfocus();
  }

  // Api call Function
  void validateAndCallApi() async {
    firstFormCombinedList = [];
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddHHmmssSS').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sContactNo = prefs.getString('sContactNo');

    // TextFormField values
    //-----------Owner Details-------
    var houseNo = _houseNoController.text.trim();
    var surveyNo = _surveyNoController.text.trim();
    var ownerName = _ownerNameController.text.trim();
    var mobileNo = _mobileNoController.text.trim();
    var houseAddress = _houseAddressController.text.trim();
    var totalCarpetArea = _totalCarpetAreaController.text.trim();
    //----------Residential Details-------
    var basementSq = _basementSqFtController.text.trim();
    var grooundFloorSq = _groundFloorSqFtController.text.trim();
    var firstFloorSq = _firstFloorSqFtController.text.trim();
    var secondFloorSq = _secondFloorSqFtController.text.trim();
    var thirdFloorSq = _thirdFloorSqFtController.text.trim();
    var residentialRentalAreaSf = _residentalRentalAreaController.text.trim();

    var rentOfTheResidentialRental =
        _rentOfTheResidentialRentalPropertyController.text.trim();
    var nonResidentialProperty = _nonResidentialPropertyController.text.trim();
    var useOfNonResidentialProperty = _useOfNonResidentialPropertyController
        .text
        .trim();
    // -----Commercial Property-----
    var basementSqFtCommercial = _basementSqFtCommercialController.text.trim();
    var groundFloorCommercial = _groundFloorSqFtCommercialController.text
        .trim();
    var firstFloorCommercial = _firstFloorSqFtCommercialController.text.trim();
    var secondFloorCommercial = _secondFloorSqFtCommercialController.text
        .trim();
    var thirdFloorCommercial = _thirdFloorSqFtCommercialController.text.trim();
    var mazzanineFloorsProperty = _mezzanineFloorsProperyController.text.trim();
    var totalResidentialPropertyCommercial =
        _totalResidentialPropertyCommercialController.text.trim();
    var residentialRentalAreaCommercial = _residentalRentalAreaCommercialController
        .text
        .trim(); // _rentOfTheResidentialRentalPropertyCommercialController.text.trim();
    var rentOfTheResidentialRentalCommercial =
        _rentOfTheResidentialRentalPropertyCommercialController.text.trim();
    var nonResidentialPropertyCommercial =
        _nonResidentialPropertyCommercialController.text.trim();
    var useOfNonResidentialPropertyCommercial =
        _useOfNonResidentialCommercialController.text.trim();

    // contact no
    if (_dropDownPremisesWardCode != null &&
        houseNo.isNotEmpty &&
        surveyNo.isNotEmpty &&
        ownerName.isNotEmpty &&
        mobileNo.isNotEmpty &&
        houseAddress.isNotEmpty &&
        totalCarpetArea.isNotEmpty &&
        _formattedDate.isNotEmpty) {
      // All conditions met; call the API
      print('---Call API---');

      firstFormCombinedList.add({
        "sHouseHoldRequestId": formattedDate,
        "iWardCode": "$_dropDownPremisesWardCode",                 //  "iWardCode": _dropDownPremisesWardCode,
        "sHouseNo": houseNo,
        "sHouseOwnerName": ownerName,
        "sHouseAddress": houseAddress,
        "dConstructionYear": _formattedDate,
        "sPropertyType": _selectedOption,
        "fGFResidential": grooundFloorSq,
        "fFFResidential": firstFloorSq,
        "fSFResidential": secondFloorSq,
        "fTFResidential": thirdFloorSq,
        "fBasementResidential": basementSq,
        "fTotalResidentialArea": "$thirdVariable",
        "fTotalNonResidentialArea": nonResidentialProperty,
        "sUsesNonResidentialArea": useOfNonResidentialProperty,
        "fGFCommercial": groundFloorCommercial,
        "fFFCommercial": firstFloorCommercial,
        "fSFCommercial": secondFloorCommercial,
        "fTFCommercial": thirdFloorCommercial,
        "fMezzFCommercial": mazzanineFloorsProperty,
        "fBasementCommercial": basementSqFtCommercial,
        "fTotalCommercialArea": "$commercialVariable",
        "fTotalRentalCommercialArea": residentialRentalAreaCommercial,
        "fTotalRentRentalCommercialArea": rentOfTheResidentialRentalCommercial,
        "fTotalNonCommercialArea": nonResidentialPropertyCommercial,
        "sUsesNonCommercialArea": useOfNonResidentialPropertyCommercial,
        "fTotalCarpetArea": totalCarpetArea,
        "sMobileNo": mobileNo,
        "sAppliedBy": sContactNo,
        "fTotalRentalResidentialArea": "$residentialRentalAreaSf",             //"fTotalRentalResidentialArea": residentialRentalAreaSf,
        "RentOfTotalRentalResidentialArea": rentOfTheResidentialRental,
        "sSurveyNo": surveyNo,
        "sSelectUnitType":selectedUnit,
        "DocumentUploadList": thirdFormCombinedList,

      });
      String allThreeFormJson = jsonEncode(firstFormCombinedList);
      debugPrint(allThreeFormJson, wrapWidth: 1024);
      // -----call Api ------

      var posthouseHoldDetailRequest = await PostHouseHoldDetailRequestRepo()
          .postHouseHoldDetailRequestRepo(context, allThreeFormJson);

      print('----665---$posthouseHoldDetailRequest');

      result2 = posthouseHoldDetailRequest['Result'];
      msg2 = posthouseHoldDetailRequest['Msg'];

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

      if (_formattedDate.isEmpty) {
        displayToast('Please Select Date');
        return;
      }
      if (_dropDownPremisesWard == null) {
        displayToast('Please Select Ward');
        return;
      }
      if (houseNo.isEmpty) {
        displayToast('Please Enter House No / Property No');
        return;
      }
      if (surveyNo.isEmpty) {
        displayToast('Please Enter Servey  No');
        return;
      }
      if (ownerName.isEmpty) {
        displayToast('Please Enter Owner Name');
        return;
      }
      if (mobileNo.isEmpty) {
        displayToast('Please Enter Mobile No');
        return;
      }
      if (houseAddress.isEmpty) {
        displayToast('Please Enter House Address');
        return;
      }
      if (totalCarpetArea.isEmpty) {
        displayToast('Please Total Carpet Area');
        return;
      }
    }
  }

  // pick pdf and images form a gallery
  // ImageCamra code
  Future pickImageCamra() async {
    image = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  Future pickGallery() async {
    File? selectedFile;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');

    try {
      // Open gallery or file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile = File(result.files.single.path!);
        String filePath = selectedFile.path;
        print('cted File Path: Sele$filePath');

        if (filePath.toLowerCase().endsWith('.pdf')) {
          print("✅ PDF file selected");
          print("-----------573---------");
          // Optionally, show PDF icon or preview
        } else {
          print("✅ Image file selected");
          // Optionally, show image preview in UI
        }

        // ✅ Upload File
        if (sToken != null) {
          print("-----------581---------");
          print("-----------selectedPath---------$selectedFile");

          uploadImage(sToken, selectedFile);
        } else {
          print("❌ Token not found");
        }
      } else {
        print('❌ No file selected');
      }
    } catch (e) {
      print("❌ Error picking file: $e");
    }
  }

  // pdf open code
  void openPdf(BuildContext context, String pdfUrl) async {
    if (await canLaunchUrl(Uri.parse(pdfUrl))) {
      await launchUrl(Uri.parse(pdfUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cannot open PDF")));
    }
  }

  // card with photo and gallery with pdf
  Widget buildPdfCard({
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[300],
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity, // Take full available width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image or PDF section
            GestureDetector(
              onTap: () {
                if (uplodedImage!.toLowerCase().endsWith('.pdf')) {
                  print("PDF tapped: $uplodedImage");
                  // Open PDF in browser or PDF viewer
                  openPdf(context, uplodedImage!);
                } else {
                  print("Image tapped: $uplodedImage");
                  // Open image in full screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: const Text("Image Preview")),
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
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: uplodedImage != null && uplodedImage!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: uplodedImage!.toLowerCase().endsWith('.pdf')
                            ? const Center(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  size: 100,
                                  color: Colors.red,
                                ),
                              )
                            : Image.network(
                                uplodedImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover, // Fill container
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.broken_image,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                              ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.picture_as_pdf,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 10),
            // Photo and Gallery options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: onCameraTap,
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.blueAccent),
                      SizedBox(width: 5),
                      Text("Photo"),
                    ],
                  ),
                ),
                Container(height: 20, width: 1, color: Colors.grey.shade400),
                InkWell(
                  onTap: onGalleryTap,
                  child: const Row(
                    children: [
                      Icon(Icons.photo_library, color: Colors.green),
                      SizedBox(width: 5),
                      Text("Gallery"),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            // backgroundColor: Colors.blu
            centerTitle: true,
            backgroundColor: Color(0xFF255898),
            leading: GestureDetector(
              onTap: () {
                print("------back---");
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        print("-------722---");
                        _selectDate(context);
                      },
                      // _selectedDate
                      child: Container(
                        height: 60,
                        color: Colors.black12,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // First widget: Container with an image
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/datepicker.jpeg',
                                        ), // Replace with your asset path
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10), // Spacing between widgets
                                // Second widget: Column with two Text widgets
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Align text to the left
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Center vertically
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Construction Start Date',
                                        // The normal text
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                        // Default style
                                        children: const [
                                          TextSpan(
                                            text: ' *', // The asterisk
                                            style: TextStyle(
                                              color: Colors
                                                  .red, // Red color for the asterisk
                                              fontWeight: FontWeight
                                                  .bold, // Optional: Make the asterisk bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      _formattedDate == null
                                          ? 'No date selected'
                                          : '${_formattedDate}',
                                      style: AppTextStyle
                                          .font16OpenSansRegularBlackTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildSectionHeader(
                    title: "1. Owner Details",
                    isVisible: isFirstFormVisible,
                    isIconRotated: isFirstIconRotated,
                    color: Color(0xFFdac5e4),
                    onToggle: () {
                      setState(() {
                        isFirstFormVisible = !isFirstFormVisible;
                        isFirstIconRotated = !isFirstIconRotated;
                      });
                    },
                  ),
                  // First Form Content
                  if (isFirstFormVisible) _buildFirstForm(),
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
                        AppMargin.m10,
                      ), // Rounded corners
                    ),
                    //  #00b3c7
                    child: Center(
                      child: Text(
                        "Submit",
                        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader({
    required String title,
    required bool isVisible,
    required bool isIconRotated,
    required VoidCallback onToggle,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: color, // Custom background color
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
                    text: 'House No / Property No',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _houseNofocus,
                          controller: _houseNoController,
                          textInputAction: TextInputAction.next,
                          //keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            filled: true, // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Survey No
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
                    text: 'Survey No',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _surveyNofocus,
                          controller: _surveyNoController,
                          textInputAction: TextInputAction.next,
                          //keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(
                              r'^\d{1,8}(\.\d{0,2})?$',
                            ).hasMatch(value)) {
                              //return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Owner name
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _ownerNamefocus,
                          controller: _ownerNameController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _mobileNofocus,
                          controller: _mobileNoController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
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
          ),
          // House Address'
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
                    text: 'House Address',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _houseAddressfocus,
                          controller: _houseAddressController,
                          // keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // total Area land BooleanValue
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
                    text: 'Select Units',
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
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SQ FT Radio
                Row(
                  children: [
                    Radio<String>(
                      value: 'Sq. ft.',
                      groupValue: selectedUnit,
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value!;
                        });
                        print("---1643---$selectedUnit");
                      },
                    ),
                    const Text('Sq Ft .'),
                  ],
                ),
                // SQ MT Radio
                Row(
                  children: [
                    Radio<String>(
                      value: 'Sq. m.',
                      groupValue: selectedUnit,
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value!;
                        });
                        print("---1658---$selectedUnit");
                      },
                    ),
                    const Text('Sq Mt .'),
                  ],
                ),

              ],
            ),
          ),
          SizedBox(height: 5),
          // Total Carpet Area
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
                    text: 'Total Area of Land/Plot',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _totalCarpetAreafocus,
                          controller: _totalCarpetAreaController,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),

                          // keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          // ✅ Validator
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
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
                    text: 'Property Type',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: "Residential",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                        residentialCount = "2";
                      });
                      print("-------1427---$_selectedOption");
                    },
                  ),
                  Text("Residential"),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: "Commercial",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                        commercialCount = "2";
                      });
                      print("-------1427---$_selectedOption");
                    },
                  ),
                  Text("Commercial"),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: "Both",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                        residentialCount = "2";
                        commercialCount = "3";
                        uplodePhoto = "4";
                      });
                      print("-------1427---$_selectedOption");
                    },
                  ),
                  Text("Both"),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          if (_selectedOption == "Residential")
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: "2. Residential Details",
                    isVisible: isSecondFormVisible,
                    isIconRotated: isSecondIconRotated,
                    color: Color(0xFFf0cea9),
                    onToggle: () {
                      setState(() {
                        isSecondFormVisible = !isSecondFormVisible;
                        isSecondIconRotated = !isSecondIconRotated;
                      });
                    },
                  ),
                  // Second Form Content
                  if (isSecondFormVisible) _buildSecondForm(),
                  //--------ThirdForm----
                  _buildSectionHeader(
                    title: "3. Uplode Photos",
                    isVisible: isThirdFormVisible,
                    isIconRotated: isThirdIconRotated,
                    color: Color(0xFFdac5e4),
                    onToggle: () {
                      setState(() {
                        isThirdFormVisible = !isThirdFormVisible;
                        isThirdIconRotated = !isThirdIconRotated;
                      });
                    },
                  ),
                  // Third Form Content
                  if (isThirdFormVisible) _buildThirdForm(),
                  SizedBox(height: 5),
                ],
              ),
            ),
          if (_selectedOption == "Commercial")
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --Commercial-----
                  _buildSectionHeader(
                    title: "${commercialCount}. Commercial Property Detail",
                    isVisible: isCommercialFormVisible,
                    isIconRotated: isCommercialIconRotated,
                    color: Color(0xFFdac5e4),
                    onToggle: () {
                      setState(() {
                        isCommercialFormVisible = !isCommercialFormVisible;
                        isCommercialIconRotated = !isCommercialIconRotated;
                      });
                    },
                  ),
                  // Second Form Content
                  if (isCommercialFormVisible)
                    _buildCommercialPropertyDetailForm(),
                  //-----third FORM
                  _buildSectionHeader(
                    title: "3. Uplode Photos",
                    isVisible: isThirdFormVisible,
                    isIconRotated: isThirdIconRotated,
                    color: Color(0xFFdac5e4),
                    onToggle: () {
                      setState(() {
                        isThirdFormVisible = !isThirdFormVisible;
                        isThirdIconRotated = !isThirdIconRotated;
                      });
                    },
                  ),
                  // Third Form Content
                  if (isThirdFormVisible) _buildThirdForm(),
                  SizedBox(height: 5),
                ],
              ),
            ),
          if (_selectedOption == "Both")
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: "${residentialCount}. Residential Details",
                    isVisible: isSecondFormVisible,
                    isIconRotated: isSecondIconRotated,
                    color: Color(0xFFf0cea9),
                    onToggle: () {
                      setState(() {
                        isSecondFormVisible = !isSecondFormVisible;
                        isSecondIconRotated = !isSecondIconRotated;
                      });
                    },
                  ),
                  // Second Form Content
                  if (isSecondFormVisible) _buildSecondForm(),
                  // build Commercil Form
                  _buildSectionHeader(
                    title: "${commercialCount}. Commercial Property Detail",
                    isVisible: isCommercialFormVisible,
                    isIconRotated: isCommercialIconRotated,
                    color: Color(0xFFdac5e4),
                    onToggle: () {
                      setState(() {
                        isCommercialFormVisible = !isCommercialFormVisible;
                        isCommercialIconRotated = !isCommercialIconRotated;
                      });
                    },
                  ),
                  // Second Form Content
                  if (isCommercialFormVisible)
                    _buildCommercialPropertyDetailForm(),
                  // build thirdForm
                  _buildSectionHeader(
                    title: "${uplodePhoto}. Upload Photos",
                    isVisible: isThirdFormVisible,
                    isIconRotated: isThirdIconRotated,
                    color: Color(0xFFdac5e4),
                    onToggle: () {
                      setState(() {
                        isThirdFormVisible = !isThirdFormVisible;
                        isThirdIconRotated = !isThirdIconRotated;
                      });
                    },
                  ),
                  // Third Form Content
                  if (isThirdFormVisible) _buildThirdForm(),
                  SizedBox(height: 5),
                ],
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
          // Basement (sq.ft.)'
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
                    text: 'Basement (sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _basementSqFtfocus,
                          controller: _basementSqFtController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.num,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValue(
                            value,
                            basementPreviousValue,
                            (newVal) => basementPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            filled: true, // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Ground Floor (Sq.ft.
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
                    text: 'Ground Floor (Sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _groundFloorSqFtfocus,
                          controller: _groundFloorSqFtController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),

                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValue(
                            value,
                            groundFloorPreviousValue,
                            (newVal) => groundFloorPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // First Floor (sq.ft.)
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
                    text: 'First Floor (sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _firstFloorSqFtfocus,
                          controller: _firstFloorSqFtController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValue(
                            value,
                            firstFloorPreviousValue,
                            (newVal) => firstFloorPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Second Floor (sq.ft.)
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
                    text: 'Second Floor (sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _secondFloorSqFtfocus,
                          controller: _secondFloorSqFtController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValue(
                            value,
                            secondFloorPreviousValue,
                            (newVal) => secondFloorPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        //  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Third Floor (sq.ft)
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
                    text: 'Third Floor (sq.ft)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _thirdFloorSqFtfocus,
                          controller: _thirdFloorSqFtController,
                          //keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValue(
                            value,
                            thirdFloorPreviousValue,
                            (newVal) => thirdFloorPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Total Residential Property (sq.ft.)
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
                    text: 'Total Residential Property (sq.ft.)',
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
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              width: MediaQuery.of(context).size.width - 60,
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFf2f3f5,
                ), // Same background color as the TextFormField
                border: Border.all(
                  color: Colors.grey,
                ), // Border styling similar to OutlineInputBorder
                borderRadius: BorderRadius.circular(4.0), // Rounded corners
              ),
              child: Text(
                thirdVariable
                    .toString(), // Display the value from the controller
                style: const TextStyle(
                  fontSize: 16.0, // Match the font size as per your need
                  color: Colors.black, // Adjust text color
                ),
              ),
            ),
          ),
          // Residential Rental Area (Square feet)
          SizedBox(height: 5),
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
                    text: 'Residential Rental Area (Square feet)',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _residentalRentalAreafocus,
                          controller: _residentalRentalAreaController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Rent of the Residential Rental Property
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
                    text: 'Rent of the Residential Rental Property',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _rentOfTheResidentialRentalPropertyfocus,
                          controller:
                              _rentOfTheResidentialRentalPropertyController,
                          textInputAction: TextInputAction.next,

                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Non-Residential Property (sq.ft.)
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
                    text: 'Non-Residential Property (sq.ft.)',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _nonResidentialPropertyfocus,
                          controller: _nonResidentialPropertyController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Use of Non-Residential Property'
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
                    text: 'Use of Non-Residential Property',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _useOfNonResidentialPropertyfocus,
                          controller: _useOfNonResidentialPropertyController,
                          //  textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          // ✅ Validator
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(
                              r'^\d{1,8}(\.\d{0,2})?$',
                            ).hasMatch(value)) {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CommercialProperty Detail
  Widget _buildCommercialPropertyDetailForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          // Basement (sq.ft.)'
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
                    text: 'Basement (sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _basementSqFtCommercialfocus,
                          controller: _basementSqFtCommercialController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValueCommercial(
                            value,
                            groundFloorCommercialPreviousValue,
                            (newVal) =>
                                groundFloorCommercialPreviousValue = newVal,
                          ),

                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            filled: true, // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Ground Floor (Sq.ft.
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
                    text: 'Ground Floor (Sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _groundFloorSqFtCommercialfocus,
                          controller: _groundFloorSqFtCommercialController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValueCommercial(
                            value,
                            basementCommercialPreviousValue,
                            (newVal) => basementCommercialPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // First Floor (sq.ft.)
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
                    text: 'First Floor (sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _firstFloorSqFtCommercialfocus,
                          controller: _firstFloorSqFtCommercialController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValueCommercial(
                            value,
                            firstFloorCommercialPreviousValue,
                            (newVal) =>
                                firstFloorCommercialPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Second Floor (sq.ft.)
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
                    text: 'Second Floor (sq.ft.)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _secondFloorSqFtCommercialfocus,
                          controller: _secondFloorSqFtCommercialController,
                          // textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                         // keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValueCommercial(
                            value,
                            secondFloorCommercialPreviousValue,
                            (newVal) =>
                                secondFloorCommercialPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Third Floor (sq.ft)
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
                    text: 'Third Floor (sq.ft)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _thirdFloorSqFtCommercialfocus,
                          controller: _thirdFloorSqFtCommercialController,
                          //keyboardType: TextInputType.number,
                          // textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValueCommercial(
                            value,
                            thirdFloorCommercialPreviousValue,
                            (newVal) =>
                                thirdFloorCommercialPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Mezzanice Floors Property
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
                    text: 'Mazzanine Floors Property (sq.ft)',
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
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _mezzanineFloorsProperyCommercialfocus,
                          controller: _mezzanineFloorsProperyController,
                         // keyboardType: TextInputType.number,
                          // textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (value) => _updateValueCommercial(
                            value,
                            mazzanineCommercialPreviousValue,
                            (newVal) => mazzanineCommercialPreviousValue = newVal,
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Total Commercial Property (sq.ft.)
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
                    text: 'Total Commercial Property (sq.ft.)',
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
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFf2f3f5,
                        ), // Same background color as the TextFormField
                        border: Border.all(
                          color: Colors.grey,
                        ), // Border styling similar to OutlineInputBorder
                        borderRadius: BorderRadius.circular(
                          4.0,
                        ), // Rounded corners
                      ),
                      child: Text(
                        commercialVariable
                            .toString(), // Display the value from the controller
                        style: const TextStyle(
                          fontSize:
                              16.0, // Match the font size as per your need
                          color: Colors.black, // Adjust text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Commercial Rental Area (Square feet)
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
                    text: 'Commercial Rental Area (Square feet)',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _residentalRentalAreaCommercialfocus,
                          controller: _residentalRentalAreaCommercialController,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          //keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Rent of the Residential Rental Property
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
                    text: 'Rent of the Commercial Rental Property',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode:
                              _rentOfTheResidentialRentalPropertyCommercialfocus,
                          controller:
                              _rentOfTheResidentialRentalPropertyCommercialController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          //inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Non-Residential Property (sq.ft.)
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
                    text: 'Non-Commercial Property (sq.ft.)',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _nonResidentialPropertyCommercialfocus,
                          controller: _nonResidentialPropertyCommercialController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            // ✅ Check if value is a valid number with up to 2 decimals
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value))
                            {
                              // return 'Enter numbers only (max 2 decimals)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Use of Non-Residential Property'
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
                    text: 'Use of Non-Commercial Property',
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
                child: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _useOfNonResidentialCommercialfocus,
                          controller: _useOfNonResidentialCommercialController,
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.number,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            // Enable background color
                            fillColor: Color(
                              0xFFf2f3f5,
                            ), // Set your desired background color here
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            top: 50,
                            left: 10,
                            right: 10,
                            bottom: 20,
                          ),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                            FocusScope.of(
                                              context,
                                            ).unfocus(); // Dismiss keyboard
                                          },
                                          hint: RichText(
                                            text: TextSpan(
                                              text: "Select Document Type",
                                              style: AppTextStyle
                                                  .font14OpenSansRegularBlack45TextStyle,
                                            ),
                                          ),
                                          value: _dropDownRequiredDocumentType,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _dropDownRequiredDocumentType =
                                                  newValue;
                                              bindDocumentTypePropertyList.forEach((
                                                element,
                                              ) {
                                                if (element["sDocumentTypeName"] ==
                                                    _dropDownRequiredDocumentType) {
                                                  // RatePerDay
                                                  //_selectedWardId = element['iCommunityHallId'];
                                                  // iTradeCode   fLicenceFees
                                                  _dropDownRequiredDocumentTypeCode =
                                                      element['iDocumentTypeCode'];
                                                  print("----$_dropDownRequiredDocumentTypeCode",
                                                  );
                                                  // _dropDownTradeSubCategoryFeesCode = element['fLicenceFees'];
                                                }
                                              });
                                              if (_dropDownRequiredDocumentTypeCode !=
                                                  null) {
                                                /// remove the comment
                                                setState(() {
                                                  // call a api if needs
                                                  print("---2497--Fees----$_dropDownRequiredDocumentTypeCode",
                                                  );
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
                                          items: bindDocumentTypePropertyList.map((
                                            dynamic item,
                                          ) {
                                            return DropdownMenuItem(
                                              value: item["sDocumentTypeName"]
                                                  .toString(),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item['sDocumentTypeName']
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircleWithSpacing(),
                                    const SizedBox(width: 8),
                                    // Space between the circle and text
                                    Text(
                                      'Supporting Document',
                                      style: AppTextStyle
                                          .font14OpenSansRegularBlack45TextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Selected Images
                              /// todo here we change the code Photo and gallery
                              GestureDetector(
                                onTap: () {
                                  if (uplodedImage!.toLowerCase().endsWith(
                                    '.pdf',
                                  )) {
                                    print("PDF tapped: $uplodedImage");
                                    // Open PDF in browser or PDF viewer
                                    openPdf(context, uplodedImage!);
                                  } else {
                                    print("Image tapped: $uplodedImage");
                                    // Open image in full screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Scaffold(
                                          appBar: AppBar(
                                            title: const Text("Image Preview"),
                                          ),
                                          body: Center(
                                            child: Image.network(
                                              uplodedImage!,
                                              width: double
                                                  .infinity, // take full width
                                              fit: BoxFit
                                                  .cover, // cover the available space
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
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: image != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: image!.path.toLowerCase().endsWith('.pdf')
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
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // First Container
                                  GestureDetector(
                                    onTap: () async {
                                      //_pickImageCamra();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? sToken = prefs.getString(
                                        'sToken',
                                      );

                                      final pickFileid = await _picker
                                          .pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 65,
                                          );

                                      setState(() {
                                        image = File(pickFileid!.path);
                                      });
                                      print("----171----pic path : ---$image");
                                      if (pickFileid != null) {
                                        setState(() {
                                          _imageFiles.add(
                                            File(pickFileid.path),
                                          ); // Add selected image to list
                                          uploadImage(sToken!, image!);
                                        });
                                        print(
                                          "---173--ImageFile--List----$_imageFiles",
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_camera.PNG',
                                            width: 25,
                                            height: 25,
                                            fit: BoxFit.fill,
                                          ),
                                          const SizedBox(width: 8),
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
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? sToken = prefs.getString(
                                        'sToken',
                                      );

                                      try {
                                        // Open gallery or file picker
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                                'jpg',
                                                'jpeg',
                                                'png',
                                                'pdf',
                                              ],
                                            );

                                        if (result != null &&
                                            result.files.single.path != null) {
                                          image = File(result.files.single.path!,
                                          );

                                          String filePath = image!.path;
                                          print('cted File Path: Sele$filePath',
                                          );

                                          if (filePath.toLowerCase().endsWith(
                                            '.pdf',
                                          )) {
                                            print("✅ PDF file selected");
                                            displayToast(
                                              'Pdf file is selected',
                                            );
                                            setState(() {
                                              _imageFiles.add(
                                                File(image!.path),
                                              ); // Add selected image to list
                                              uploadImage(sToken!, image!);
                                            });
                                            // Optionally, show PDF icon or preview
                                          } else {
                                            print("✅ Image file selected");
                                            // setState(() {
                                            //   _imageFiles.add(

                                          }

                                          // ✅ Upload File
                                          if (sToken != null) {
                                            uploadImage(sToken, image!);
                                          } else {
                                            print("❌ Token not found");
                                          }
                                        } else {
                                          print('❌ No file selected');
                                        }
                                      } catch (e) {
                                        print("❌ Error picking file: $e");
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_camera.PNG',
                                            width: 25,
                                            height: 25,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 8),
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
                              const SizedBox(height: 10),

                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (_dropDownRequiredDocumentTypeCode ==
                                      null) {
                                    displayToast("Please Select Document");
                                  } else if (uplodedImage == null) {
                                    displayToast("Please pick a Document");
                                  } else {
                                    setState(() {
                                      thirdFormCombinedList.add({
                                        'iDocumentTypeId':
                                            "$_dropDownRequiredDocumentTypeCode",
                                        'sDocumentName':
                                            "$_dropDownRequiredDocumentType",
                                        'sDocumentUrl': uplodedImage,
                                        //

                                      });
                                      // clear all values
                                      image = null;
                                      uplodedImage = null;
                                      _dropDownRequiredDocumentTypeCode = null;
                                      _dropDownRequiredDocumentType = null;

                                    });
                                    // here clear DropDown and images such as again dialgoBOX
                                    // not selected images and DropDown value

                                    print(
                                      "Updated List: $thirdFormCombinedList",
                                    );

                                    Navigator.of(
                                      context,
                                    ).pop(); // Close dialog after updating state
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
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
              ),
            );
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
                    style: TextStyle(color: Colors.white, fontSize: 14),
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
                bool isPdf = filePath
                    .toLowerCase()
                    .endsWith('.pdf');

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
                        ? Container(
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
      ],
    );
  }

  //Open DialogBox

  void _openDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 10,
                    right: 10,
                    bottom: 20,
                  ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    FocusScope.of(
                                      context,
                                    ).unfocus(); // Dismiss keyboard
                                  },
                                  hint: RichText(
                                    text: TextSpan(
                                      text: "Select Document Type",
                                      style: AppTextStyle
                                          .font14OpenSansRegularBlack45TextStyle,
                                    ),
                                  ),
                                  value: _dropDownDocument2,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _dropDownDocument2 = newValue;
                                      bindDocumentTypeList.forEach((element) {
                                        if (element["sDocumentTypeName"] ==
                                            _dropDownDocument2) {
                                          _dropDownDocument2_code =
                                              element['iDocumentTypeCode'];
                                          // _dropDownTradeSubCategoryFeesCode = element['fLicenceFees'];
                                        }
                                      });

                                      if (_dropDownDocument2_code != null) {
                                        /// remove the comment
                                        setState(() {
                                          // call a api if needs
                                          print(
                                            "---585--Fees----$_dropDownDocument2_code",
                                          );
                                          //  _dropDownDocument2
                                          print(
                                            "---587------$_dropDownDocument2",
                                          );
                                          // bindCommunityHallDate(_dropDownPremisesWardCode);
                                        });
                                      } else {
                                        //toast
                                      }
                                      print(
                                        "------373--DropDownnCategory Code----$_dropDownTradeCategoryCode",
                                      );
                                    });
                                  },
                                  items: bindDocumentTypeList.map((
                                    dynamic item,
                                  ) {
                                    return DropdownMenuItem(
                                      value: item["sDocumentTypeName"]
                                          .toString(),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item['sDocumentTypeName']
                                                  .toString(),
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
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleWithSpacing(),
                            const SizedBox(width: 8),
                            // Space between the circle and text
                            Text(
                              'Supporting Document',
                              style: AppTextStyle
                                  .font14OpenSansRegularBlack45TextStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Selected Images
                      Container(
                        height: 150,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No Image Available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // First Container
                          GestureDetector(
                            onTap: () async {
                              // _pickImageCamra();
                              // ----PICK IMAGE FROM A Camera--
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? sToken = prefs.getString('sToken');

                              final pickFileid = await _picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 65,
                              );

                              setState(() {
                                image = File(pickFileid!.path);
                              });
                              print("----171----pic path : ---$image");
                              if (pickFileid != null) {
                                setState(() {
                                  _imageFiles.add(
                                    File(pickFileid.path),
                                  ); // Add selected image to list
                                  uploadImage(sToken!, image!);
                                });
                                print(
                                  "---173--ImageFile--List----$_imageFiles",
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_camera.PNG',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.fill,
                                  ),
                                  const SizedBox(width: 8),
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
                              //----PickImage Gallery----
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? sToken = prefs.getString('sToken');

                              final pickFileid = await _picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality:
                                    65, // Change to `ImageSource.camera` for camera
                              );

                              setState(() {
                                image = File(pickFileid!.path);
                              });
                              if (pickFileid != null) {
                                setState(() {
                                  _imageFiles.add(
                                    File(pickFileid.path),
                                  ); // Add selected image to list
                                  // to take a image with a path
                                  uploadImage(sToken!, image!);
                                });
                                print(
                                  "---185--ImageFile---list---$_imageFiles",
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_camera.PNG',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 8),
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
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {

                          if (_dropDownRequiredDocumentTypeCode == null) {
                            displayToast("Please Select Document");
                          } else if (uplodedImage == null) {
                            displayToast("Please pick a Document");
                          } else {
                            setState(() {
                              thirdFormCombinedList.add({
                                'iDocumentTypeId': "$_dropDownDocument2_code",
                                'sDocumentName': "$_dropDownDocument2",
                                'sDocumentUrl': uplodedImage,
                              });
                            });
                            print(
                              "ListItem-----2630----$thirdFormCombinedList",
                            );
                            Navigator.of(context).pop();
                          }
                          // Navigator.of(context).pop(); // Close dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
      ),
    );
  }
}
