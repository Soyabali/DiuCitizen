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
import '../../../services/PostOccupancyCertificateReq.dart';
import '../../../services/baseurl.dart';
import '../../../services/bindCityzenWardRepo.dart';
import '../../../services/bindSubCategoryRepo.dart';
import '../../../services/markpointSubmit.dart';
import '../../circle/circle.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';
import 'occupationCertificate.dart';

class OccupationCertificateApplyForm extends StatefulWidget {

  var name,address,iApplicationId;

  OccupationCertificateApplyForm({super.key, required this.name, required this.address, required this.iApplicationId});

  @override
  State<OccupationCertificateApplyForm> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OccupationCertificateApplyForm> {

  List stateList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> wardList = [];
  List<dynamic> bindreimouList = [];
  List blockList = [];
  List shopTypeList = [];
  var result2, msg2;

  bindSubCategory(String subCategoryCode) async {
    subCategoryList = (await BindSubCategoryRepo().bindSubCategory(context,subCategoryCode))!;
    print(" -----xxxxx-  subCategoryList--43---> $subCategoryList");
    setState(() {});
  }

  bindWard() async {
    wardList = await BindCityzenWardRepo().getbindWard(context);
    print(" -----xxxxx-  wardList--50---> $wardList");
    setState(() {});
  }

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
  TextEditingController _remarksController = TextEditingController();



  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMobileNumberfocus = FocusNode();
  FocusNode _emailControllerfocus = FocusNode();
  FocusNode _projectLocationfoucs = FocusNode();
  FocusNode _architectNamefocus = FocusNode();
  FocusNode _addressfocus = FocusNode();
  FocusNode _wardfocus = FocusNode();
  FocusNode _remarksfocus = FocusNode();

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
  File? _imageFile;
  var _selectedSubCategoryId;
  var _selectedWardId;
  final _formKey = GlobalKey<FormState>();
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  File? image2;
  File? image3;
  File? image4;
  File? imageDoc_2;
  File? imageDoc_3;
  File? imageDoc_4;
  var uplodedImage;
  var uplodeimageDocument_1;
  var uplodeimageDocument_2;
  var uplodeimageDocument_3;
  var uplodeimageDocument_4;
  double? lat, long;
  var iApplicationid;

  // pick image from a Camera
 // uplode image doc 1 Camra
  Future DocumentPickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image');
        // multipartProdecudre();
        uploadImageDoc_1(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // uplode image doc 1 gallery
  Future DocumentPickImageGallery() async {
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
        uploadImageDoc_1(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // uplode image doc 2 Camra
  Future Document_2PickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image2 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------166----->$image2');
        // multipartProdecudre();
        uploadImageDoc_2(sToken!, image2!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // uplode image doc 2 Gallery
  Future Document_2PickImageGallery() async {
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
        uploadImageDoc_2(sToken!, image2!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // uplode image doc 3 Camera
  Future Document_3PickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image3 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image3');
        // multipartProdecudre();
        uploadImageDoc_3(sToken!, image3!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // uplode image doc 3 Gallery
  Future Document_3PickImageGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image3 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image3');
        // multipartProdecudre();
        uploadImageDoc_3(sToken!, image3!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // uplode image doc 4 Camera
  Future Document_4PickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image4 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image4');
        // multipartProdecudre();
        uploadImageDoc_4(sToken!, image4!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // ullode image doc 4 Galleruy
  Future Document_4PickImageGallery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 65);
      if (pickFileid != null) {
        image4 = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------167----->$image4');
        // multipartProdecudre();
        uploadImageDoc_4(sToken!, image4!);
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
        // uploadImage(sToken!, image!);
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
        // uploadImage(sToken!, image!);
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

    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(10).toString();
    }

    return randomNumber;
  }
  // uplode doc  - 1
  Future<void> uploadImageDoc_1(String token, File imageFile) async {
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
        uplodeimageDocument_1 = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image Path----245--: $uplodeimageDocument_1');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }
  // ulode doo - 2
  Future<void> uploadImageDoc_2(String token, File imageFile) async {
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
        uplodeimageDocument_2 = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image Path----447--: $uplodeimageDocument_2');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }
  // uplode doc - 3
  Future<void> uploadImageDoc_3(String token, File imageFile) async {
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
        uplodeimageDocument_3 = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image Path----245--: $uplodeimageDocument_3');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }
  // uplode doc - 4
  Future<void> uploadImageDoc_4(String token, File imageFile) async {
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
        uplodeimageDocument_4 = responseData['Data'][0]['sImagePath'];
        print('Uploaded Image Path----245--: $uplodeimageDocument_4');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  // build dialog sucess
  Widget _buildDialogSucces2(BuildContext context, String msg) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 190,
            padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0),
                // Space for the image
                //  Text('Success', style: AppTextStyle.font16OpenSansRegularBlackTextStyle),
                SizedBox(height: 10),
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const ExpenseManagement()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Set the background color to white
                        foregroundColor:
                        Colors.black, // Set the text color to black
                      ),
                      child: Text('Ok',
                          style:
                          AppTextStyle.font16OpenSansRegularBlackTextStyle),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/sussess.jpeg',
                  // Replace with your asset image path
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    bindWard();
    getLocation();
    generateRandom20DigitNumber();
    iApplicationid = "${widget.iApplicationId}";
    print("-----632---$iApplicationid");
    super.initState();
    //  _addressfocus = FocusNode();
    _applicationNamefocus = FocusNode();
    _applicationMobileNumberfocus = FocusNode();
    _emailControllerfocus = FocusNode();
    _projectLocationfoucs = FocusNode();
    _architectNamefocus = FocusNode();
    _addressfocus = FocusNode();
    _remarksfocus = FocusNode();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _applicationNameController.dispose();
     _remarksController.dispose();
    _remarksfocus.dispose();
    // _mentionController.dispose();
    FocusScope.of(context).unfocus();
  }

  // Todo bind sector code
  Widget _bindSubCategory() {
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
                // Helps to control the vertical size of the button
                isExpanded: true,
                dropdownColor: Colors.white,
                // Allows the DropdownButton to take full width
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                hint: RichText(
                  text: TextSpan(
                    text: "Select Sub Category",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.normal),
                  ),
                ),
                value: dropDownSubCategory,
                key: subCategoryFocus,
                onChanged: (newValue) {
                  setState(() {
                    dropDownSubCategory = newValue;
                    subCategoryList.forEach((element) {
                      if (element["sSubCategoryName"] == dropDownSubCategory) {
                        _selectedSubCategoryId = element['iSubCategoryCode'];
                        setState(() {});
                      }
                    });
                  });
                },
                items: subCategoryList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sSubCategoryName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sSubCategoryName'].toString(),
                            overflow: TextOverflow.ellipsis,
                            // Handles long text
                            style: AppTextStyle
                                .font14OpenSansRegularBlack45TextStyle,
                            // style: TextStyle(
                            //   fontSize: 16,
                            //   fontWeight: FontWeight.normal,
                            // ),
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

  // bind Ward
  Widget _bindWard() {
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
                value: _dropDownWard,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWard = newValue;
                    wardList.forEach((element) {
                      if (element["sWardName"] == _dropDownWard) {
                        _selectedWardId = element['sWardCode'];
                      }
                    });
                  });
                },
                items: wardList.map((dynamic item) {
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

  /// Algo.  First of all create repo, secodn get repo data in the main page after that apply list data on  dropdown.
  // function call

  void validateAndCallApi() async {
    // Trim values to remove leading/trailing spaces

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Contact No
    String? sContactNo = prefs.getString('sContactNo');
    // random number
    String random20DigitNumber = generateRandom20DigitNumber();

    // TextFormField value
    var remark = _remarksController.text.trim();
    // Debug logs
    print('---iCompCode----$random20DigitNumber');
    print("--iApplicationid--: $iApplicationid");
    print("---remark--: $remark");
    print('---Document 1----$uplodeimageDocument_1');
    print('---Document 2----$uplodeimageDocument_2');
    print('---Document 3----$uplodeimageDocument_3');
    print('---Document 4----$uplodeimageDocument_4');

    final isFormValid = _formKey.currentState!.validate();


    // Validate all conditions
    if (isFormValid &&
        remark.isNotEmpty &&
        uplodeimageDocument_1 != null) {
      // All conditions met; call the API
      print('---Call API---');

      var onlineComplaintResponse = await PostOccupancyCertificateReq().postOccupancyCertificate(
          context,
          random20DigitNumber,
          iApplicationid,
          remark,
          uplodeimageDocument_1,
          uplodeimageDocument_2,
          uplodeimageDocument_3,
          uplodeimageDocument_4
      );
      print('----845---->>.--->>>>---$onlineComplaintResponse');
      result2 = onlineComplaintResponse['Result'];
      msg2 = onlineComplaintResponse['Msg'];
      if(result2=="1"){
        displayToast(msg2);
        Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>  OccupationCertificate()),
        // );

      }else{
        displayToast(msg2);
      }
      //displayToast(msg2);
      // Your API call logic here
    } else {
      // If conditions fail, display appropriate error messages
      print('--Not Call API--');
      if (remark.isEmpty) {
        displayToast('Please enter Remarks');
        return;
      }
      if (uplodeimageDocument_1==null) {
        displayToast('Please Pick Document - 1');
        return;
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
                        'assets/images/onlinecomplaint.jpeg',
                        // Replace 'image_name.png' with your asset image path
                        fit: BoxFit
                            .cover, // Adjust the image fit to cover the container
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Project Name',
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
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.grey[300],
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "${widget.name}",
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle,
                                                textAlign: TextAlign
                                                    .left, // Aligns the text to the left
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Sub Category
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
                                        'Project Location',
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
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.grey[300],
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "${widget.address}",
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle,
                                                textAlign: TextAlign
                                                    .left, // Aligns the text to the left
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                // WARD
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Remarks',
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
                                                focusNode: _remarksfocus, // Focus node for the text field
                                                controller: _remarksController, // Controller to manage the text field's value
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
                                                  // hintText: "Email ID", // Placeholder text when field is empty
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
                                SizedBox(height: 5),
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
                                // Document 1
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
                                            // Text("Document -1",
                                            //     style: AppTextStyle
                                            //         .font14OpenSansRegularBlack45TextStyle),
                                            RichText(
                                              text:TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Document - ',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle
                                                  ),
                                                  TextSpan(
                                                    text: '1',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularRedTextStyle
                                                  ),
                                                ],
                                              ),
                                            ),

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
                                            DocumentPickImage();
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
                                                Icons.camera_alt,
                                                size: 30,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                            //pickImage();
                                            DocumentPickImageGallery();
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
                                // Document 2
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
                                            Text("Documet -2",
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
                                            Document_2PickImage();
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
                                                Icons.camera_alt,
                                                size: 30,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                            //pickImage();
                                            // pickImageGallery();
                                            Document_2PickImageGallery();
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
                                // Document 3
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
                                            Text("Documet -3",
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
                                            Document_3PickImage();
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
                                                Icons.camera_alt,
                                                size: 30,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                            //pickImage();
                                            // pickImageGallery();
                                            Document_2PickImageGallery();
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
                                      image3 != null
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
                                                  image3!,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          Positioned(
                                              bottom: 65,
                                              left: 35,
                                              child: IconButton(
                                                onPressed: () {
                                                  image3 = null;
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
                                // Document 4
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
                                            Text("Documet -4",
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
                                            Document_4PickImage();
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
                                                Icons.camera_alt,
                                                size: 30,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            print("---------image-----");
                                            //pickImage();
                                            // pickImageGallery();
                                            Document_4PickImageGallery();
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
                                      image4 != null
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
                                                  image4!,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          Positioned(
                                              bottom: 65,
                                              left: 35,
                                              child: IconButton(
                                                onPressed: () {
                                                  image4 = null;
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
