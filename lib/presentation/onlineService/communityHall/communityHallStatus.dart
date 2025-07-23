import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:puri/presentation/complaints/grievanceStatus/searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/generalFunction.dart';
import '../../../services/CommunityHallStatusRepo.dart';
import '../../../services/citizenMyPostedComplaint.dart';
import '../../../services/communityHallBookingCancel.dart';
import '../../../services/feedbackRepo.dart';
import '../../aboutDiu/Aboutdiupage.dart';
import '../../circle/circle.dart';
import '../../complaints/complaintHomePage.dart';
import '../../fullscreen/imageDisplay.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';
import '../../resources/assets_manager.dart';
import '../../resources/values_manager.dart';
import '../license/licenseStatus/licenseStatusImages.dart';

class CommunityHallStatus extends StatefulWidget {
  final name;

  CommunityHallStatus({super.key, this.name});

  @override
  State<CommunityHallStatus> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<CommunityHallStatus> {

  GeneralFunction generalFunction = GeneralFunction();

  var variableName;
  var variableName2;
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>> _filteredData = [];
  List bindAjencyList = [];
  List userAjencyList = [];
  var iAgencyCode;
  var agencyUserId;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  double? lat;
  double? long;
  var _dropDownAgency2;
  var _dropDownValueUserAgency;
  final distDropdownFocus = GlobalKey();
  var result, msg;
  var userAjencyData;
  var result1;
  var msg1;
  GeneralFunction generalfunction = GeneralFunction();
  bool isLoading = true;
  var communityHallBookingResponse;
  var iStatus;
  var iPaymenyDone;
  var iStatus2=1;
  var iPaymenyDone2=1;
  var sBookingReqId;

  // Api response

  pendingInternalComplaintResponse() async {
    pendingInternalComplaintList =
        await CommunityHallStatusRepo().communityHall(context);
    print('-----68-----xxx-----$pendingInternalComplaintList');
    _filteredData =
        List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      // parkList=[];
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
                      var baseurl = "https://www.diusmartcity.com/CommunityHallPaymentGatewayMobile.aspx?QS=";
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
            String location = item['sBookingReqId'].toLowerCase();
            String pointType = item['sApplicantName'].toLowerCase();
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

  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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
        // appBar: getAppBarBack(context,'jjsjsjsj'),
        drawer:
            generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body:
            // pendingInternalComplaintList == null
            //   ? NoDataScreen()
            //   :
            isLoading
                ? Center(child: Container())
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
                                                              color: Color(
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
                                                                  item['sCommunityHallName'] ??
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
                                                              var docUrl = "${item['sCommunityDocUrl'].toString()}";

                                                              print(docUrl);

                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        FullScreenImages(
                                                                            image:
                                                                                docUrl)),
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
                                                    Text('Booking Request Id',
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24),
                                                  child: Text(
                                                      item['sBookingReqId'] ??
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
                                                    Text('Applicant Name',
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24),
                                                  child: Text(
                                                      item['sApplicantName'] ??
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
                                                    Text('Mobile No',
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24),
                                                  child: Text(
                                                      item['sMobileNo'] ?? '',
                                                      style: AppTextStyle
                                                          .font14penSansExtraboldBlack26TextStyle),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 5),
                                                    CircleWithSpacing(),
                                                    Text('Booking Date',
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24),
                                                  child: Text(
                                                      item['dDateOfBooking'] ??
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
                                                    Text('Days Of Booking',
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24),
                                                  child: Text(
                                                      item['iDaysOfBooking']
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
                                                    Text('Purpose of Booking',
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24),
                                                  child: Text(
                                                      item['dPurposeOfBooking']
                                                              .toString() ??
                                                          '',
                                                      style: AppTextStyle
                                                          .font14penSansExtraboldBlack26TextStyle),
                                                ),
                                                // status row cancel and Pay Now
                                                //address
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
                                                      item['sAddress']
                                                              .toString() ??
                                                          '',
                                                      style: AppTextStyle
                                                          .font14penSansExtraboldBlack26TextStyle),
                                                ),
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
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
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
                                                              item['sStatus'] ??
                                                                  '',
                                                              style: AppTextStyle
                                                                  .font14OpenSansRegularRedTextStyle),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: 50,
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  right: 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.end,
                                                            children: [
                                                             // iStatus.toString() != "5"
                                                              iStatus!=5
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        var bookingRequuestId =
                                                                            item['sBookingReqId'] ??
                                                                                '';
                                                                        // _showCustomBottomSheet(context,bookingRequuestId);
                                                                        // showCancelBookingDialog(
                                                                        //     context,
                                                                        //     bookingRequuestId);
                                                                        _showCustomBottomSheet(
                                                                            context,
                                                                            bookingRequuestId);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            100,
                                                                        // decoration
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(15), // Rounded corners
                                                                        ),
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              SizedBox(width: 5),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),

