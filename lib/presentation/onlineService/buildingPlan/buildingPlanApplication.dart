import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../../../app/generalFunction.dart';
import '../../../app/loader_helper.dart';
import '../../../services/PostPropertyPlanApplicationRepo.dart';
import '../../../services/baseurl.dart';
import '../../circle/circle.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';
import 'buildingPlan.dart';

class BuildingPlanApplication extends StatefulWidget {

  var name, iCategoryCode;

  BuildingPlanApplication({super.key, required this.name, required this.iCategoryCode});

  @override
  State<BuildingPlanApplication> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BuildingPlanApplication> {

  List stateList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> wardList = [];
  List<dynamic> bindreimouList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _applicationNameController = TextEditingController();
  TextEditingController _applicationMobileNumberController = TextEditingController();
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _projectLocationController = TextEditingController();
  TextEditingController _architectureNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();



  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMobileNumberfocus = FocusNode();
  FocusNode _emailControllerfocus = FocusNode();
  FocusNode _projectLocationfoucs = FocusNode();
  FocusNode _architectNamefocus = FocusNode();
  FocusNode _addressfocus = FocusNode();
  FocusNode _wardfocus = FocusNode();

  String? todayDate;
  String? consumableList;
  int count = 0;
  List? data;
  List? listCon;

  //var _dropDownSector;
  var dropDownSubCategory;
  var _dropDownWard;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final subCategoryFocus = GlobalKey();
  final wardFocus = GlobalKey();
  var _selectedSubCategoryId;
  var _selectedWardId;
  final _formKey = GlobalKey<FormState>();
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  File? image2;

  var uplodedImage;
  var sUploadBuildingPlanPath;
  var sUploadSupportingDocPath;
  double? lat, long;

  // pick image from a Camera

  Future pickImageBuildingPlanDoc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------1113----->$image');
        print('Token -------114----->$image');
        // multipartProdecudre();
        uploadImageBuildingPlanDoc(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  Future pickImageBuildingPlanDocGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------1113----->$image');
        print('Token -------114----->$image');
        // multipartProdecudre();
        uploadImageBuildingPlanDoc(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  Future otherDocImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image2 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image2');
        // multipartProdecudre();
        uploadImageOtherDoc(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // gallery code
  Future otherDocGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image2 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image2');
        // multipartProdecudre();
        uploadImageOtherDoc(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  Future pickImageGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        // uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // takeaLocation
  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint("-------------Position-----------------");
    debugPrint(position.latitude.toString());

    lat = position.latitude;
    long = position.longitude;
    print('-----------105----$lat');
    print('-----------106----$long');
    // setState(() {
    // });
    debugPrint("Latitude: ----1056--- $lat and Longitude: $long");
    debugPrint(position.toString());
  }

  // generateRandomNumber
  String generateRandom20DigitNumber() {
    final Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 20; i++) {
      randomNumber += random.nextInt(10).toString();
    }

    return randomNumber;
  }

  Future<void> uploadImageBuildingPlanDoc(String token, File imageFile) async {
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
        'POST', Uri.parse('$uploadImageApi'),
      );
      // Add headers
      //request.headers['token'] = '04605D46-74B1-4766-9976-921EE7E700A6';
      request.headers['token'] = token;
      request.headers['sFolder'] = 'CompImage';
      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath('sFolder',imageFile.path,
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
        sUploadBuildingPlanPath = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image Path----279--: $sUploadBuildingPlanPath');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }
  //
  Future<void> uploadImageOtherDoc(String token, File imageFile) async {
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
        'POST', Uri.parse('$uploadImageApi'),
      );
      // Add headers
      //request.headers['token'] = '04605D46-74B1-4766-9976-921EE7E700A6';
      request.headers['token'] = token;
      request.headers['sFolder'] = 'CompImage';
      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath('sFolder',imageFile.path,
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
        sUploadSupportingDocPath = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image Path----245--: $sUploadSupportingDocPath');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  @override
  void initState() {
    var subCategoryCode = "${widget.iCategoryCode}";
    print("---------240-------$subCategoryCode");
    getLocation();
    generateRandom20DigitNumber();
    super.initState();
  //  _addressfocus = FocusNode();
    _applicationNamefocus = FocusNode();
    _applicationMobileNumberfocus = FocusNode();
    _emailControllerfocus = FocusNode();
    _projectLocationfoucs = FocusNode();
    _architectNamefocus = FocusNode();
    _addressfocus = FocusNode();

  }

  @override
  void dispose() {
    // TODO: implement dispose
     super.dispose();
     _applicationNameController.dispose();
     _applicationMobileNumberfocus.dispose();
     _emailControllerfocus.dispose();
     _projectLocationfoucs.dispose();
     _architectNamefocus.dispose();
     _addressfocus.dispose();
    // _landmarkController.dispose();
    // _mentionController.dispose();
    FocusScope.of(context).unfocus();
  }


  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.
  // function call

  void validateAndCallApi() async {
    // Trim values to remove leading/trailing spaces

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Contact No
    String? sCreatedBy = prefs.getString('sContactNo');
    // random number
    String iApplicationId = generateRandom20DigitNumber();

    // TextFormField value
    var  sApplicantName = _applicationNameController.text.trim();
    var sMobileNo = _applicationMobileNumberController.text.trim();
    var sEmailId = _emailIdController.text.trim();
    var sProjectName = _projectLocationController.text.trim();
    var sLocation = _projectLocationController.text.trim();
    var sArchitectName = _architectureNameController.text.trim();
    var sAddress = _addressController.text.trim();


   // uplodedImage="http:/115.244.7.153/DiuCitizenApi/UploadedPhotos/CompImage/281120241236520538.png";

    // Debug logs
    print('---iApplicationId----$iApplicationId');
    print('---sApplicantName----$sApplicantName');
    print("--sMobileNo--: $sMobileNo");
    print("---sEmailId--: $sEmailId");
    print("---sProjectName---: $sProjectName");
    print("---sLocation---: $sLocation");
    print("---sArchitectName--: $sArchitectName");
    print('---sAddress----$sAddress');
    print("sUploadBuildingPlanPath: $sUploadBuildingPlanPath");
    print("---sUploadSupportingDocPath-- :    $sUploadSupportingDocPath");
    print("---sCreatedBy-- :    $sCreatedBy");

    // Check Form Validation
    final isFormValid = _formKey.currentState!.validate();

    print("Form Validation: $isFormValid");

    // Validate all conditions
    if (isFormValid &&
        sApplicantName.isNotEmpty &&
        sMobileNo.isNotEmpty &&
        sEmailId.isNotEmpty &&
        sProjectName.isNotEmpty &&
        sLocation.isNotEmpty &&
        sArchitectName.isNotEmpty &&
        sAddress.isNotEmpty &&
        sUploadBuildingPlanPath!=null

    ) {
      // All conditions met; call the API
      //   uplodedImage!=null
      print('---Call API---');

      var postPropertyPlanApplication = await PostPropertyPlanApplicationRepo().postPropertyPlanApplication(
          context,
          iApplicationId,
          sApplicantName,
          sMobileNo,
          sEmailId,
          sProjectName,
          sLocation,
          sArchitectName,
          sAddress,
          sUploadBuildingPlanPath,
          sUploadSupportingDocPath,
          sCreatedBy
      );
      print('----636---$postPropertyPlanApplication');
      result2 = postPropertyPlanApplication['Result'];
      msg2 = postPropertyPlanApplication['Msg'];
    //  displayToast(msg2);
      if(result2=="1"){
        displayToast(msg2);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BuildingPlan()),
        );
      }else{
        displayToast(msg2);
      }

      // call here to api
      // Your API call logic here
    } else {
      // If conditions fail, display appropriate error messages
      print('--Not Call API--');
      if (sApplicantName.isEmpty) {
        displayToast('Please Enter Application Name');
        return;
      }
      if (sMobileNo.isEmpty) {
        displayToast('Please Enter Mobile Number');
        return;
      }
      if (sEmailId.isEmpty) {
        displayToast('Please Enter Email ID');
        return;
      }if(sLocation.isEmpty){
        displayToast('Please Enter Project Location');
        return;
      }if(sArchitectName.isEmpty){
        displayToast('Please Enter Architect Name');
        return;
      }if(sAddress.isEmpty){
        displayToast('Please Enter Address');
        return;
      }if(sUploadBuildingPlanPath==null){
        displayToast('Please Pic Building Plan Doc');
      }if(sUploadSupportingDocPath==null){
        displayToast('Please Pic Other Doc');
      }
    }
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => OnlineComplaint()),
                // );
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 150, // Height of the container
                      // width: 200, // Width of the container
                      //step3.jpg
                      child: Image.asset(
                        'assets/images/building_plan.png',
                        // Replace 'image_name.png' with your asset image path
                        fit: BoxFit.cover, // Adjust the image fit to cover the container
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // Background color of the container
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              // Color of the shadow
                              spreadRadius: 5,
                              // Spread radius
                              blurRadius: 7,
                              // Blur radius
                              offset: Offset(0, 3), // Offset of the shadow
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // 'assets/images/favicon.png',
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, right: 10, top: 10),
                                      child: Image.asset(
                                        'assets/images/ic_expense.png',
                                        // Replace with your image asset path
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text('Fill the below details',
                                          style: AppTextStyle
                                              .font16OpenSansRegularBlackTextStyle),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Applcation Name
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Application Name',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: Container(
                                    color: Colors.white,
                                    height: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: TextFormField(
                                                focusNode: _applicationNamefocus, // Focus node for the text field
                                                controller: _applicationNameController, // Controller to manage the text field's value
                                                textInputAction: TextInputAction.next, // Set action for the keyboard
                                                onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(), // Add a border around the text field
                                                  contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0,
                                                  ), // Adjust padding inside the text field
                                                  filled: true, // Enable background color for the text field
                                                  fillColor: Colors.white,
                                                  // fillColor: Color(0xFFf2f3f5), // Set background color
                                                 // hintText: "Application Name", // Placeholder text when field is empty
                                                  hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
                                                ),
                                                autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                                              )

                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Application Mobile Number
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Application Mobile Number',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: Container(
                                    height: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 45,
                                              child: TextFormField(
                                                focusNode: _applicationMobileNumberfocus, // Focus node for the text field
                                                controller: _applicationMobileNumberController, // Controller to manage the text field's value
                                                keyboardType: TextInputType.number, // Keyboard type to show numbers only
                                                textInputAction: TextInputAction.next, // Set action for the keyboard
                                                onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(), // Add a border around the text field
                                                  contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0,
                                                  ), // Adjust padding inside the text field
                                                  filled: true, // Enable background color for the text field
                                                  fillColor: Colors.white,
                                                 // hintText: "Application Mobile Number", // Placeholder text when field is empty
                                                  hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
                                                ),
                                                autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                                  LengthLimitingTextInputFormatter(10), // Restrict input to a maximum of 10 digits
                                                ],
                                                // validator: (value) {
                                                //   if (value == null || value.isEmpty) {
                                                //     return 'Please enter a mobile number';
                                                //   } else if (value.length != 10) {
                                                //     return 'Mobile number must be 10 digits';
                                                //   }
                                                //   return null; // Return null if validation passes
                                                // },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Email ID
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Email ID',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: Container(
                                    height: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              focusNode: _emailControllerfocus, // Focus node for the text field
                                              controller: _emailIdController, // Controller to manage the text field's value
                                              keyboardType: TextInputType.emailAddress, // Show the email keyboard layout
                                              textInputAction: TextInputAction.next, // Set action for the keyboard
                                              onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to the next input on completion
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(), // Add a border around the text field
                                                contentPadding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0,
                                                ), // Adjust padding inside the text field
                                                filled: true, // Enable background color for the text field
                                                fillColor: Colors.white,
                                               // hintText: "Email ID", // Placeholder text when field is empty
                                                hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
                                              ),
                                              autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                // Regular expression for email validation
                                                String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                                RegExp regex = RegExp(emailPattern);
                                                if (!regex.hasMatch(value)) {
                                                  return 'Enter a valid email address';
                                                }
                                                return null; // Return null if validation passes
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Project Location
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Project Location',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                // this is my TextFormFoield
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
                                            child: TextFormField(
                                             focusNode: _projectLocationfoucs,
                                              controller: _projectLocationController,
                                              textInputAction:
                                              TextInputAction.next,
                                              onEditingComplete: () =>
                                                  FocusScope.of(context)
                                                      .nextFocus(),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                                filled: true,
                                                // Enable background color
                                                fillColor: Colors.white,
                                                //fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Architect Name
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Architect Name',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 0),
                                  child: Container(
                                    height: 70,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: TextFormField(
                                        focusNode: _architectNamefocus,
                                       controller: _architectureNameController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            FocusScope.of(context).nextFocus(),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          filled: true, // Enable background color
                                          fillColor: Colors.white,
                                          //fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Mention your concerns here
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Address',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 0),
                                  child: Container(
                                    height: 70,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: TextFormField(
                                        focusNode: _addressfocus,
                                        controller: _addressController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            FocusScope.of(context).nextFocus(),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          filled: true, // Enable background color
                                          fillColor: Colors.white,
                                          //fillColor: Color(0xFFf2f3f5), // Set your desired background color here
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                      ),
                                    ),
                                  ),
                                ),
                                // uplode Photo
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Supporting Document',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                //----Card
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    height: 80,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Column Section
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text("Building Plan Doc",
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  "Please click here",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red[300]),
                                                ),
                                                SizedBox(width: 5),
                                                // Icon(
                                                //   Icons.arrow_forward_ios,
                                                //   color: Colors.red[300],
                                                //   size: 16,
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Container Section
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                            pickImageBuildingPlanDoc();
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset("assets/images/ic_camera.PNG",
                                              height: 30,
                                                width: 30,
                                                fit: BoxFit.fill,
                                              )
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                            //pickImage();
                                            //pickImageGallery();
                                            //pickImageBuildingPlanDoc();
                                            pickImageBuildingPlanDocGallery();
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.photo_camera_back,
                                                size: 30,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      image != null
                                          ? Stack(
                                        children: [
                                          GestureDetector(
                                            behavior:
                                            HitTestBehavior.translucent,
                                            onTap: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             FullScreenPage(
                                              //               child: image!,
                                              //               dark: true,
                                              //             )));
                                            },
                                            child: Container(
                                                color:
                                                Colors.lightGreenAccent,
                                                height: 100,
                                                width: 70,
                                                child: Image.file(
                                                  image!,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          Positioned(
                                              bottom: 65,
                                              left: 35,
                                              child: IconButton(
                                                onPressed: () {
                                                  image = null;
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                              ))
                                        ],
                                      )
                                          : Text(
                                        "",
                                        style: TextStyle(
                                            color: Colors.red[700]),
                                      )
                                    ]),
                                SizedBox(height: 5),
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    height: 80,
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Column Section
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text("Other Doc",
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  "Please click here",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red[300]),
                                                ),
                                                SizedBox(width: 5),
                                                // Icon(
                                                //   Icons.arrow_forward_ios,
                                                //   color: Colors.red[300],
                                                //   size: 16,
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Container Section
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                           // pickImage();
                                           otherDocImage();
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset("assets/images/ic_camera.PNG",
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.fill,
                                              )
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                            //pickImage();
                                           // pickImageGallery();
                                            otherDocGallery();
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.photo_camera_back,
                                                size: 30,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      image2 != null
                                          ? Stack(
                                        children: [
                                          GestureDetector(
                                            behavior:
                                            HitTestBehavior.translucent,
                                            onTap: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             FullScreenPage(
                                              //               child: image!,
                                              //               dark: true,
                                              //             )));
                                            },
                                            child: Container(
                                                color:
                                                Colors.lightGreenAccent,
                                                height: 100,
                                                width: 70,
                                                child: Image.file(
                                                  image2!,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          Positioned(
                                              bottom: 65,
                                              left: 35,
                                              child: IconButton(
                                                onPressed: () {
                                                  image2 = null;
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                              ))
                                        ],
                                      )
                                          : Text(
                                        "",
                                        style: TextStyle(
                                            color: Colors.red[700]),
                                      )
                                    ]),
                                SizedBox(height: 10),


                                InkWell(
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
