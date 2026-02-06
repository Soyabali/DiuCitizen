import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/generalFunction.dart';
import '../../../services/SearchPropertyTaxForPaymentRepo.dart';
import '../../../services/bindCityzenWardRepo.dart';
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
  //List<Map<String,dynamic>>? emergencyTitleList2;
  bool isLoading = true; // logic
  //String? sName, sContactNo;
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

  // getEmergencyTitleResponse(selectedWardId, String houseno, String houseOwnerName) async {
  //   // final List<dynamic> list = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
  //   emergencyTitleList = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
  //   print('------58-----xxxx---xx----$emergencyTitleList');
  //   if(emergencyTitleList==null || emergencyTitleList!.isEmpty){
  //
  //     displayToast('Note: Please submit the property assessment request details and proceed.');
  //
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  getEmergencyTitleResponse(
      selectedWardId,
      String houseno,
      String houseOwnerName,
      ) async {

    setState(() {
      isLoading = true;
    });

    final response =
    await SearchPropertyTaxForPaymentRepo()
        .searchPropertyTaxForPayment(
        context, selectedWardId, houseno, houseOwnerName);

    /// 🔹 SAME LIST AS BEFORE
    emergencyTitleList = response.data;

    /// 🔹 NEW: message & result
    print("Result 👉 ${response.result}");
    print("Message 👉 ${response.message}");

    if (emergencyTitleList == null || emergencyTitleList!.isEmpty) {
      print("---91----${response.message}");
      displayToast(response.message); // ✅ dynamic API msg
    }

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
  Widget _buildMainUI() {
    return SizedBox(
      width: double.infinity, // ✅ forces layout width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 5),
          _bindWard(),
          const SizedBox(height: 10),

          _houseField(),
          _orText(),
          _ownerField(),
          _searchButton(),

          const SizedBox(height: 8),

          /// 🔹 RESULT SECTION
          if (isLoading)
            SizedBox(
              height: 200, // ✅ gives GestureDetector size
              child: buildShimmerList(),
            )
          else if (emergencyTitleList == null ||
              emergencyTitleList!.isEmpty)
            SizedBox(
              height: 200, // ✅ REQUIRED
              child: NoDataScreenPage(),
            )
          else
            ListView.builder(
              itemCount: emergencyTitleList!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildPropertyItem(index);
              },
            ),
        ],
      ),
    );
  }

  // houseFiled
  Widget _houseField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _houseController,
        focusNode: _housefocus,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFf2f3f5),
          hintText: "House No",
          contentPadding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  // houseOWNER FIELDS
  Widget _ownerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _houseOwnerName,
        focusNode: _houseOwnerfocus,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFf2f3f5),
          hintText: "House Owner Name",
          contentPadding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  // OR TEXT
  Widget _orText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Text(
          "or",
          style: AppTextStyle.font16OpenSansRegularBlack45TextStyle,
        ),
      ),
    );
  }
  // SearchButton
  Widget _searchButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          var houseno = _houseController.text.trim();
          var houseOwnerName = _houseOwnerName.text.trim();

          if (_selectedWardId != null &&
              _selectedWardId != "" &&
              (houseno.isNotEmpty || houseOwnerName.isNotEmpty)) {

            getEmergencyTitleResponse(_selectedWardId, houseno, houseOwnerName);


          } else {
            displayToast("Please enter the required details.");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF255898),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMargin.m10),
          ),
        ),
        child: Text(
          "SEARCH",
          style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
        ),
      ),
    );
  }
  //
  Widget _resultSection() {
    if (isLoading) return buildShimmerList();

    if (emergencyTitleList == null || emergencyTitleList!.isEmpty) {
      return NoDataScreenPage();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: emergencyTitleList!.length,
      itemBuilder: (context, index) {
        return _buildPropertyItem(index);
      },
    );
  }