                                                iStatus == 1 && iPaymenyDone == 1
                                                    ? Container(
                                                    height:
                                                    40,
                                                    width:
                                                    100,
                                                    decoration:
                                                    BoxDecoration(
                                                      color:
                                                      Colors.green,
                                                      borderRadius:
                                                      BorderRadius.circular(15), // Rounded corners
                                                    ),
                                                    child: const Center(
                                                      child: Text("Payment Done",
                                                      style: TextStyle(color: Colors.white,fontSize: 14),
                                                      ),
                                                    ))
                                                    :
                                              Visibility(
                                          visible: (iStatus == 1 && iPaymenyDone == 0), // Only show for this condition
                                      child: InkWell(
                                        onTap: () {
                                          print("-----717---");
                                         // showPaymentGatewayDialog(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext dialogContext) {
                                              return paymentDialog(dialogContext);
                                            },
                                          );

                                          },
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(15), // Rounded corners
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Pay Now",
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )



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
  // bottom sheet code
  void _showCustomBottomSheet(BuildContext context, bookingRequuestId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Ensures the bottom sheet adjusts for the keyboard
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top corners
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Allows the content to scroll if it overflows
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  16, // Adjust for keyboard
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Shrinks the column to fit its children
              children: [
                // Center image
                Center(
                  child: Image.asset(
                    ImageAssets.iclauncher,
                    // Replace with your image asset path
                    width: AppSize.s145,
                    height: AppSize.s145,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16),

                // Row with circular widget and "Feedback" text
                Row(
                  children: [
                    // Circular widget
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      child: Icon(Icons.feedback, color: Colors.blue),
                    ),
                    SizedBox(width: 10),
                    // Text "Feedback"
                    Text(
                      "Remarks",
                      style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // EditText with multiline support
                TextFormField(
                  controller: _remarksController,
                  // Controller to manage the text field's value
                  textInputAction: TextInputAction.done,
                  // Adjust action for the keyboard
                  maxLines: 4,
                  // Allows the text field to expand to multiple lines
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    // Add a border around the text field
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, // Adjust padding inside the text field
                      horizontal: 10.0,
                    ),
                    filled: true,
                    // Enable background color for the text field
                    fillColor: Colors.white,
                    hintText: "Enter your Remarks here...",
                    // Placeholder text
                    hintStyle: TextStyle(
                        color: Colors.grey), // Style for the placeholder text
                  ),
                  autovalidateMode: AutovalidateMode
                      .onUserInteraction, // Enable validation on user interaction
                ),
                SizedBox(height: 16),

                // Submit button
                InkWell(
                  onTap: () {
                    var remarkController = _remarksController.text.trim();
                    print("---1018---$remarkController");
                    if (remarkController.isNotEmpty) {
                      print("-----call Api-----");
                      // displayToast("Call Api");
                      //open Confirm Dialiog here

                      showCancelBookingDialog(context, bookingRequuestId);
                    } else {
                      print("----- Not call Api-----");
                      displayToast("Please enter Remarks");
                    }
                    //  call Api
                    // print("---729--$bookingRequuestId");

                    //validateAndCallRemarksApi(bookingRequuestId); // Your validation logic
                  },
                  child: Container(
                    width: double.infinity, // Make the button fill the width
                    height: AppSize.s45,
                    decoration: BoxDecoration(
                      color: Color(0xFF255898), // Button color
                      borderRadius: BorderRadius.circular(
                          AppMargin.m10), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // show cancel Bottom Dialog
  void showCancelBookingDialog(BuildContext context, bookingRequuestId) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing when tapping outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(20),
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          title: const Text(
            "Booking Request Cancel",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text("Are you sure you want to cancel this booking?",
              style: AppTextStyle.font14penSansExtraboldBlack26TextStyle),
          actionsAlignment: MainAxisAlignment.end,
          // Align buttons to the right
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // Close Dialog
                    // displayToast("Booking Canceled Successfully");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    "No It's fine",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    /// you should call api dialog box
                    /// todo remove comments

                    // _showCustomBottomSheet(context, bookingRequuestId);
                    validateAndCallRemarksApi(bookingRequuestId);
                    Navigator.pop(dialogContext); // Close Dialog
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    "Yes, Confirm",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class NoDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Record Found',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
