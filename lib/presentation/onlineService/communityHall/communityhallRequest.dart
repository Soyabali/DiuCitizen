import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:puri/services/bindCommunityHallRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/generalFunction.dart';
import '../../../app/loader_helper.dart';
import '../../../services/BindCommunityHallDateRepo.dart';
import '../../../services/BindMonthsRepo.dart';
import '../../../services/PostCommunityBookingHallReqRepo.dart';
import '../../../services/baseurl.dart';
import '../../../services/bindSubCategoryRepo.dart';
import '../../circle/circle.dart';
import '../../fullscreen/imageDisplay.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';


class CommunityHallRequest extends StatefulWidget {

  var name, iCategoryCode;
  CommunityHallRequest(
      {super.key, required this.name, required this.iCategoryCode});

  @override
  State<CommunityHallRequest> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CommunityHallRequest> with TickerProviderStateMixin {

  List<dynamic> subCategoryList = [];
 List<Map<String, dynamic>>bindcommunityHallDate=[];
  List<dynamic> wardList = [];
  List<dynamic> bindMonthList = [];
  var result2, msg2;
  bool isFormVisible = true; // Track the visibility of the form
  bool isIconRotated = false;
  bool isFormVisible2 = true; // Track the visibility of the form
  bool isIconRotated2 = false;
  final _formKey = GlobalKey<FormState>();

  bindSubCategory(String subCategoryCode) async {
    subCategoryList = (await BindSubCategoryRepo().bindSubCategory(context, subCategoryCode))!;
    print(" -----xxxxx-  subCategoryList--43---> $subCategoryList");
    setState(() {});
  }

 // var msg;
  var result;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _applicationNameController = TextEditingController();
  TextEditingController _applicationMoboileNoController = TextEditingController();
  TextEditingController _applicantAddressController = TextEditingController();
  TextEditingController _purposeOfBookingController = TextEditingController();

  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMoboileNofocus = FocusNode();
  FocusNode _applicantAddressfocus = FocusNode();
  FocusNode _communityHallfocus = FocusNode();
  FocusNode _perDayAmountfocus = FocusNode();
  FocusNode _purposeOfBookingfocus = FocusNode();

  String? todayDate;
  String? consumableList;
  int count = 0;
  List? data;
  List? listCon;
  int selectedIndex = -1;
  var _dropDownWard;
  var _dropDownMonth;
  String? sec;
  var _selectediCommunityHallId;
  var _selectedMonthCode;
  var _selectedRatePerDay;
  File? image;
  File? image2;
  var uplodedImage;
  var uplodedImage2;
  List<Map<String, dynamic>> seleccteddates = [];
  List<Map<String, dynamic>> firstFormCombinedList = [];
  final List<File> _imageFiles = [];
  bool isSuccess = false;
  bool isLoading = false;
  var iCommunityHallName;
var  firstStatus;
  File? _imageFile1; // For first column
  File? _imageFile2; // For second column
  final ImagePicker _picker = ImagePicker();
   bool isFirstColumn = true;

   List<bool> selectedStates = [];
  Set<int> selectedIndices = {}; // To track selected items by index

  void openPdf(BuildContext context, String pdfUrl) async {
    if (await canLaunchUrl(Uri.parse(pdfUrl))) {
      await launchUrl(Uri.parse(pdfUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cannot open PDF")));
    }
  }

  // function
  bindWard() async {
    /// todo remove the comment and call Community Hall
    wardList = await BindCommunityHallRepo().bindCommunityHall();

    setState(() {});
  }
  // BindMonth
  bindMonth() async {
    /// todo remove the comment and call Community Hall
    bindMonthList = await BindMonthsRepo().bindMonth();
    setState(() {});
  }
  // DropdownButton Ward
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
                    text: "Select Community Hall",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownWard,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWard = newValue;
                    wardList.forEach((element) {
                      if (element["sCommunityHallName"] == _dropDownWard) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _selectediCommunityHallId = element['iCommunityHallId'];
                        _selectedRatePerDay = element['RatePerDay'];
                        iCommunityHallName = element['sCommunityHallName'];

                      }
                    });
                    if (_selectediCommunityHallId != null && _selectedMonthCode!=null) {
                      /// remove the comment
                     setState(() {
                       bindCommunityHallDate(_selectediCommunityHallId,_selectedMonthCode);
                     });

                    } else {
                      //toast
                    }
                    print("------157---hallId--$_selectediCommunityHallId");
                    print("------158--MonthCode---$_selectedMonthCode");
                  });
                },

                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sCommunityHallName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sCommunityHallName'].toString(),
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
  // bindMonth list DropDown
  Widget _bindMonthList() {
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
                    text: "Select Month",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownMonth,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownMonth = newValue;
                    bindMonthList.forEach((element) {
                      if (element["sMonthName"] == _dropDownMonth) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _selectedMonthCode = element['iMonthCode'];

                      }
                    });
                    if (_selectedMonthCode != null) {
                      /// remove the comment
                      setState(() {
                       // bindCommunityHallDate(_selectediCommunityHallId);
                      });

                    } else {
                      //toast
                    }
                    print("------157---_selectedMonthCode--$_selectedMonthCode");
                    print("------158----RatePerDay---$_dropDownMonth");
                  });
                },

                items: bindMonthList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sMonthName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sMonthName'].toString(),
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

  Future<void> bindCommunityHallDate(var hallId, selectedMonthCode) async {
    setState(() {
      isLoading = true; // Start the progress bar
    });
    try {
      bindcommunityHallDate = await BindCommunityHallDateRepo()
          .bindCommunityHallDate(context, hallId,selectedMonthCode);
        print('-----328----xxxx---->>>>---$bindcommunityHallDate');
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
                Map<String, dynamic> firstItem = bindcommunityHallDate[firstIndex];

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
                    _buildDateTile(firstItem['dDate'],
                      selectedStates[firstIndex],
                      firstColor,
                          () {
                        setState(() {
                          var status = firstItem['iStatus'];
                          if (status == 0 || status == 1) {
                            selectedStates[firstIndex] = !selectedStates[firstIndex];
                            if (selectedStates[firstIndex]) {
                              seleccteddates.add({
                               "dBookingDate":"${firstItem['dDate']}"
                              });
                              //selectedDates.add(firstItem['dDate']);
                              //
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Selected: ${firstItem['dDate']}")),
                              );
                            } else {
                             // selectedDates.remove(firstItem['dDate']);
                              seleccteddates.remove(firstItem['dDate']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Deselected: ${firstItem['dDate']}")),
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
                      _buildDateTile(secondItem['dDate'],
                        selectedStates[secondIndex],
                        secondColor!,
                            () {
                          setState(() {
                            var status = secondItem?['iStatus'];
                            if (status == 0 || status == 1) {

                              selectedStates[secondIndex] = !selectedStates[secondIndex];
                              if (selectedStates[secondIndex]) {

                               // selectedDates.add(secondItem?['dDate']);
                                seleccteddates.add({
                                  "dBookingDate":"${secondItem?['dDate']}"
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Selected: ${secondItem?['dDate']}")),
                                );
                              } else {
                               // selectedDates.remove(secondItem?['dDate']);
                                seleccteddates.remove(secondItem?['dDate']);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Deselected: ${secondItem?['dDate']}")),
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
          // here you should give the toast pdf file is selected.
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

  // pick image camra
  Future pickImageCamra() async {
    image=null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----113--$sToken');
    try {
      final pickFileid = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
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

  // uplode photo
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
      print("---------544--------$responseData");
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        setState(() {
          uplodedImage = responseData['Data'][0]['sImagePath'];
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
  // uplode photo
  Future<void> uploadImage2(String token, File imageFile) async {
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
      print("---------544--------$responseData");
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        setState(() {
          uplodedImage2 = responseData['Data'][0]['sImagePath'];
        });
        print('Uploaded Image Path----548----xxxxx----: $uplodedImage2');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  //  to pick image gallery and Camra selected
  Widget paymentDialog(BuildContext dialogContext){
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔶 Gradient Header
          Container(
            height: 45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF15C3B), // First color: #ff5e62 (a warm coral)
                  Color(0xFF005BAC), // Second color: #005BAC (a deep blue)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Click to choose a photo',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                    }
                ),
              ],
            ),
          ),
          // 💳 Payment Options
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // First Card
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //pickImage();
                      pickImageCamra();
                      print('----Camra----');
                      // print('-----706----');
                      // var sPageName = "Advertisement Booking Status";
                      // // call a Payment page
                      // var baseurl = "https://www.diusmartcity.com/AdvertisementPaymentGatewayMobile.aspx?QS=";
                      // var paymentUrl = "$baseurl$sRequestNo";
                      // print(paymentUrl);
                      // // close the dialog
                      // if (Navigator.of(dialogContext).canPop()) {
                      //   Navigator.of(dialogContext).pop();
                      // }
                      // // open the payment activity
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) =>
                      //       AboutDiuPage(
                      //           name: sPageName, sPageLink: paymentUrl)),
                      // );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic_camera.PNG',
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            const Text(
                              'Camera',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Second Card
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                     // print("------Gallery----");
                     // pickImage();
                      pickGallery();

                      // print('---sbi----');
                      // var sPageName = "Advertisement Booking Status";
                      // // call a Payment page
                      // // var baseurl = "https://www.diusmartcity.com/AdvertisementPaymentGatewayMobile.aspx?QS=";
                      // var baseurl = "https://www.diusmartcity.com/SBIAdvertismentPaymentGetewayMobile.aspx?QS=";
                      // var paymentUrl = "$baseurl$sRequestNo";
                      // print(paymentUrl);
                      //
                      // // close the dialog
                      // if (Navigator.of(dialogContext).canPop()) {
                      //   Navigator.of(dialogContext).pop();
                      // }
                      //
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) =>
                      //       AboutDiuPage(
                      //           name: sPageName, sPageLink: paymentUrl)),
                      // );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Image.asset(
                              'assets/images/gallery.png',
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            const Text(
                              'Gallery',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
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
          )
        ],
      ),
    );
  }


  @override
  void initState() {
    bindWard();
    bindMonth();
    super.initState();
    _applicationNamefocus = FocusNode();
    _applicationMoboileNofocus = FocusNode();
    _applicantAddressfocus = FocusNode();
    _communityHallfocus = FocusNode();
    _perDayAmountfocus = FocusNode();
    _purposeOfBookingfocus = FocusNode();
    // Initialize the selectedStates with false
    // Initialize the selectedStates with false
    if (bindcommunityHallDate.isNotEmpty) {
      selectedStates = List.generate(bindcommunityHallDate.length, (index) => false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _applicationNamefocus.dispose();
    _applicationMoboileNofocus.dispose();
    _applicantAddressfocus.dispose();
    _communityHallfocus.dispose();
    _perDayAmountfocus.dispose();
    _purposeOfBookingfocus.dispose();
    FocusScope.of(context).unfocus();
  }
  // Api call Function
  void validateAndCallApi() async {
    firstFormCombinedList = [];
    // Trim values to remove leading/trailing spaces
    // random No
    Random random = Random();
    // Generate a random 10-digit number
    int sBookingReqId = 1000000000 + random.nextInt(900000);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? sCreatedBy = prefs.getString('sContactNo');

    // TextFormField values
    var sApplicantName = _applicationNameController.text.trim();
    var sMobileNo = _applicationMoboileNoController.text.trim();
    var sAddress = _applicantAddressController.text.trim();
    var dPurposeOfBooking = _purposeOfBookingController.text.trim();
    var iDaysOfBooking = "${seleccteddates.length}";
    final isFormValid = _formKey.currentState!.validate();

    // Validate all conditions
    if (isFormValid &&
        sApplicantName.isNotEmpty &&
        sMobileNo.isNotEmpty &&
        sAddress.isNotEmpty &&
        _selectediCommunityHallId != null &&
        dPurposeOfBooking.isNotEmpty &&
        uplodedImage!=null
    ) {
      // All conditions met; call the API
      print('---Call API---');


      firstFormCombinedList.add({
        "sBookingReqId": "$sBookingReqId",
        "sApplicantName": sApplicantName,
        "sMobileNo": "$sMobileNo",
        "sAddress": sAddress,
        "iCommunityHallName": "$_selectediCommunityHallId",
        "iDaysOfBooking": "$iDaysOfBooking",
        "fAmount": "$_selectedRatePerDay",
        "dPurposeOfBooking": "$dPurposeOfBooking",
        "sCreatedBy": sCreatedBy,
        "sCommunityDocUrl":uplodedImage,
        "sCommunityDoc2Url":uplodedImage2,
        "sBookingDateArray": seleccteddates,
      });

      // lIST to convert json string
      String allThreeFormJson = jsonEncode(firstFormCombinedList);

      print('----941--->>.---$allThreeFormJson');

      var onlineComplaintResponse = await PostCommunityBookingHallReqRepo()
          .postCommunityBookingHall(context, allThreeFormJson);

      print('----657---$onlineComplaintResponse');
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

      if (sApplicantName.isEmpty) {
        displayToast('Please Enter Application Name');
        return;
      }
      if (sMobileNo.isEmpty) {
        displayToast('Please Enter Application Mobile No');
        return;
      }
      if (sAddress.isEmpty) {
        displayToast('Please Enter Application Address');
        return;
      }
      if (_selectediCommunityHallId == null) {
        displayToast('Please Select Community Hall');
        return;
      }
      if(uplodedImage==null || uplodedImage==""){
      displayToast('Select Document 1');
      return;
    }
      if (dPurposeOfBooking.isEmpty) {
        displayToast('Please Enter Purpose of Booking');
      }
    }
  }

  Widget _buildDateTile(String dDate, bool isSelected, Color color, VoidCallback onTap) {
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
                    color: Colors.white.withOpacity(0.5), // Background color for circle
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
 // pdf dialog
 // pdfViewFunction


  //
  Widget _buildImageButton(String text, String assetPath, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(assetPath, width: 16, height: 16, fit: BoxFit.cover),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPdfCard({
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.grey[300],
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity, // Take full available width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image or PDF section
            GestureDetector(
              onTap: (){
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
                                                )
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
                    child: Icon(Icons.picture_as_pdf,
                        size: 100, color: Colors.red),
                  )
                      : Image.network(
                    uplodedImage!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover, // Fill container
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                          child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image,
                        size: 100,
                        color: Colors.grey),
                  ),
                )
                    : const Center(
                  child: Icon(Icons.picture_as_pdf,
                      size: 100,
                      color: Colors.grey),
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
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF96DFE8), // Custom background color
                      borderRadius: BorderRadius.circular(
                          10), // Optional: If you want rounded corners
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("1. Application Details",
                            style: AppTextStyle
                                .font14OpenSansRegularBlackTextStyle,
                          ),
                        ),
                        IconButton(
                          icon: AnimatedRotation(
                            turns: isIconRotated ? 0.5 : 0.0,
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
                              isFormVisible = !isFormVisible;
                              isIconRotated = !isIconRotated;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Conditional visibility for the form
                  if (isFormVisible)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: isFormVisible ? 510 : 0,
                      // Show or hide based on form visibility
                      child: Visibility(
                        visible: isFormVisible,
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Application Name
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text('Application Name',
                                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
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
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              focusNode: _applicationNamefocus,
                                              controller: _applicationNameController,
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
                                                fillColor: Color(
                                                    0xFFf2f3f5), // Set your desired background color here
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
                                // Application mobile no
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Applicant Mobile No',
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
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              focusNode:
                                                  _applicationMoboileNofocus,
                                              controller:
                                                  _applicationMoboileNoController,
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
                                                fillColor: Color(
                                                    0xFFf2f3f5), // Set your desired background color here
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                // Only allow numeric input
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                                // Limit input to 10 digits
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Application Address
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Applicant Address',
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
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              focusNode: _applicantAddressfocus,
                                              controller:
                                                  _applicantAddressController,
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
                                                fillColor: Color(
                                                    0xFFf2f3f5), // Set your desired background color here
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
                                // Month
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Months',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Dropdown month
                                _bindMonthList(),
                                // Community Hall
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Community Hall',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                // DropDown Communioty Hall
                                _bindWard(),
                                // PerDay Amount
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Per Day Amount',
                                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "${_selectedRatePerDay ?? 0}",
                                                style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle,
                                                textAlign: TextAlign.left, // Aligns the text to the left
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // images code
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Uplode Identity Document',
                                        style: AppTextStyle
                                            .font14OpenSansRegularBlack45TextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                //----Card
                                SizedBox(height: 5),
                                // Purpose of Booking
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    // Align items vertically
                                    children: <Widget>[
                                      CircleWithSpacing(),
                                      // Space between the circle and text
                                      Text(
                                        'Purpose of Booking',
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
                                    // Increased height to accommodate error message without resizing
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              focusNode: _purposeOfBookingfocus,
                                              controller:
                                                  _purposeOfBookingController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onEditingComplete: () =>
                                                  FocusScope.of(context)
                                                      .nextFocus(),
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
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    border: Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: Row(
                                    children: [
                                      /// First Column
                                      Expanded(
                                        child: Container(
                                          color: Colors.blue.shade100,
                                          child: Center(
                                            child: RichText(
                                              text: const TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Document 1 ",
                                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                                  ),
                                                  TextSpan(
                                                    text: "*",
                                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            )

                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),

                                      /// Second Column
                                      Expanded(
                                        child: Container(
                                          color: Colors.green.shade100,
                                          child: const Center(
                                            child: Text(
                                              "Document 2",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: Row(
                                    children: [
                                      /// First Column
                                      Expanded(
                                        child: GestureDetector(
                                          onTap:(){
                                            if (uplodedImage != null) {
                                              final filePath = uplodedImage.toLowerCase();
                                              if (filePath.endsWith('.pdf')) {
                                                print("Opening PDF: $uplodedImage");
                                                openPdf(context, uplodedImage); // Your PDF opening function
                                              } else {
                                                print("Opening Image: $uplodedImage");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => FullScreenImages(image: uplodedImage),
                                                  ),
                                                );
                                               // openImage(context, uplodedImage); // Your Image opening function
                                              }
                                            } else {
                                              print("❌ No file to open");
                                            }
                                        //print('-----1652----');
                                       // print("pdf : $uplodedImage");
                                        // open Pdf
                                       // openPdf(context,uplodedImage);

                                        },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                            child: image != null
                                                ? ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: image!.path.toLowerCase().endsWith('.pdf')
                                                  ? Container(
                                                color: Colors.grey[200],
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.picture_as_pdf,
                                                    color: Colors.red,
                                                    size: 50, // smaller for responsiveness
                                                  ),
                                                ),
                                              )
                                                  : Image.file(
                                                image!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,  // full width
                                                height: double.infinity, // full height
                                              ),
                                            )
                                                : const Center(
                                              child: Text(
                                                'No File Available',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )

                                      ),
                                      SizedBox(width: 5),
                                      /// Second Column
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){
                                            if (uplodedImage2 != null) {
                                              final filePath = uplodedImage2.toLowerCase();
                                              if (filePath.endsWith('.pdf')) {
                                                print("Opening PDF: $uplodedImage2");
                                                openPdf(context, uplodedImage2); // Your PDF opening function
                                              } else {
                                                print("Opening Image: $uplodedImage2");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => FullScreenImages(image: uplodedImage),
                                                  ),
                                                );
                                                // openImage(context, uplodedImage); // Your Image opening function
                                              }
                                            } else {
                                              print("❌ No file to open");
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                            child: image2 != null
                                                ? ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: image2!.path.toLowerCase().endsWith('.pdf')
                                                  ? Container(
                                                color: Colors.grey[200],
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.picture_as_pdf,
                                                    color: Colors.red,
                                                    size: 50, // smaller for responsiveness
                                                  ),
                                                ),
                                              )
                                                  : Image.file(
                                                image2!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,  // full width
                                                height: double.infinity, // full height
                                              ),
                                            )
                                                : const Center(
                                              child: Text(
                                                'No File Available',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Container with images and gallery
                                Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// First Column
                                Expanded(
                                  child: Row(
                                    children: [
                                      _buildImageButton("Photo", "assets/images/ic_camera.PNG", onTap: () async{
                                        print("----1686--- Camra");
                                        // Camera Logic
                                        SharedPreferences
                                        prefs = await SharedPreferences.getInstance();
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

                                      }),
                                      const SizedBox(width: 8),
                                      _buildImageButton("Gallery", "assets/images/ic_camera.PNG", onTap: () async {
                                        // Gallery Logic
                                        print("----1686--- Gallery");
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
                                      }),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10), // Gap between columns
                                /// Second Column
                                Expanded(
                                  child: Row(
                                    children: [
                                      _buildImageButton("Photo", "assets/images/ic_camera.PNG", onTap: () async {
                                        // Camera Logic for second column
                                        print('---Second Colume Camra --');
                                        SharedPreferences
                                        prefs = await SharedPreferences.getInstance();
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
                                          image2 = File(
                                            pickFileid!
                                                .path,
                                          );
                                        });
                                        print(
                                          "----171----pic path : ---$image2",
                                        );
                                        if (pickFileid !=
                                            null) {
                                          setState(() {
                                            _imageFiles.add(
                                              File(
                                                image2!.path,
                                              ),
                                            // _imageFiles.add(
                                            //   File(
                                            //     pickFileid.path,
                                            //   ),
                                            ); // Add selected image to list
                                            uploadImage2(
                                              sToken!,
                                              image2!,
                                            );
                                          });
                                        }
                                      }),
                                      const SizedBox(width: 8),
                                      _buildImageButton("Gallery", "assets/images/ic_camera.PNG", onTap: () async {
                                        // Gallery Logic for second column
                                        print('---Second Colume Gallery --');
                                        SharedPreferences
                                        prefs = await SharedPreferences.getInstance();
                                        String? sToken = prefs.getString('sToken');

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
                                            image2 = File(result.files.single.path!);
                                            String filePath = image2!.path;
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
                                                    image2!.path,
                                                  ),
                                                ); // Add selected image to list
                                                uploadImage2(
                                                  sToken!,
                                                  image2!,
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
                                                    image2!.path,
                                                  ),
                                                ); // Add selected image to list
                                                uploadImage2(
                                                  sToken!,
                                                  image2!,
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

                                              uploadImage2(
                                                sToken,
                                                image2!,
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
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                                // buildPdfCard(
                                //     onCameraTap: () {
                                //       print("-----1423----Camra---");
                                //       pickImageCamra();
                                //       },
                                //     onGalleryTap: () {
                                //       pickGallery();
                                //     }
                                // ),
                                SizedBox(height: 10)

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isSuccess)
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Container(
                            // height: 90,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  // Equal space between columns
                                  children: [
                                    // First Column
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // Center align in the column
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                                5), // Rounded corners
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Spacing between Container and Text
                                        const Text(
                                          'Available',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    // Second Column
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // Center align in the column
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Spacing between Container and Text
                                        const Text(
                                          'Waiting',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    // Third Column
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      // Center align in the column
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Spacing between Container and Text
                                        const Text(
                                          'Booked',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF96DFE8),
                                    // Custom background color
                                    borderRadius: BorderRadius.circular(
                                        10), // Optional: If you want rounded corners
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "2. Community Bookings Dates",
                                          style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                        ),
                                      ),
                                      IconButton(
                                        icon: AnimatedRotation(
                                          turns: isIconRotated2
                                              ? 0.5
                                              : 0.0, // Rotates the icon
                                          duration: Duration(milliseconds: 300),
                                          child: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // Toggle form visibility and icon rotation
                                            isFormVisible2 = !isFormVisible2;
                                            isIconRotated2 = !isIconRotated2;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                   // height: 250,
                                   // height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      //itemCount: 2 ?? 0,
                                     physics: NeverScrollableScrollPhysics(),
                                      itemCount: bindcommunityHallDate?.length ?? 0,
                                      itemBuilder: (context, index) {

                                        int status = bindcommunityHallDate[index]['iStatus'];

                                        Color itemColor;
                                        if (status == 0) {
                                          itemColor = Colors.blue;
                                        } else if (status == 1) {
                                          itemColor = Colors.green;
                                        } else if (status == 2) {
                                          itemColor = Colors.red;
                                        } else {
                                          itemColor = Colors.grey;
                                        }
                                        // Check if the item is selected
                                        bool isSelected = selectedIndices.contains(index);
                                        return Column(
                                          children: <Widget>[
                                            Visibility(
                                                visible: isFormVisible2,
                                                child:
                                                GestureDetector(
                                                  onTap: () {
                                                    var date = bindcommunityHallDate[index]['dDate'];
                                                    var iStatus = bindcommunityHallDate[index]['iStatus'];
                                                    print("-----1257---$iStatus");

                                                    if (iStatus == 0) {
                                                      // Only allow selection for status 0
                                                      setState(() {
                                                        if (isSelected) {
                                                          // Remove the index from selected indices
                                                          selectedIndices.remove(index);
                                                          // Remove the corresponding date from selected dates list
                                                          seleccteddates.removeWhere((element) => element["dBookingDate"] == date);
                                                          displayToast("Remove Date: $date");
                                                        } else {
                                                          // Add the index and date if it's being selected
                                                          selectedIndices.add(index);
                                                          seleccteddates.add({"dBookingDate": date});
                                                          displayToast("Selected Date: $date");
                                                        }
                                                      });
                                                      print("Updated selected dates: $seleccteddates");
                                                    } else if (iStatus == 1) {
                                                      // Prevent selection and show message for waiting status
                                                      displayToast("Date is in waiting status, cannot be selected.");
                                                    } else if (iStatus == 2) {
                                                      displayToast("Already Booked");
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                    //color: itemColor,
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? Colors.lightBlueAccent : Colors.white,
                                                      borderRadius: BorderRadius.circular(22),
                                                      border: Border.all(
                                                        color: itemColor,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                                          child: Text(
                                                            bindcommunityHallDate[index]['dDate'],
                                                            style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        if (isSelected)
                                                          const Padding(
                                                            padding: EdgeInsets.only(right: 16),
                                                            child: Icon(
                                                              Icons.check,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    // child: Text(bindcommunityHallDate[index]['dDate'],style: TextStyle(
                                                    //   color: Colors.black45,fontSize: 14
                                                    // ),),
                                                  ),
                                                ))
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          )),
                          // bottomButton
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      print("----Submit---");
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
                          style:
                              AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // CAMRA
  Future<void> _pickImage(isFirstColumn) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        if (isFirstColumn) {
          _imageFile1 = File(pickedFile.path);
          isFirstColumn=false;
        } else {
          _imageFile2 = File(pickedFile.path);
        }
      });
    }
  }

  Widget buildDocumentCard(String title, File? imageFile, bool isFirstDoc) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// Title
            Text(title, style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
            SizedBox(height: 10),
            /// Image Container
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: imageFile == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 30, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    "Image Not Available",
                    style: AppTextStyle
                        .font14OpenSansRegularBlack45TextStyle
                  ),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(height: 10),

            /// Row with two action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Camera Button
                Expanded(
                  child: GestureDetector(
                    child: GestureDetector(
                      onTap: (){
                       // bool isFirstColumn;
                        _pickImage(isFirstColumn);
                        print('----1945---');

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // reduced padding
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: const FittedBox( // This will auto-scale icon + text
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt, color: Colors.blue, size: 18), // reduced icon size
                              SizedBox(width: 6),
                              Text(
                                "Photo",
                                style: TextStyle(color: Colors.blue, fontSize: 14), // smaller font
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                /// Gallery Button
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Icon(Icons.image, color: Colors.green, size: 18),
                            SizedBox(width: 6),
                            Text(
                              "Gallery",
                              style: TextStyle(color: Colors.green, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
