import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puri/services/SearchLicenseForPaymentRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/generalFunction.dart';
import '../../../../services/bindCityzenWardRepo.dart';
import '../../../aboutDiu/Aboutdiupage.dart';
import '../../../circle/circle.dart';
import '../../../nodatavalue/NoDataValue.dart';
import '../../../resources/app_text_style.dart';
import '../../../resources/values_manager.dart';

class Onlinelicense extends StatefulWidget {

  final name;
  const Onlinelicense({super.key, required this.name});

  @override
  State<Onlinelicense> createState() => _PropertyTaxState();
}

class _PropertyTaxState extends State<Onlinelicense> {

  GeneralFunction generalFunction = GeneralFunction();

  List<dynamic> wardList = [];
  var _dropDownWard;

  TextEditingController _houseController = TextEditingController();
  TextEditingController _houseOwnerName = TextEditingController();

  FocusNode _housefocus = FocusNode();
  FocusNode _houseOwnerfocus = FocusNode();
  //
  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  var licenseRequestId;

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
  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse(selectedWardId, String licenseRequestID, String mobileNo) async {
    emergencyTitleList = await SearchLicenseForPaymentRepo()
        .searchLicenseForPayment(context,selectedWardId,licenseRequestID,mobileNo);
    print('------58---xx------$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }
  var _selectedWardId;
  // dropDown
  bindWard() async {
    wardList = await BindCityzenWardRepo().getbindWard(context);
    setState(() {});
  }

  // bind
  Widget _bindWard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 42,
          color: Color(0xFF255898), // Background color
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true, // Reduces the vertical size of the button
                isExpanded:
                    true, // Allows the DropdownButton to take full width
                dropdownColor:
                    Colors.grey, // Set dropdown list background color
                iconEnabledColor:
                    Colors.white, // Icon color (keeps the icon white)
                hint: RichText(
                  text: TextSpan(
                    text: "Select Ward",
                    style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
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
                    print("------99-----$_selectedWardId");
                  });
                },
                style:
                    TextStyle(color: Colors.white), // Selected item text color
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sWardName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sWardName'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors
                                    .white), // Dropdown menu item text color
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

