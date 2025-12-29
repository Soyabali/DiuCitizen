
import 'package:flutter/material.dart';
import 'package:puri/presentation/onlineService/license/licenseStatus/tradedetails.dart';
import '../../../../app/generalFunction.dart';
import '../../../../services/BindLicenseStatusRepo.dart';
import '../../../aboutDiu/Aboutdiupage.dart';
import '../../../circle/circle.dart';
import '../../../nodatavalue/NoDataValue.dart';
import '../../../resources/app_text_style.dart';
import 'licenseStatusImages.dart';


class LicenseStatus extends StatefulWidget {

  final name;
  LicenseStatus({super.key, this.name});

  @override
  State<LicenseStatus> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<LicenseStatus> {

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
  double? lat;
  double? long;
  final distDropdownFocus = GlobalKey();
  var result, msg;
  var userAjencyData;
  var result1;
  var msg1;
  GeneralFunction generalfunction = GeneralFunction();
  bool isLoading = true;

  // Api response

  pendingInternalComplaintResponse() async {
    pendingInternalComplaintList = await BindLicenseStatusRepo().bindLicenseStatus(context);
    debugPrint('-----49--->>>>>>----$pendingInternalComplaintList');
    _filteredData = List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
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
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredData = pendingInternalComplaintList?.where((item) {

        final sLicenseRequestCode =
            item['sLicenseRequestCode']?.toString().toLowerCase() ?? '';

        final sPremisesName =
            item['sPremisesName']?.toString().toLowerCase() ?? '';

        final sPremisesAddress =
            item['sPremisesAddress']?.toString().toLowerCase() ?? '';

        final sMobileNo =
            item['sMobileNo']?.toString().toLowerCase() ?? '';

        final sWardName =
            item['sWardName']?.toString().toLowerCase() ?? '';

        final sFinYear =
            item['sFinYear']?.toString().toLowerCase() ?? '';

        return sLicenseRequestCode.contains(query) ||
            sPremisesName.contains(query) ||
            sPremisesAddress.contains(query) ||
            sMobileNo.contains(query) ||
            sWardName.contains(query) ||
            sFinYear.contains(query);
      }).toList() ?? [];
    });
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
        body :
        isLoading
            ? buildShimmerList()
            : (pendingInternalComplaintList == null || pendingInternalComplaintList!.isEmpty)
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
                  var pending = item['LicenseStatus'];
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
                                                var licenseRequestId = "${item['sLicenseRequestCode'].toString()}";
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => LicenseStatusImages(licenseRequestId:licenseRequestId),
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
                                      Text('License Request Id',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sLicenseRequestCode'].toString() ?? '',
                                        style: AppTextStyle
                                            .font14OpenSansRegularRedTextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Premises Name',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sPremisesName'] ?? '',
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
                                  // Mobile no
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
                                              Text('Mobile No',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularBlack45TextStyle),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24),
                                            child: Text(item['sMobileNo'] ?? '',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      //pending !="Pending" ?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                             print("-----432----New Screen--");
                                             //var licenseRequestId  = item['sLicenseRequestCode'].toString() ?? ''
                                           var licenseRequestId = "${item['sLicenseRequestCode'].toString() ?? ''}";
                                            print("---445--$licenseRequestId");

                                            Navigator.push(
                                               context,
                                               MaterialPageRoute(
                                                 builder: (context) => TradeDetailsPage(licenseRequestId:licenseRequestId),
                                               ),
                                             );

                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child:Padding(
                                                padding: EdgeInsets.only(left: 10,right: 10),
                                                child: Center(
                                                  child: Image.asset("assets/images/cartimage.jpeg",
                                                   height: 35,
                                                    width: 35,
                                                    fit: BoxFit.cover,
                                                  )),
                                              ),
                                              ),
                                          ),
                                        ],
                                      )
                                     //:SizedBox()
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Financial Year',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(item['sFinYear'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
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
                                    child: Text(item['sAddress'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  // License Status
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
                                              Text('License Status',
                                                  style: AppTextStyle
                                                      .font14OpenSansRegularBlack45TextStyle),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24),
                                            child: Text(item['LicenseStatus'] ?? '',
                                                style: AppTextStyle
                                                    .font14penSansExtraboldBlack26TextStyle),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      pending !="Pending" && pending!="Rejected"?
                                      InkWell(
                                        onTap: () {
                                          print("-----611---");
                                          var licenseRequestId = "${item['sLicenseNo']}";
                                          print(licenseRequestId);
                                          print("------484---$licenseRequestId");
                                          var baseurl = "https://www.diusmartcity.com/LicensePaymentGatewayMobile.aspx?QS=";
                                          var paymentUrl = "$baseurl$licenseRequestId";
                                           print("----baseUrl--$baseurl");
                                          print("----licenseRequestId----$licenseRequestId");
                                          print("----FinalUrl-----$paymentUrl");

                                          var sPageName = "License Status";
                                          //
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                AboutDiuPage(
                                                    name: sPageName, sPageLink: paymentUrl)),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                gradient: const LinearGradient(
                                                  // colors: [Colors.red, Colors.orange],
                                                  colors: [Color(0xFF255898),Color(0xFF12375e)],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),

                                              ),
                                              child:Padding(
                                                padding: const EdgeInsets.only(left: 10,right: 10),
                                                child: Center(
                                                  child: Text(
                                                      "Make Payment",
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularWhiteTextStyle),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          :SizedBox()
                                    ],
                                  ),
                                  // bottom element
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
                                                      Text(item['dActionBy'] ?? 'No Action by',
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
                                                        Text(item['dActionRemarks'] ?? 'No Action At',
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
                                                  Text(item['dActionRemarks'] ?? 'No Remarks',
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