// payButton
  Widget _payNowButton() {
    return InkWell(
      onTap: () async {
        var encodedHouseNo = Uri.encodeComponent(houseNo.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? sContactNo = prefs.getString('sContactNo');

        var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
        var baseurl =
            "https://www.diusmartcity.com/User/PropertyPayment.aspx?id=$encodedHouseNo&ward=$iWardCode&user=$sContactNo";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AboutDiuPage(name: "Property Tax", sPageLink: baseurl),
          ),
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Pay-Now-01.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
  //  info window
  Widget _infoRow({
    required String titleLeft,
    required String valueLeft,
    required String titleRight,
    required String valueRight,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),

          // Left Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleLeft,
                style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
              ),
              const SizedBox(height: 4),
              Text(
                valueLeft,
                style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
              ),
            ],
          ),

          const Spacer(),

          // Right Column
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  titleRight,
                  style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  valueRight,
                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // listCODE
  Widget _buildPropertyItem(int index) {
    final color = borderColors[index % borderColors.length];
    houseNo = "${emergencyTitleList![index]['sHouseNo']}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 Top Card
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFD5E6FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const SizedBox(width: 5),

                // Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.ac_unit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // House No
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emergencyTitleList![index]['sHouseNo'],
                      style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "House No",
                      style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    ),
                  ],
                ),

                const Spacer(),

                // Years Box
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF96b2e1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        emergencyTitleList![index]['TaxNoOfYears'],
                        style:
                        AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Property Details title
          Row(
            children: [
              CircleWithSpacing(),
              const SizedBox(width: 6),
              Text(
                'Property Details :',
                style: AppTextStyle.font14OpenSansRegularGreenTextStyle,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Owner Name + Ward
          _infoRow(
            titleLeft: "Owner Name",
            valueLeft: emergencyTitleList![index]['sHouseOwnerName'],
            titleRight: "Ward",
            valueRight: emergencyTitleList![index]['sWardName'],
          ),

          const SizedBox(height: 6),

          // 🔹 Area + Amount
          _infoRow(
            titleLeft: "House Area",
            valueLeft: emergencyTitleList![index]['fSeqFeet'],
            titleRight: "Amount",
            valueRight:
            "₹ ${emergencyTitleList![index]['fAmount'].toString()}",
          ),
        ],
      ),
    );
  }






  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          // appBar: getAppBarBack(context,'${widget.name}'),
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
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
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


          body: SafeArea(
            child: Stack(
              children: [

                // 🔹 Scrollable Content
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: 120),
                  child: _buildMainUI(),
                ),

                // 🔹 Floating Pay Button (OUTSIDE scroll)
                if (emergencyTitleList != null && emergencyTitleList!.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: _payNowButton(),
                  ),
              ],
            ),
          ),

          // body: SafeArea(
          //   child: Column(
          //     children: [
          //       Expanded(
          //         child: SingleChildScrollView(
          //           physics: const BouncingScrollPhysics(),
          //           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          //           child: Padding(
          //             padding: const EdgeInsets.only(bottom: 90),
          //             child: _buildMainUI(),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // body: SafeArea(
          //   child: Column(
          //     children: [
          //       SizedBox(height: 5),
          //       _bindWard(),
          //       SizedBox(height: 10),
          //       // EditText
          //       Padding(
          //         padding:
          //         const EdgeInsets.only(left: 10, right: 10),
          //         child: Container(
          //           height: 55,
          //           child: Padding(
          //             padding: const EdgeInsets.only(left: 0),
          //             child: Column(
          //               children: [
          //                 Expanded(
          //                     child: TextFormField(
          //                       focusNode: _housefocus, // Focus node for the text field
          //                       controller: _houseController, // Controller to manage the text field's value
          //                       textInputAction: TextInputAction.next, // Set action for the keyboard
          //                       onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
          //                       decoration: const InputDecoration(
          //                         border: OutlineInputBorder(), // Add a border around the text field
          //                         contentPadding: EdgeInsets.symmetric(
          //                           vertical: 10.0,
          //                           horizontal: 10.0,
          //                         ), // Adjust padding inside the text field
          //                         filled: true, // Enable background color for the text field
          //                         fillColor: Color(0xFFf2f3f5), // Set background color
          //                         hintText: "House No", // Placeholder text when field is empty
          //                         hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
          //                       ),
          //                       autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
          //                     )
          //
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       Center(
          //         child: Text("or",
          //             style: AppTextStyle.font16OpenSansRegularBlack45TextStyle
          //         ),
          //       ),
          //       SizedBox(height: 5),
          //       Padding(
          //         padding:
          //         const EdgeInsets.only(left: 10, right: 10),
          //         child: Container(
          //           height: 55,
          //           child: Padding(
          //             padding: const EdgeInsets.only(left: 0),
          //             child: Column(
          //               children: [
          //                 Expanded(
          //                     child: TextFormField(
          //                       focusNode: _houseOwnerfocus, // Focus node for the text field
          //                       controller: _houseOwnerName, // Controller to manage the text field's value
          //                       textInputAction: TextInputAction.next, // Set action for the keyboard
          //                       onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
          //                       decoration: const InputDecoration(
          //                         border: OutlineInputBorder(), // Add a border around the text field
          //                         contentPadding: EdgeInsets.symmetric(
          //                           vertical: 10.0,
          //                           horizontal: 10.0,
          //                         ), // Adjust padding inside the text field
          //                         filled: true, // Enable background color for the text field
          //                         fillColor: Color(0xFFf2f3f5), // Set background color
          //                         hintText: "House Owner Name", // Placeholder text when field is empty
          //                         hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
          //                       ),
          //                       autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
          //                     )
          //
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       Center(
          //         child: ElevatedButton(
          //           onPressed: () {
          //             // Your onTap logic here
          //
          //             var houseno = _houseController.text.trim();
          //             var houseOwnerName = _houseOwnerName.text.trim();
          //             if(_selectedWardId!=null && _selectedWardId!="" && houseno.isNotEmpty || houseOwnerName.isNotEmpty){
          //               print("---Call APi---");
          //               getEmergencyTitleResponse(_selectedWardId,houseno,houseOwnerName);
          //             }else{
          //               print("---Not Call APi---");
          //               displayToast("Please enter the required details.");
          //             }
          //             // getEmergencyTitleResponse();
          //           },
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Color(0xFF255898), // Background color
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
          //             ),
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: AppPadding.p20, // Horizontal padding for spacing
          //               vertical: AppPadding.p10,   // Vertical padding for height
          //             ),
          //             elevation: 2, // Add slight elevation for the button
          //           ),
          //           child: Text(
          //             "SEARCH",
          //             style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
          //           ),
          //         ),
          //       ),
          //       SizedBox(height: 5),
          //
          //       isLoading
          //           ? buildShimmerList()
          //           : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
          //           ? NoDataScreenPage()
          //           :
          //       Expanded(
          //         child: Stack(
          //           children: <Widget>[
          //             Container(
          //               //height: MediaQuery.of(context).size.height * 0.8,
          //               child: Column(
          //                 children: [
          //                   Expanded(
          //                     child: ListView.builder(
          //                         shrinkWrap: true,
          //                         itemCount: emergencyTitleList?.length ?? 0,
          //                         // itemCount: OnlineTitle?.length ?? 0,
          //                         itemBuilder: (context, index) {
          //                           final color = borderColors[index % borderColors.length];
          //                           houseNo = "${emergencyTitleList![index]['sHouseNo']}";
          //
          //                           return Column(
          //                             children: [
          //                               Padding(
          //                                 padding: const EdgeInsets.only(left: 10,right: 10),
          //                                 child: Container(
          //                                     child: Column(
          //                                       mainAxisAlignment: MainAxisAlignment.start,
          //                                       crossAxisAlignment: CrossAxisAlignment.start,
          //                                       children: [
          //                                         Container(
          //                                           height: 70,
          //                                           decoration: BoxDecoration(
          //                                             color: Color(0xFFD5E6FA), // Hex color #d5e6fa
          //                                             borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
          //                                           ),
          //                                           child: Row(
          //                                             mainAxisAlignment: MainAxisAlignment.start,
          //                                             crossAxisAlignment: CrossAxisAlignment.start,
          //                                             children: [
          //                                               Padding(
          //                                                 padding: const EdgeInsets.only(left: 5),
          //                                                 child: Center(
          //                                                   child: Container(
          //                                                     width: 50, // Width of the container
          //                                                     height: 50, // Height of the container
          //                                                     decoration: const BoxDecoration(
          //                                                       color: Colors.grey, // Gray background
          //                                                       shape: BoxShape.circle, // Circular shape
          //                                                     ),
          //                                                     child: Container(
          //                                                         width: 35,
          //                                                         height: 35,
          //                                                         decoration: BoxDecoration(
          //                                                           color: color, // Set the dynamic color
          //                                                           borderRadius: BorderRadius.circular(5),
          //                                                         ),
          //                                                         child: const Icon(Icons.ac_unit,
          //                                                           color: Colors.white,
          //                                                         )
          //                                                     ),
          //                                                   ),
          //                                                 ),
          //                                               ),
          //                                               SizedBox(width: 10),
          //                                               Padding(
          //                                                 padding: EdgeInsets.only(top: 15),
          //                                                 child: Center(
          //                                                   child: Column(
          //                                                     mainAxisAlignment: MainAxisAlignment.start,
          //                                                     crossAxisAlignment: CrossAxisAlignment.start,
          //                                                     children: [
          //                                                       Text(emergencyTitleList![index]['sHouseNo'],
          //                                                         style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
          //                                                       ),
          //                                                       SizedBox(height: 5),
          //                                                       Text("House No",
          //                                                         style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
          //                                                       ),
          //
          //                                                     ],
          //                                                   ),
          //                                                 ),
          //                                               ),
          //                                               Spacer(),
          //                                               Padding(
          //                                                 padding: const EdgeInsets.only(right: 0,top: 10),
          //                                                 child: Container(
          //                                                   margin: EdgeInsets.all(16),
          //                                                   // color: Colors.black54,
          //                                                   decoration: BoxDecoration(
          //                                                     color: Color(0xFF96b2e1), // Background color
          //                                                     borderRadius: BorderRadius.circular(10), // Rounded corners
          //                                                     boxShadow: [
          //                                                       BoxShadow(
          //                                                         color: Colors.black.withOpacity(0.1), // Shadow color
          //                                                         blurRadius: 10,
          //                                                         spreadRadius: 2,
          //                                                         offset: Offset(0, 5), // Shadow position
          //                                                       ),
          //                                                     ],
          //                                                   ),
          //                                                   child: Container(
          //                                                     decoration: BoxDecoration(
          //                                                       color: Color(0xFF96b2e1), // Hex color #d5e6fa
          //                                                       borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
          //                                                     ),
          //                                                     margin: EdgeInsets.all(5),
          //                                                     child: Row(
          //                                                       mainAxisAlignment: MainAxisAlignment.end,
          //                                                       crossAxisAlignment: CrossAxisAlignment.end,
          //                                                       children: [
          //                                                         const Icon(Icons.calendar_month,size: 20),
          //                                                         SizedBox(width: 5),
          //                                                         Text(emergencyTitleList![index]['TaxNoOfYears'],
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularWhiteTextStyle,
          //
          //                                                         )
          //                                                       ],
          //                                                     ),
          //                                                   ),
          //
          //                                                 ),
          //                                               )
          //                                             ],
          //                                           ),
          //                                         ),
          //                                         SizedBox(height: 10),
          //                                         Row(
          //                                           crossAxisAlignment: CrossAxisAlignment.center,
          //                                           // Align items vertically
          //                                           children: <Widget>[
          //                                             CircleWithSpacing(),
          //                                             // Space between the circle and text
          //                                             Text(
          //                                               'Property Details :',
          //                                               style: AppTextStyle
          //                                                   .font14OpenSansRegularGreenTextStyle,
          //                                             ),
          //                                           ],
          //                                         ),
          //                                         SizedBox(height: 10),
          //                                         Padding(
          //                                           padding: const EdgeInsets.only(),
          //                                           child: Container(
          //                                             height: 70,
          //                                             decoration: BoxDecoration(
          //                                               color:Colors.black12,
          //                                               // color: Color(0xf6f6f6), // Hex color #d5e6fa
          //                                               borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
          //                                             ),
          //                                             child:Row(
          //                                               children: [
          //                                                 Padding(
          //                                                   padding: EdgeInsets.only(top: 15,left: 10),
          //                                                   child: Center(
          //                                                     child: Column(
          //                                                       mainAxisAlignment: MainAxisAlignment.start,
          //                                                       crossAxisAlignment: CrossAxisAlignment.start,
          //                                                       children: [
          //                                                         Text("Owner Name",
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularBlackTextStyle,
          //                                                         ),
          //                                                         SizedBox(height: 5),
          //                                                         Text(emergencyTitleList![index]['sHouseOwnerName'],
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularBlack45TextStyle,
          //                                                         ),
          //                                                       ],
          //                                                     ),
          //
          //                                                   ),
          //                                                 ),
          //                                                 Spacer(),
          //                                                 Padding(
          //                                                   padding: EdgeInsets.only(right: 10),
          //                                                   child: Column(
          //                                                     mainAxisAlignment: MainAxisAlignment.end,
          //                                                     crossAxisAlignment: CrossAxisAlignment.end,
          //                                                     children: [
          //                                                       Center(
          //                                                         child: Text("Ward",
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularBlackTextStyle,
          //                                                         ),
          //                                                       ),
          //                                                       SizedBox(height: 5),
          //                                                       Center(
          //                                                         child: Text(emergencyTitleList![index]['sWardName'],
          //                                                           style: const TextStyle(
          //                                                               color: Colors.black54,
          //                                                               fontSize: 14
          //                                                           ),),
          //                                                       ),
          //                                                     ],
          //                                                   ),
          //                                                 )
          //                                               ],
          //
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         SizedBox(height: 5),
          //                                         Padding(
          //                                           padding: const EdgeInsets.only(),
          //                                           child: Container(
          //                                             height: 70,
          //                                             decoration: BoxDecoration(
          //                                               color:Colors.black12,
          //                                               //color: Color(0xf6f6f6), // Hex color #d5e6fa
          //                                               borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
          //                                             ),
          //                                             child:Row(
          //                                               children: [
          //                                                 Padding(
          //                                                   padding: EdgeInsets.only(top: 15,left: 10),
          //                                                   child: Center(
          //                                                     child: Column(
          //                                                       mainAxisAlignment: MainAxisAlignment.start,
          //                                                       crossAxisAlignment: CrossAxisAlignment.start,
          //                                                       children: [
          //                                                         Text("House Area",
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularBlackTextStyle,
          //                                                         ),
          //                                                         SizedBox(height: 5),
          //                                                         Text(emergencyTitleList![index]['fSeqFeet'],
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularBlack45TextStyle,
          //                                                         ),
          //                                                       ],
          //                                                     ),
          //
          //                                                   ),
          //                                                 ),
          //                                                 Spacer(),
          //                                                 Padding(
          //                                                   padding: EdgeInsets.only(right: 10),
          //                                                   child: Column(
          //                                                     mainAxisAlignment: MainAxisAlignment.end,
          //                                                     crossAxisAlignment: CrossAxisAlignment.end,
          //                                                     children: [
          //                                                       Center(
          //                                                         child: Text("Amount",
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularBlackTextStyle,
          //                                                         ),
          //                                                       ),
          //                                                       SizedBox(height: 5),
          //                                                       Center(
          //                                                         child: Text('₹ ${emergencyTitleList![index]['fAmount'].toString()}',
          //                                                           style: AppTextStyle
          //                                                               .font14OpenSansRegularBlack45TextStyle,
          //                                                         ),
          //                                                       ),
          //                                                     ],
          //                                                   ),
          //                                                 )
          //                                               ],
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         SizedBox(height: 5),
          //
          //                                       ],
          //                                     )
          //                                 ),
          //                               )
          //                             ],
          //                           );
          //                         }
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //
          //             ),
          //             // position
          //             Positioned(
          //               bottom: 8, // Adjust position as needed
          //               right: 10, // Adjust position as needed
          //               child: InkWell(
          //                 onTap: ()async{
          //                   // to get a contact no from a local dataBase
          //                   var encodedHouseNo = Uri.encodeComponent(houseNo.toString());
          //                   print("---582--: $encodedHouseNo");
          //
          //                   SharedPreferences prefs = await SharedPreferences.getInstance();
          //                   String? sContactNo = prefs.getString('sContactNo');
          //
          //
          //                   var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
          //                   print("----586---$iWardCode");
          //                   print("----587---$houseNo");
          //                   // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
          //                   // var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
          //                   //  https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=1(11)&ward=3
          //
          //                   // var baseurl = "https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=$houseNo&ward=$iWardCode";
          //                   //var user ="8755553370";
          //                   // var baseurl = "https://www.diusmartcity.com/User/PropertyPayment.aspx?id=$houseNo&ward=$iWardCode&user=$sContactNo";
          //
          //                   var baseurl = "https://www.diusmartcity.com/User/PropertyPayment.aspx?id=$encodedHouseNo&ward=$iWardCode&user=$sContactNo";
          //
          //                   var sPageName = "Property Tax";
          //                   print("--baseUrl : $baseurl");
          //
          //                   // close the DialogBox
          //                   if(baseurl!=null && baseurl!=""){
          //                     print("------600---: $baseurl");
          //
          //                     Navigator.push(
          //                       context,
          //                       MaterialPageRoute(builder: (context) =>
          //                           AboutDiuPage(name: sPageName, sPageLink: baseurl)),
          //                     );
          //
          //                   }else{
          //                     print("----596---baseUrl : $baseurl");
          //                   }
          //
          //                 },
          //
          //                 child: Container(
          //                   height: 50,
          //                   width: 50,
          //                   decoration: const BoxDecoration(
          //                     image: DecorationImage(
          //                       image: AssetImage("assets/images/Pay-Now-01.png"), // Change path
          //                       fit: BoxFit.fill,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),


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
                      // var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
                      //  https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=1(11)&ward=3
                      var baseurl = "https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=$houseNo&ward=$iWardCode";
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
                      //  var baseurl = "https://www.diusmartcity.com/User/PaymentCommunityHall.aspx?id=";
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






// class PropertyTaxDiu extends StatefulWidget {
//
//   final name;
//   const PropertyTaxDiu({super.key, required this.name});
//
//   @override
//   State<PropertyTaxDiu> createState() => _PropertyTaxState();
// }
//
// class _PropertyTaxState extends State<PropertyTaxDiu> {
//
//   GeneralFunction generalFunction = GeneralFunction();
//   List<dynamic> wardList = [];
//   var _dropDownWard;
//
//   //
//   TextEditingController _houseController = TextEditingController();
//   TextEditingController _houseOwnerName = TextEditingController();
//
//   FocusNode _housefocus = FocusNode();
//   FocusNode _houseOwnerfocus = FocusNode();
//   //
//   List<Map<String,dynamic>>? emergencyTitleList;
//   //List<Map<String,dynamic>>? emergencyTitleList2;
//   bool isLoading = true; // logic
//   //String? sName, sContactNo;
//   var houseNo;
//
//   final List<Color> borderColors = [
//     Colors.red,
//     Colors.blue,
//     Colors.green,
//     Colors.orange,
//     Colors.purple,
//     Colors.pink,
//     Colors.teal,
//     Colors.brown,
//     Colors.cyan,
//     Colors.amber,
//   ];
//   // GeneralFunction generalFunction = GeneralFunction();
//
//   getEmergencyTitleResponse(selectedWardId, String houseno, String houseOwnerName) async {
//    // final List<dynamic> list = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
//     emergencyTitleList = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
//     print('------57-----xxxx---xx----$emergencyTitleList');
//     if(emergencyTitleList==null || emergencyTitleList!.isEmpty){
//
//       displayToast('Note: Please submit the property assessment request details and proceed.');
//
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//   // online title
//   var OnlineTitle = ["Property Tax",
//     "Building Plan",
//     "Property Assessment",
//     "License",
//     "Community Hall",
//     "Water Supply",
//     "Electricity Bill",
//     "Mamlatdar Diu"
//   ];
//
//
//   var _selectedWardId;
//   // dropDown
//   bindWard() async {
//     wardList = await BindCityzenWardRepo().getbindWard(context);
//     setState(() {});
//   }
//   // bind
//   Widget _bindWard() {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10.0),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10, right: 10),
//         child: Container(
//           width: MediaQuery.of(context).size.width - 20,
//           height: 42,
//           color: Color(0xFF255898), // Background color
//           child: DropdownButtonHideUnderline(
//             child: ButtonTheme(
//               alignedDropdown: true,
//               child: DropdownButton(
//                 isDense: true, // Reduces the vertical size of the button
//                 isExpanded: true, // Allows the DropdownButton to take full width
//                 dropdownColor: Colors.grey, // Set dropdown list background color
//                 iconEnabledColor: Colors.white, // Icon color (keeps the icon white)
//                 hint: RichText(
//                   text: TextSpan(
//                     text: "Select Ward",
//                     style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
//                   ),
//                 ),
//                 value: _dropDownWard,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _dropDownWard = newValue;
//                     wardList.forEach((element) {
//                       if (element["sWardName"] == _dropDownWard) {
//                         _selectedWardId = element['sWardCode'];
//                       }
//                     });
//                   });
//                 },
//                 style: TextStyle(color: Colors.white), // Selected item text color
//                 items: wardList.map((dynamic item) {
//                   return DropdownMenuItem(
//                     value: item["sWardName"].toString(),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             item['sWardName'].toString(),
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(color: Colors.white), // Dropdown menu item text color
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     bindWard();
//     _housefocus = FocusNode();
//     super.initState();
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _housefocus.dispose();
//     _houseController.dispose();
//     _houseOwnerfocus.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//        // appBar: getAppBarBack(context,'${widget.name}'),
//         appBar: AppBar(
//           // statusBarColore
//           systemOverlayStyle: const SystemUiOverlayStyle(
//             statusBarColor: Color(0xFF12375e),
//             statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
//             statusBarBrightness: Brightness.light, // For iOS (dark icons)
//           ),
//           // backgroundColor: Colors.blu
//           centerTitle: true,
//           backgroundColor: Color(0xFF255898),
//           leading: GestureDetector(
//             onTap: (){
//               print("------back---");
//               Navigator.pop(context);
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
//               // );
//             },
//             child: const Icon(Icons.arrow_back_ios,
//               color: Colors.white,),
//           ),
//           title: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 5),
//             child: Text(
//               '${widget.name}',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.normal,
//                 fontFamily: 'Montserrat',
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           //centerTitle: true,
//           elevation: 0, // Removes shadow under the AppBar
//         ),
//            body: Column(
//             children: [
//               SizedBox(height: 5),
//               _bindWard(),
//               SizedBox(height: 10),
//               // EditText
//               Padding(
//                 padding:
//                 const EdgeInsets.only(left: 10, right: 10),
//                 child: Container(
//                   height: 55,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 0),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             focusNode: _housefocus, // Focus node for the text field
//                             controller: _houseController, // Controller to manage the text field's value
//                             textInputAction: TextInputAction.next, // Set action for the keyboard
//                             onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(), // Add a border around the text field
//                               contentPadding: EdgeInsets.symmetric(
//                                 vertical: 10.0,
//                                 horizontal: 10.0,
//                               ), // Adjust padding inside the text field
//                               filled: true, // Enable background color for the text field
//                               fillColor: Color(0xFFf2f3f5), // Set background color
//                               hintText: "House No", // Placeholder text when field is empty
//                               hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
//                             ),
//                             autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
//                           )
//
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                  child: Text("or",
//                      style: AppTextStyle.font16OpenSansRegularBlack45TextStyle
//                  ),
//              ),
//               SizedBox(height: 5),
//               Padding(
//                 padding:
//                 const EdgeInsets.only(left: 10, right: 10),
//                 child: Container(
//                   height: 55,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 0),
//                     child: Column(
//                       children: [
//                         Expanded(
//                             child: TextFormField(
//                               focusNode: _houseOwnerfocus, // Focus node for the text field
//                               controller: _houseOwnerName, // Controller to manage the text field's value
//                               textInputAction: TextInputAction.next, // Set action for the keyboard
//                               onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(), // Add a border around the text field
//                                 contentPadding: EdgeInsets.symmetric(
//                                   vertical: 10.0,
//                                   horizontal: 10.0,
//                                 ), // Adjust padding inside the text field
//                                 filled: true, // Enable background color for the text field
//                                 fillColor: Color(0xFFf2f3f5), // Set background color
//                                 hintText: "House Owner Name", // Placeholder text when field is empty
//                                 hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
//                               ),
//                               autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
//                             )
//
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Your onTap logic here
//
//                     var houseno = _houseController.text.trim();
//                     var houseOwnerName = _houseOwnerName.text.trim();
//                     if(_selectedWardId!=null && _selectedWardId!="" && houseno.isNotEmpty || houseOwnerName.isNotEmpty){
//                        print("---Call APi---");
//                        getEmergencyTitleResponse(_selectedWardId,houseno,houseOwnerName);
//                     }else{
//                       print("---Not Call APi---");
//                       displayToast("Please enter the required details.");
//                     }
//                     // getEmergencyTitleResponse();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF255898), // Background color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppPadding.p20, // Horizontal padding for spacing
//                       vertical: AppPadding.p10,   // Vertical padding for height
//                     ),
//                     elevation: 2, // Add slight elevation for the button
//                   ),
//                   child: Text(
//                     "SEARCH",
//                     style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 5),
//
//               isLoading
//                   ? buildShimmerList()
//                   : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
//                   ? NoDataScreenPage()
//                   :
//                   Expanded(
//                     child: Stack(
//                       children: <Widget>[
//                         Container(
//                           //height: MediaQuery.of(context).size.height * 0.8,
//                           child: Column(
//                             children: [
//                               Expanded(
//                                 child: ListView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: emergencyTitleList?.length ?? 0,
//                                     // itemCount: OnlineTitle?.length ?? 0,
//                                     itemBuilder: (context, index) {
//                                       final color = borderColors[index % borderColors.length];
//                                       houseNo = "${emergencyTitleList![index]['sHouseNo']}";
//
//                                       return Column(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 10,right: 10),
//                                             child: Container(
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                       height: 70,
//                                                       decoration: BoxDecoration(
//                                                         color: Color(0xFFD5E6FA), // Hex color #d5e6fa
//                                                         borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
//                                                       ),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.start,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 5),
//                                                             child: Center(
//                                                               child: Container(
//                                                                 width: 50, // Width of the container
//                                                                 height: 50, // Height of the container
//                                                                 decoration: const BoxDecoration(
//                                                                   color: Colors.grey, // Gray background
//                                                                   shape: BoxShape.circle, // Circular shape
//                                                                 ),
//                                                                 child: Container(
//                                                                     width: 35,
//                                                                     height: 35,
//                                                                     decoration: BoxDecoration(
//                                                                       color: color, // Set the dynamic color
//                                                                       borderRadius: BorderRadius.circular(5),
//                                                                     ),
//                                                                     child: const Icon(Icons.ac_unit,
//                                                                       color: Colors.white,
//                                                                     )
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 10),
//                                                           Padding(
//                                                             padding: EdgeInsets.only(top: 15),
//                                                             child: Center(
//                                                               child: Column(
//                                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                 children: [
//                                                                   Text(emergencyTitleList![index]['sHouseNo'],
//                                                                     style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
//                                                                   ),
//                                                                   SizedBox(height: 5),
//                                                                   Text("House No",
//                                                                     style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
//                                                                   ),
//
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Spacer(),
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(right: 0,top: 10),
//                                                             child: Container(
//                                                               margin: EdgeInsets.all(16),
//                                                               // color: Colors.black54,
//                                                               decoration: BoxDecoration(
//                                                                 color: Color(0xFF96b2e1), // Background color
//                                                                 borderRadius: BorderRadius.circular(10), // Rounded corners
//                                                                 boxShadow: [
//                                                                   BoxShadow(
//                                                                     color: Colors.black.withOpacity(0.1), // Shadow color
//                                                                     blurRadius: 10,
//                                                                     spreadRadius: 2,
//                                                                     offset: Offset(0, 5), // Shadow position
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               child: Container(
//                                                                 decoration: BoxDecoration(
//                                                                   color: Color(0xFF96b2e1), // Hex color #d5e6fa
//                                                                   borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
//                                                                 ),
//                                                                 margin: EdgeInsets.all(5),
//                                                                 child: Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                                                   children: [
//                                                                     const Icon(Icons.calendar_month,size: 20),
//                                                                     SizedBox(width: 5),
//                                                                     Text(emergencyTitleList![index]['TaxNoOfYears'],
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularWhiteTextStyle,
//
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               ),
//
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 10),
//                                                     Row(
//                                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                                       // Align items vertically
//                                                       children: <Widget>[
//                                                         CircleWithSpacing(),
//                                                         // Space between the circle and text
//                                                         Text(
//                                                           'Property Details :',
//                                                           style: AppTextStyle
//                                                               .font14OpenSansRegularGreenTextStyle,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 10),
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(),
//                                                       child: Container(
//                                                         height: 70,
//                                                         decoration: BoxDecoration(
//                                                           color:Colors.black12,
//                                                           // color: Color(0xf6f6f6), // Hex color #d5e6fa
//                                                           borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
//                                                         ),
//                                                         child:Row(
//                                                           children: [
//                                                             Padding(
//                                                               padding: EdgeInsets.only(top: 15,left: 10),
//                                                               child: Center(
//                                                                 child: Column(
//                                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                                   children: [
//                                                                     Text("Owner Name",
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularBlackTextStyle,
//                                                                     ),
//                                                                     SizedBox(height: 5),
//                                                                     Text(emergencyTitleList![index]['sHouseOwnerName'],
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularBlack45TextStyle,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//
//                                                               ),
//                                                             ),
//                                                             Spacer(),
//                                                             Padding(
//                                                               padding: EdgeInsets.only(right: 10),
//                                                               child: Column(
//                                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                                                 children: [
//                                                                   Center(
//                                                                     child: Text("Ward",
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularBlackTextStyle,
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(height: 5),
//                                                                   Center(
//                                                                     child: Text(emergencyTitleList![index]['sWardName'],
//                                                                       style: const TextStyle(
//                                                                           color: Colors.black54,
//                                                                           fontSize: 14
//                                                                       ),),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             )
//                                                           ],
//
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 5),
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(),
//                                                       child: Container(
//                                                         height: 70,
//                                                         decoration: BoxDecoration(
//                                                           color:Colors.black12,
//                                                           //color: Color(0xf6f6f6), // Hex color #d5e6fa
//                                                           borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
//                                                         ),
//                                                         child:Row(
//                                                           children: [
//                                                             Padding(
//                                                               padding: EdgeInsets.only(top: 15,left: 10),
//                                                               child: Center(
//                                                                 child: Column(
//                                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                                   children: [
//                                                                     Text("House Area",
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularBlackTextStyle,
//                                                                     ),
//                                                                     SizedBox(height: 5),
//                                                                     Text(emergencyTitleList![index]['fSeqFeet'],
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularBlack45TextStyle,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//
//                                                               ),
//                                                             ),
//                                                             Spacer(),
//                                                             Padding(
//                                                               padding: EdgeInsets.only(right: 10),
//                                                               child: Column(
//                                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                                                 children: [
//                                                                   Center(
//                                                                     child: Text("Amount",
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularBlackTextStyle,
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(height: 5),
//                                                                   Center(
//                                                                     child: Text('₹ ${emergencyTitleList![index]['fAmount'].toString()}',
//                                                                       style: AppTextStyle
//                                                                           .font14OpenSansRegularBlack45TextStyle,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 5),
//
//                                                   ],
//                                                 )
//                                             ),
//                                           )
//                                         ],
//                                       );
//                                     }
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                         ),
//                         // position
//                         Positioned(
//                           bottom: 8, // Adjust position as needed
//                           right: 10, // Adjust position as needed
//                           child: InkWell(
//                             onTap: ()async{
//                               // to get a contact no from a local dataBase
//                               var encodedHouseNo = Uri.encodeComponent(houseNo.toString());
//                               print("---582--: $encodedHouseNo");
//
//                               SharedPreferences prefs = await SharedPreferences.getInstance();
//                               String? sContactNo = prefs.getString('sContactNo');
//
//
//                               var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
//                                 print("----586---$iWardCode");
//                                 print("----587---$houseNo");
//                               // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
//                               // var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
//                               //  https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=1(11)&ward=3
//
//                              // var baseurl = "https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=$houseNo&ward=$iWardCode";
//                               //var user ="8755553370";
//                              // var baseurl = "https://www.diusmartcity.com/User/PropertyPayment.aspx?id=$houseNo&ward=$iWardCode&user=$sContactNo";
//
//                               var baseurl = "https://www.diusmartcity.com/User/PropertyPayment.aspx?id=$encodedHouseNo&ward=$iWardCode&user=$sContactNo";
//
//                               var sPageName = "Property Tax";
//                               print("--baseUrl : $baseurl");
//
//                               // close the DialogBox
//                              if(baseurl!=null && baseurl!=""){
//                                print("------600---: $baseurl");
//
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) =>
//                                      AboutDiuPage(name: sPageName, sPageLink: baseurl)),
//                                );
//
//                              }else{
//                                print("----596---baseUrl : $baseurl");
//                              }
//
//                              },
//
//                             child: Container(
//                               height: 50,
//                               width: 50,
//                                 decoration: const BoxDecoration(
//                                   image: DecorationImage(
//                                     image: AssetImage("assets/images/Pay-Now-01.png"), // Change path
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//             ],
//           ),
//
//
//       )
//       );
//
//   }
//   // paymentDialog widget
//   Widget paymentDialog(BuildContext dialogContext){
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // 🔶 Gradient Header
//           Container(
//             height: 45,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFFF15C3B), // First color: #ff5e62 (a warm coral)
//                   Color(0xFF005BAC), // Second color: #005BAC (a deep blue)
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   child: Text(
//                     'Choose Payment Gateway',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//                 IconButton(
//                     icon: Icon(Icons.close, color: Colors.white),
//                     onPressed: () {
//                       if (Navigator.of(dialogContext).canPop()) {
//                         Navigator.of(dialogContext).pop();
//                       }
//                     }
//                 ),
//               ],
//             ),
//           ),
//           // 💳 Payment Options
//           Container(
//             height: 100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // First Card
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
//                       // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
//                      // var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
//                      //  https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=1(11)&ward=3
//                       var baseurl = "https://www.diusmartcity.com/root/User/PropertyPayment.aspx?id=$houseNo&ward=$iWardCode";
//                       var sPageName = "Property Tax";
//
//                       // close the DialogBox
//                       if (Navigator.of(dialogContext).canPop()) {
//                         Navigator.of(dialogContext).pop();
//                       }
//
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) =>
//                             AboutDiuPage(name: sPageName, sPageLink: baseurl)),
//                       );
//                     },
//                     child: Card(
//                       elevation: 10,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/images/bankborda.png',
//                               height: 30,
//                             ),
//                             SizedBox(width: 10),
//                             const Text(
//                               'BOB',
//                               style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(width: 12),
//
//                 // Second Card
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//
//                       var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
//                       // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
//                       // var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
//                       var baseurl = "https://www.diusmartcity.com/SBIPropertyTaxDataformGetewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
//                     //  var baseurl = "https://www.diusmartcity.com/User/PaymentCommunityHall.aspx?id=";
//                       var sPageName = "Property Tax";
//                       print('-----baseURL--$baseurl');
//                       // close the dialogbOS
//
//                       if (Navigator.of(dialogContext).canPop()) {
//                         Navigator.of(dialogContext).pop();
//                       }
//
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) =>
//                             AboutDiuPage(name: sPageName, sPageLink: baseurl)),
//                       );
//                     },
//                     child: Card(
//                       elevation: 10,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/images/banksbi.png',
//                               height: 30,
//                             ),
//                             SizedBox(width: 10),
//                             const Text(
//                               'SBI',
//                               style: TextStyle(
//                                 color: Colors.black54,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
// }
