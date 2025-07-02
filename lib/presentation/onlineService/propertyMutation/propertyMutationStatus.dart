import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:puri/services/GetMutationStatusRepo.dart';
import '../../../../app/generalFunction.dart';
import '../../aboutDiu/Aboutdiupage.dart';
import '../../circle/circle.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';
import 'PropertyTransferDocListImages.dart';


class PropertyMutationStatus extends StatefulWidget {
  final name;
  PropertyMutationStatus({super.key, this.name});

  @override
  State<PropertyMutationStatus> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<PropertyMutationStatus> {

  GeneralFunction generalFunction = GeneralFunction();

  var variableName;
  var variableName2;
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>>? getMutationStatus;
  List<Map<String, dynamic>> _filteredData = [];
  List bindAjencyList = [];
  List userAjencyList = [];
  var iAgencyCode;
  var agencyUserId;
  TextEditingController _searchController = TextEditingController();
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
  var sTranNo;

  pendingInternalComplaintResponse() async {
    //  PropertyMutationStatusRepo ---propertyMutationStatus
    getMutationStatus = await GetMutationStatusRepo().getMutationStatus(context);
    print('-----66--->>>>>>----$getMutationStatus');
    _filteredData = List<Map<String, dynamic>>.from(getMutationStatus ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }
  //  payment Dialog
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
                      var sPageName = "Property Transfer Status";
                      // call a Payment page
                      var baseurl = "https://www.diusmartcity.com/PropertyTransferPaymentGatewayMobile.aspx?QS=";
                      var paymentUrl = "$baseurl$sTranNo";
                      print('-----187--$sTranNo');
                      print('------187---$paymentUrl');

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
                      var sPageName = "Property Transfer Status";
                      // call a Payment page
                      var baseurl = "https://www.diusmartcity.com/SBIPropertyTransferDataFormGetewayMobile.aspx?QS=";
                      var paymentUrl = "$baseurl$sTranNo";
                      print('------222----$sTranNo');
                      print('------187---$paymentUrl');

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
    super.dispose();
  }

  void _search() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = getMutationStatus?.where((item) {
        String location = item['sApplicantName'].toLowerCase();
        String pointType = item['sFathersName'].toLowerCase();
        String sector = item['sApplicantMobile'].toLowerCase();
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
    setState(() {

    });
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
      onTap: (){
        FocusScope.of(context).unfocus(); // Unfocus any focused widget
      },
      child: Scaffold(
        backgroundColor: Colors.white,
         appBar: getAppBarBack(context,'${widget.name}'),
        // appBar: getAppBarBack(context,'jjsjsjsj-----'),
        drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body :
        // pendingInternalComplaintList == null
        //   ? NoDataScreen()
        //   :
        isLoading
            ? Center(child:
        Container())
            : (getMutationStatus == null || getMutationStatus!.isEmpty)
            ? NoDataScreenPage()
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                  var pending = item['sStatusName'];
                  sTranNo = item['sTranNo'];

                  return Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                    child: Container(
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            shadowColor: Colors.white,
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2,right: 2),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                        color :Colors.white,
                                        border: Border.all(
                                          color: Colors.grey, // Border color
                                          width: 1, // Border width
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                                color :Color(0xFFF5F5F5),
                                              ),
                                              child: ListTile(
                                                leading: Container(
                                                  // color: Colors.blueGrey,
                                                  width: 35,
                                                  height: 35,
                                                  // Height and width must be equal to make it circular
                                                  decoration: const BoxDecoration(
                                                    // color: Colors.orange,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      'assets/images/home12.jpeg',
                                                      height: 25,
                                                      width: 25,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(item['sWardName'] ?? '',
                                                    style: AppTextStyle
                                                        .font14penSansExtraboldBlack45TextStyle),
                                              )),
                                          Positioned(
                                            top: 10,
                                            right: 15,
                                            child: GestureDetector(
                                              onTap: (){
                                                // print("------257-----");
                                                //  sComplaintPhoto
                                                // var image = "${item['sComplaintPhoto']}";
                                                // print('------260----$image');
                                                // // FullScreenImages
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(builder: (context) => FullScreenImages(image:image)),
                                                // );
                                                var licenseRequestId = "${item['sTranNo'].toString()}";

                                                print('----284---$licenseRequestId');

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => PropertyTransferDocListImages(licenseRequestId:licenseRequestId),
                                                  ),
                                                );

                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                // Height and width must be equal to make it circular
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  // Makes the container circular
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/picture.png',
                                                    height: 25,
                                                    width: 25,
                                                    fit: BoxFit.fill,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Property Transfer Type',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sMutationType'].toString() ?? '',
                                        style: AppTextStyle
                                            .font14OpenSansRegularRedTextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Property Transfer Fee',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['fMutationFee'].toString() ?? "0",
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Applicant Name',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sApplicantName'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  // Applicant Father Name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Applicant Father Name',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sFathersName'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  //Applicant  Mobile number
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(width: 5),
                                              CircleWithSpacing(),
                                              Text('Applicant Mobile Number',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularBlack45TextStyle),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24),
                                            child: Text(item['sApplicantMobile'] ?? '',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),
                                          ),
                                        ],
                                  ),
                              ]
                                  ),
                                  // Owner name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(width: 5),
                                              CircleWithSpacing(),
                                              Text('Owner Name',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularBlack45TextStyle),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24),
                                            child: Text(item['sCurOwner'] ?? '',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Address',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sApplicationAddr'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                            padding: const EdgeInsets.only(left: 24),
                                            child: Text(item['sStatusName'] ?? '',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      pending !="Pending" ?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // payment code
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: InkWell(
                                              onTap: (){
                                                // todo here you should open DialogBox..
                                                 print('----630----');

                                                 showDialog(
                                                   context: context,
                                                   builder: (BuildContext dialogContext) {
                                                     return paymentDialog(dialogContext);
                                                   },
                                                 );



                                              },
                                              child: Container(
                                                height: 35,
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                alignment: Alignment.center,
                                                // sStatus
                                                child: Text('Pay Now',
                                                    textAlign: TextAlign.center,
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularWhiteTextStyle),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                          :SizedBox()],
                                  ),
                                  pending !="Pending" ?
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5,left: 5,right: 5,top: 5),
                                        child: Row(
                                          children: [
                                            // First Container
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                //color: Colors.blue,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  gradient: const LinearGradient(
                                                    // colors: [Colors.red, Colors.orange],
                                                    colors: [Color(0xFF255898),Color(0xFF12375e)],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),

                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, top: 5),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Action By",
                                                          style: AppTextStyle
                                                              .font140penSansExtraboldWhiteTextStyle),
                                                      Text(item['sActionBy'] ?? 'No Action by',
                                                          style: AppTextStyle
                                                              .font140penSansExtraboldWhiteTextStyle)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            // Second Container
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 0),
                                                child: Container(
                                                  height: 50,
                                                  //color: Colors.blue,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    gradient: const LinearGradient(
                                                      colors: [Color(0xFF255898),Color(0xFF12375e)],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Action At',
                                                            style: AppTextStyle
                                                                .font140penSansExtraboldWhiteTextStyle),
                                                        Text(item['dActionDate'] ?? 'No Action At',
                                                            style: AppTextStyle
                                                                .font140penSansExtraboldWhiteTextStyle)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        // color: Colors.blue,
                                        color: Color(0x4D565DFF),
                                        // 4D565DFF
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(width: 5),
                                            Container(
                                              height: 40,
                                              width: 4,
                                              color: Colors.red,

                                            ),
                                            SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Remarks',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle),
                                                  SizedBox(height: 5),
                                                  Text(item['sRemarks'] ?? 'No Remarks',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularRedTextStyle),
                                                ],
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                      : SizedBox(),
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
