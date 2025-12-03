import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:puri/presentation/onlineService/propertyAssessment/property_assessementImages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/generalFunction.dart';
import '../../../services/communityHallBookingCancel.dart';
import '../../../services/propertyAssessementPropertyRepo.dart';
import '../../aboutDiu/Aboutdiupage.dart';
import '../../circle/circle.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';
import 'package:dotted_border/dotted_border.dart';


class PropertyAssessmentStatus extends StatefulWidget {
  final name;
  PropertyAssessmentStatus({super.key, this.name});

  @override
  State<PropertyAssessmentStatus> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<PropertyAssessmentStatus> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>> _filteredData = [];

  TextEditingController _searchController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  var FinalApprovedStatus;
  var result, msg;
  GeneralFunction generalfunction = GeneralFunction();
  bool isLoading = true;
  var iStatus;
  var iPaymenyDone;
  var sBookingReqId;

  // Api response

  pendingInternalComplaintResponse() async {
    pendingInternalComplaintList =
    await PropertyAssessementPropertyRepo().assessementProperty(context);
    print('-----65-----xxx-----$pendingInternalComplaintList');
    _filteredData =
    List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      isLoading = false;
    });
  }

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
                      var sPageName = "Community Hall Status";
                      // Payment URL
                      // var baseurl = "https://www.diusmartcity.com/CommunityHallPaymentGatewayMobile.aspx?QS=";
                      var baseurl = "https://www.diusmartcity.com/root/User/PaymentCommunityHall.aspx?id=";

                      var paymentUrl = "$baseurl$sBookingReqId";
                      print(paymentUrl);

                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutDiuPage(name: sPageName, sPageLink: paymentUrl),
                        ),
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
                      var sPageName = "Community Hall Status";
                      // Payment URL
                      /// TODO HERE YOU SHOUL CHNAGE THE PATH

                      var baseurl = "https://www.diusmartcity.com/SBICommunityHallDataFormGatewayMobile.aspx?QS=";

                      var paymentUrl = "$baseurl$sBookingReqId";
                      print(paymentUrl);

                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AboutDiuPage(name: sPageName, sPageLink: paymentUrl)),
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
  @override
  void initState() {
    // TODO: implement initState
    pendingInternalComplaintResponse();
    _searchController.addListener(_search);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // remarks call api
  void validateAndCallRemarksApi(String bookingRequestId) async {
    // Get shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sContactNo = prefs.getString('sContactNo');
    // Trim remarks input
    String sCancelRemarks = _remarksController.text.trim();

    // Validate remarks field
    if (sCancelRemarks.isEmpty) {
      displayToast('Please enter Remarks');
      return; // Stop execution if validation fails
    }

    print('---Calling API---');
    print("---Booking Request ID: $bookingRequestId");

    // Call API
    var communityHallBookingResponse = await CommunityHallBookingCancel()
        .communityHallBooking(
        context, bookingRequestId, sCancelRemarks, sContactNo);

    print('---API Response: $communityHallBookingResponse');

    // Clear remarks field
    _remarksController.clear();

    // Check if API response is valid
    if (communityHallBookingResponse != null) {
      //call the main page api
      String? result = communityHallBookingResponse['Result'];
      msg = communityHallBookingResponse['Msg'];
      setState(() {
        pendingInternalComplaintResponse();
      });

      if (result == "1") {
        // call main Page api again

        // Success case - Show toast and close bottom sheet
        displayToast(msg);
        Navigator.pop(context);
        print("----Cancel request Successful---");
      } else {
        // Failure case - Show toast but don't close bottom sheet
        displayToast(msg);
        print("----Cancel request Failed---");
      }
    } else {
      displayToast("Something went wrong. Please try again.");
      print("--- API Response is null ---");
    }
  }

  void _search() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = pendingInternalComplaintList?.where((item) {
        String location = item['sHouseHoldRequestId'].toLowerCase();
        String pointType = item['sHouseAddress'].toLowerCase();
        String sector = item['sMobileNo'].toLowerCase();
        return location.contains(query) ||
            pointType.contains(query) ||
            sector.contains(query);
      }).toList() ??
          [];
    });
  }

  // location
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;
    setState(() {});
  }

  // open Pdf
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Unfocus any focused widget
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context, '${widget.name}'),

        drawer:
        generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body:
        isLoading
            ? buildShimmerList()
            : (pendingInternalComplaintList == null ||
            pendingInternalComplaintList!.isEmpty)
            ? NoDataScreenPage()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Padding(
                padding:
                EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey, // Outline border color
                      width: 0.2, // Outline border width
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Enter Keywords',
                            hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xFF707d83),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // scroll item after search bar
            Expanded(
              child: ListView.builder(
                itemCount: _filteredData.length ?? 0,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = _filteredData[index];

                  iStatus = item['iStatus'];
                  iPaymenyDone = item['iPaymentDone'];
                  sBookingReqId =  item['sBookingReqId'];
                  FinalApprovedStatus = item['FinalApprovedStatus'];
                   var status = item['sReqStatus'];

                   return Padding(
                    padding: const EdgeInsets.only(
                        left: 8, top: 8, right: 8),
                    child: Container(
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            shadowColor: Colors.white,
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  //top header
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        // Adjust the radius as needed
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors
                                              .grey, // Border color
                                          width:
                                          1, // Border width
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5.0),
                                                // Adjust the radius as needed
                                                color: const Color(
                                                    0xFFF5F5F5),
                                              ),
                                              child: ListTile(
                                                leading:
                                                Container(
                                                  // color: Colors.blueGrey,
                                                  width: 35,
                                                  height: 35,
                                                  // Height and width must be equal to make it circular
                                                  decoration:
                                                  const BoxDecoration(
                                                    // color: Colors.orange,
                                                    shape: BoxShape
                                                        .circle,
                                                  ),
                                                  child: Center(
                                                    child: Image
                                                        .asset(
                                                      'assets/images/home12.jpeg',
                                                      height: 25,
                                                      width: 25,
                                                      fit: BoxFit
                                                          .cover,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                    item['sHouseOwnerName'] ??
                                                        '',
                                                    style: AppTextStyle
                                                        .font14penSansExtraboldBlack45TextStyle),
                                              )),
                                          Positioned(
                                            top: 10,
                                            right: 15,
                                            child:
                                            GestureDetector(
                                              onTap: () {
                                                var HouseHoldrequestId = item['sHouseHoldRequestId'] ?? '';

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PropertyAssessementImages(licenseRequestId: HouseHoldrequestId)),
                                                  );

                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                // Height and width must be equal to make it circular
                                                decoration:
                                                const BoxDecoration(
                                                  color: Colors
                                                      .white,
                                                  shape: BoxShape
                                                      .circle,
                                                  // Makes the container circular
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors
                                                          .black26,
                                                      blurRadius:
                                                      5,
                                                      offset:
                                                      Offset(
                                                          0,
                                                          2),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child:
                                                  Image.asset(
                                                    'assets/images/picture.png',
                                                    height: 25,
                                                    width: 25,
                                                    fit: BoxFit
                                                        .fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('House Hold Request Id',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 24),
                                    child: Text(
                                        item['sHouseHoldRequestId'] ??
                                            '',
                                        style: AppTextStyle
                                            .font14OpenSansRegularRedTextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('House No',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 24),
                                    child: Text(
                                        item['sHouseNo'] ??
                                            '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  // mobileNo
                                  //  moile end ---.
                                  Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                    Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           mainAxisAlignment:
                                           MainAxisAlignment.start,
                                           children: <Widget>[
                                             SizedBox(width: 5),
                                             CircleWithSpacing(),
                                             Text('Mobile No',
                                                 style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                           ],
                                         ),
                                         Padding(
                                           padding:
                                           const EdgeInsets.only(left: 24),
                                           child: Text(item['sMobileNo'] ?? '',
                                               style: AppTextStyle
                                                   .font14penSansExtraboldBlack26TextStyle),
                                         ),
                                       ],
                                     ),
                                    Expanded(
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: DottedBorder(
                                    color: Colors.grey,               // Border color
                                    strokeWidth: 1,                   // Border thickness
                                    dashPattern: [6, 3],              // 6px dash, 3px gap
                                    borderType: BorderType.RRect,     // Rounded rectangle
                                    radius: const Radius.circular(8), // Rounded corners
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // 10dp padding
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,  // Wrap content width
                                        children: [
                                          const Text(
                                            'Property Type',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            item['sPropertyType'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.black,
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
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Total Carpet Area',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 24),
                                    child: Text(
                                        item['fTotalCarpetArea'].toString(),
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Applied On',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 24),
                                    child: Text(
                                        item['dAppliedOn']
                                            .toString() ??
                                            '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Address',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 24),
                                    child: Text(
                                        item['sHouseAddress']
                                            .toString(),
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  // status row cancel and Pay Now
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(width: 5),
                                              CircleWithSpacing(),
                                              Text('Status',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularBlack45TextStyle),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left: 24),
                                            child: Text(
                                                item['sReqStatus'] ?? '',
                                                style: AppTextStyle
                                                    .font14OpenSansRegularRedTextStyle),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Visibility(
                                      visible: (FinalApprovedStatus == "1"),
                                      child: InkWell(
                                        onTap: () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          String? sContactNo = prefs.getString('sContactNo');
                                          var houseNo = item['sHouseNo'] ?? '';
                                          var encodedHouseNo = Uri.encodeComponent(houseNo.toString());
                                          var iWardCode = item['iWardCode'] ?? '';
                                          var sPageName = "Community Hall Status";

                                          var baseurl = "https://www.diusmartcity.com/User/PropertyPayment.aspx?id=$encodedHouseNo&ward=$iWardCode&user=$sContactNo";

                                          if (baseurl.isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AboutDiuPage(name: sPageName, sPageLink: baseurl),
                                              ),
                                            );
                                          } else {
                                            print("----Payment url : $baseurl");
                                          }
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Pay Now",
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  if(status!="Pending")
                                  Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        color: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 10), // Optional padding
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // First Part
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 4,
                                                    color: Colors.red, // First part color
                                                  ),
                                                  const SizedBox(width: 5),
                                                   Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Action By",
                                                        //style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold
                                                       style: AppTextStyle.font14OpenSansRegularBlack45TextStyle
                                                        ),

                                                      Text(
                                                          item['sApprovedBy'] ?? '',
                                                        style: AppTextStyle.font14OpenSansRegularBlack26TextStyle
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10), // Gap between two parts
                                            // Second Part
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 4,
                                                    color: Colors.green, // Second part color
                                                  ),
                                                  const SizedBox(width: 5),
                                                   Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Action At",
                                                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                      ),
                                                      Text(
                                                        item['dApprovedOn'] ?? '',
                                                          style: AppTextStyle.font14OpenSansRegularBlack26TextStyle
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                      Container(
                        height: 60,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10), // Optional padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // First Part
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 4,
                                    color: Colors.green, // First part color
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded( // ✅ Wrap Column inside Expanded
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Remarks",
                                          style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                        ),
                                        Text(
                                          item['sRemark'] ?? '',
                                          style: AppTextStyle.font14OpenSansRegularBlack26TextStyle,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Second Part (Optional - Add something here if needed)
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Record Found',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
