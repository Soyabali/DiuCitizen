import 'package:flutter/material.dart';

import '../../../app/generalFunction.dart';
import '../../../services/SearchPropertyTaxForPaymentRepo.dart';
import '../../../services/bindCityzenWardRepo.dart';
import '../../../services/getEmergencyContactTitleRepo.dart';
import '../../aboutDiu/Aboutdiupage.dart';
import '../../circle/circle.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';

class PropertyTaxDiu extends StatefulWidget {

  final name;
  const PropertyTaxDiu({super.key, required this.name});

  @override
  State<PropertyTaxDiu> createState() => _PropertyTaxState();
}

class _PropertyTaxState extends State<PropertyTaxDiu> {

  GeneralFunction generalFunction = GeneralFunction();

  List<dynamic> wardList = [];
  var _dropDownWard;

  //
  TextEditingController _houseController = TextEditingController();
  TextEditingController _houseOwnerName = TextEditingController();

  FocusNode _housefocus = FocusNode();
  FocusNode _houseOwnerfocus = FocusNode();
  //
  List<Map<String,dynamic>>? emergencyTitleList;
  List<Map<String,dynamic>>? emergencyTitleList2;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  var houseNo;

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

  getEmergencyTitleResponse(selectedWardId, String houseno, String houseOwnerName) async {
   // final List<dynamic> list = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
    emergencyTitleList = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
    print('------57-----xxxx---xx----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }
  // online title
  var OnlineTitle = ["Property Tax",
    "Building Plan",
    "Property Assessment",
    "License",
    "Community Hall",
    "Water Supply",
    "Electricity Bill",
    "Mamlatdar Diu"
  ];


  var _selectedWardId;
  // dropDown
  bindWard() async {
    wardList = await BindCityzenWardRepo().getbindWard(context);
    print(" -----xxxxx-  wardList--50---> $wardList");
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
                isExpanded: true, // Allows the DropdownButton to take full width
                dropdownColor: Colors.grey, // Set dropdown list background color
                iconEnabledColor: Colors.white, // Icon color (keeps the icon white)
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
                style: TextStyle(color: Colors.white), // Selected item text color
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sWardName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sWardName'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white), // Dropdown menu item text color
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
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context,'${widget.name}'),
        // appBar: getAppBarBack(context,'ssss999'),
        //drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body: Column(
            children: [
              SizedBox(height: 5),
              _bindWard(),
              SizedBox(height: 10),
              // EditText
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
                            focusNode: _housefocus, // Focus node for the text field
                            controller: _houseController, // Controller to manage the text field's value
                            textInputAction: TextInputAction.next, // Set action for the keyboard
                            onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(), // Add a border around the text field
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ), // Adjust padding inside the text field
                              filled: true, // Enable background color for the text field
                              fillColor: Color(0xFFf2f3f5), // Set background color
                              hintText: "House No", // Placeholder text when field is empty
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
              Center(
                 child: Text("or",
                     style: AppTextStyle.font16OpenSansRegularBlack45TextStyle
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
                              focusNode: _houseOwnerfocus, // Focus node for the text field
                              controller: _houseOwnerName, // Controller to manage the text field's value
                              textInputAction: TextInputAction.next, // Set action for the keyboard
                              onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(), // Add a border around the text field
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ), // Adjust padding inside the text field
                                filled: true, // Enable background color for the text field
                                fillColor: Color(0xFFf2f3f5), // Set background color
                                hintText: "House Owner Name", // Placeholder text when field is empty
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Your onTap logic here

                    var houseno = _houseController.text.trim();
                    var houseOwnerName = _houseOwnerName.text.trim();
                    print("----Selected Ward-----236---$_selectedWardId");
                    print("----houseno----240---$houseno");
                    print("----houseOwnerName-----241---$houseOwnerName");
                    if(_selectedWardId!=null && _selectedWardId!="" && houseno.isNotEmpty || houseOwnerName.isNotEmpty){
                       print("---Call APi---");
                       getEmergencyTitleResponse(_selectedWardId,houseno,houseOwnerName);
                    }else{
                      print("---Not Call APi---");
                      displayToast("Please enter the required details.");
                    }
                    // getEmergencyTitleResponse();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF255898), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20, // Horizontal padding for spacing
                      vertical: AppPadding.p10,   // Vertical padding for height
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
                  :
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          //height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: emergencyTitleList?.length ?? 0,
                                    // itemCount: OnlineTitle?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final color = borderColors[index % borderColors.length];
                                      houseNo = "${emergencyTitleList![index]['sHouseNo']}";

                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10,right: 10),
                                            child: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFD5E6FA), // Hex color #d5e6fa
                                                        borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5),
                                                            child: Center(
                                                              child: Container(
                                                                width: 50, // Width of the container
                                                                height: 50, // Height of the container
                                                                decoration: const BoxDecoration(
                                                                  color: Colors.grey, // Gray background
                                                                  shape: BoxShape.circle, // Circular shape
                                                                ),
                                                                child: Container(
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
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 15),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(emergencyTitleList![index]['sHouseNo'],
                                                                    style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                                                                  ),
                                                                  SizedBox(height: 5),
                                                                  Text("House No",
                                                                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 0,top: 10),
                                                            child: Container(
                                                              margin: EdgeInsets.all(16),
                                                              // color: Colors.black54,
                                                              decoration: BoxDecoration(
                                                                color: Color(0xFF96b2e1), // Background color
                                                                borderRadius: BorderRadius.circular(10), // Rounded corners
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.black.withOpacity(0.1), // Shadow color
                                                                    blurRadius: 10,
                                                                    spreadRadius: 2,
                                                                    offset: Offset(0, 5), // Shadow position
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xFF96b2e1), // Hex color #d5e6fa
                                                                  borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                                                                ),
                                                                margin: EdgeInsets.all(5),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    const Icon(Icons.calendar_month,size: 20),
                                                                    SizedBox(width: 5),
                                                                    Text(emergencyTitleList![index]['TaxNoOfYears'],
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularWhiteTextStyle,

                                                                    )
                                                                  ],
                                                                ),
                                                              ),

                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      // Align items vertically
                                                      children: <Widget>[
                                                        CircleWithSpacing(),
                                                        // Space between the circle and text
                                                        Text(
                                                          'Property Details :',
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
                                                          color:Colors.black12,
                                                          // color: Color(0xf6f6f6), // Hex color #d5e6fa
                                                          borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                                                        ),
                                                        child:Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 15,left: 10),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("Owner Name",
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlackTextStyle,
                                                                    ),
                                                                    SizedBox(height: 5),
                                                                    Text(emergencyTitleList![index]['sHouseOwnerName'],
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlack45TextStyle,
                                                                    ),
                                                                  ],
                                                                ),

                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding: EdgeInsets.only(right: 10),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Center(
                                                                    child: Text("Ward",
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlackTextStyle,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 5),
                                                                  Center(
                                                                    child: Text(emergencyTitleList![index]['sWardName'],
                                                                      style: const TextStyle(
                                                                          color: Colors.black54,
                                                                          fontSize: 14
                                                                      ),),
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
                                                          color:Colors.black12,
                                                          //color: Color(0xf6f6f6), // Hex color #d5e6fa
                                                          borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                                                        ),
                                                        child:Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 15,left: 10),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("House Area",
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlackTextStyle,
                                                                    ),
                                                                    SizedBox(height: 5),
                                                                    Text(emergencyTitleList![index]['fSeqFeet'],
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlack45TextStyle,
                                                                    ),
                                                                  ],
                                                                ),

                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding: EdgeInsets.only(right: 10),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Center(
                                                                    child: Text("Amount",
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlackTextStyle,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 5),
                                                                  Center(
                                                                    child: Text('₹ ${emergencyTitleList![index]['fAmount'].toString()}',
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

                                                  ],
                                                )
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                    
                        ),
                        // position
                        Positioned(
                          bottom: 8, // Adjust position as needed
                          right: 10, // Adjust position as needed
                          child: InkWell(
                            onTap: (){

                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return paymentDialog(dialogContext);
                                },
                              );
                              },

                            child: Container(
                              height: 50,
                              width: 50,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/pay_now.png"), // Change path
                                    fit: BoxFit.fill,
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
        )
      );

  }
  // paymentDialog widget
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
                    'Choose Payment Gateway',
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
                      var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
                      // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
                      var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
                      var sPageName = "Property Tax";

                      // close the DialogBox
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AboutDiuPage(name: sPageName, sPageLink: baseurl)),
                      );
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
                              'assets/images/bankborda.png',
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            const Text(
                              'BOB',
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

                      var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
                      // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
                      // var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
                      var baseurl = "https://www.diusmartcity.com/SBIPropertyTaxDataformGetewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
                      var sPageName = "Property Tax";
                      print('-----baseURL--$baseurl');
                      // close the dialogbOS

                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AboutDiuPage(name: sPageName, sPageLink: baseurl)),
                      );
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
                              'assets/images/banksbi.png',
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            const Text(
                              'SBI',
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

}