  @override
  void initState() {
    // TODO: implement initState
    bindWard();
    _housefocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _housefocus.dispose();
    _houseController.dispose();
    _houseOwnerfocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: getAppBarBack(context, '${widget.name}'),
         // drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
          body: Column(
            children: [
              SizedBox(height: 5),
              _bindWard(),
              SizedBox(height: 10),
              // EditText
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 55,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Column(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                        focusNode: _housefocus, // Focus node for the text field
                                        controller:
                                        _houseController, // Controller to manage the text field's value
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction
                                            .next, // Set action for the keyboard
                                        onEditingComplete: () => FocusScope.of(context)
                                            .nextFocus(), // Move to next input on completion
                                        decoration: const InputDecoration(
                                          border:
                                          OutlineInputBorder(), // Add a border around the text field
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 10.0,
                                          ), // Adjust padding inside the text field
                                          filled:
                                          true, // Enable background color for the text field
                                          fillColor:
                                          Color(0xFFf2f3f5), // Set background color
                                          hintText:
                                          "Licence Number", // Placeholder text when field is empty
                                          hintStyle: TextStyle(
                                              color: Colors
                                                  .grey), // Style for the placeholder text
                                        ),
                                        autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                          LengthLimitingTextInputFormatter(8), // Restrict input to a maximum of 10 digits
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //     child: TextFormField(
                        //   focusNode:
                        //       _housefocus, // Focus node for the text field
                        //   controller:
                        //       _houseController, // Controller to manage the text field's value
                        //   textInputAction: TextInputAction
                        //       .next, // Set action for the keyboard
                        //   onEditingComplete: () => FocusScope.of(context)
                        //       .nextFocus(), // Move to next input on completion
                        //   decoration: const InputDecoration(
                        //     border:
                        //         OutlineInputBorder(), // Add a border around the text field
                        //     contentPadding: EdgeInsets.symmetric(
                        //       vertical: 10.0,
                        //       horizontal: 10.0,
                        //     ), // Adjust padding inside the text field
                        //     filled:
                        //         true, // Enable background color for the text field
                        //     fillColor:
                        //         Color(0xFFf2f3f5), // Set background color
                        //     hintText:
                        //         "Licence Number", // Placeholder text when field is empty
                        //     hintStyle: TextStyle(
                        //         color: Colors
                        //             .grey), // Style for the placeholder text
                        //   ),
                        //   autovalidateMode: AutovalidateMode
                        //       .onUserInteraction, // Enable validation on user interaction
                        // )
                        //
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Text("or",
                    style: AppTextStyle.font16OpenSansRegularBlack45TextStyle),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        Expanded(
                            child: TextFormField(
                          focusNode: _houseOwnerfocus, // Focus node for the text field
                          controller:
                              _houseOwnerName, // Controller to manage the text field's value
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction
                              .next, // Set action for the keyboard
                          onEditingComplete: () => FocusScope.of(context)
                              .nextFocus(), // Move to next input on completion
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(), // Add a border around the text field
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ), // Adjust padding inside the text field
                            filled:
                                true, // Enable background color for the text field
                            fillColor:
                                Color(0xFFf2f3f5), // Set background color
                            hintText:
                                "Mobile NO", // Placeholder text when field is empty
                            hintStyle: TextStyle(
                                color: Colors
                                    .grey), // Style for the placeholder text
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                LengthLimitingTextInputFormatter(10), // Restrict input to a maximum of 10 digits
                              ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Your onTap logic here

                    var licenseRequestID = _houseController.text.trim();
                    var mobileNo = _houseOwnerName.text.trim();

                    if (_selectedWardId != null &&
                            _selectedWardId != "" &&
                        licenseRequestID.isNotEmpty ||
                        mobileNo.isNotEmpty) {
                      print("---Call APi---");

                      getEmergencyTitleResponse(_selectedWardId, licenseRequestID, mobileNo);

                    } else {
                      print("---Not Call APi---");
                      displayToast("Please enter the required details.");
                    }

                    // getEmergencyTitleResponse();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF255898), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppMargin.m10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal:
                          AppPadding.p20, // Horizontal padding for spacing
                      vertical: AppPadding.p10, // Vertical padding for height
                    ),
                    elevation: 2, // Add slight elevation for the button
                  ),
                  child: Text(
                    "SEARCH",
                    style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 5),
              isLoading
                  ? Center(child: Container())
                  : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
                      ? NoDataScreenPage()
                      : Container(
                          child: Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: emergencyTitleList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  licenseRequestId = "${emergencyTitleList![index]['sLicenseRequestCode']}";
                                  final color = borderColors[index % borderColors.length];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Container(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                    0xFFD5E6FA), // Hex color #d5e6fa
                                                borderRadius: BorderRadius.circular(
                                                    10), // Optional: Rounded corners
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Center(
                                                      child: Container(
                                                        width:
                                                            50, // Width of the container
                                                        height:
                                                            50, // Height of the container
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors
                                                              .grey, // Gray background
                                                          shape: BoxShape
                                                              .circle, // Circular shape
                                                        ),
                                                        child: Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  color, // Set the dynamic color
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: const Icon(
                                                              Icons.ac_unit,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 15),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            emergencyTitleList![index]['sLicenseRequestNo'].toString(),
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlackTextStyle,
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text("License Request Id",
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlack45TextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              // Align items vertically
                                              children: <Widget>[
                                                CircleWithSpacing(),
                                                // Space between the circle and text
                                                Text(
                                                  'Premises Details :',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularGreenTextStyle,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  // color: Color(0xf6f6f6), // Hex color #d5e6fa
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Optional: Rounded corners
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 15, left: 10),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Premises Name",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              emergencyTitleList![
                                                                      index][
                                                                  'sShopName'],
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          right: 10),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              "Ward",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Center(
                                                            child: Text(
                                                              emergencyTitleList![
                                                                      index]
                                                                  ['sWardName'],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  //color: Color(0xf6f6f6), // Hex color #d5e6fa
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Optional: Rounded corners
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 15, left: 10),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Applicant Name",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              emergencyTitleList![
                                                                      index]
                                                                  ['sShopOwnreName'],
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              "Amount",
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlackTextStyle,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Center(
                                                            child: Text(
                                                              '₹ ${emergencyTitleList![index]['fTexAmuont'].toString()}',
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularBlack45TextStyle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end, // Aligns the container to the right
                                                children: [
                                                  InkWell(
                                                 onTap: () async{
                                                   SharedPreferences prefs = await SharedPreferences.getInstance();
                                                   String? sContactNo = prefs.getString('sContactNo');
                                                    print("-----611---");
                                                   // var baseurl = "https://www.diusmartcity.com/LicensePaymentGatewayMobile.aspx?QS=";
                                                    //var baseurl ="https://www.diusmartcity.com/root/User/PaymentLicenceFee.aspx?id=";
                                                    var baseurl ="https://www.diusmartcity.com/User/PaymentLicenceFee.aspx?id=";

                                                    var paymentUrl = "$baseurl$licenseRequestId&user=$sContactNo";
                                                   // var paymentUrl = "$baseurl$licenseRequestId";
                                                    var sPageName = "Online License";
                                                    if(licenseRequestId!=null){
                                                      print("---licenseRequestId----$licenseRequestId");
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) =>
                                                            AboutDiuPage(name: sPageName, sPageLink: paymentUrl)),
                                                      );
                                                    }else{
                                                      print("---licenseRequestId----$licenseRequestId");
                                                    }
                                                    },
                                                    child: Container(
                                                      height: 45,
                                                      width:
                                                          150, // Set the width of the container
                                                      padding: const EdgeInsets.only(
                                                          right:
                                                              16), // Optional padding
                                                      alignment: Alignment
                                                          .center, // Aligns text inside the container
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius.circular(10), // Rounded corners
                                                      ),
                                                      child: Text(
                                                        "Make Payment",
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularWhiteTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        )),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ),
            ],
          )),
    );
  }
}
