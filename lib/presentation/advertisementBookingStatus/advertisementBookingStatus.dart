import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puri/services/GetAdvertismentRequestStatus.dart';
import '../aboutDiu/Aboutdiupage.dart';
import '../circle/circle.dart';
import '../complaints/complaintHomePage.dart';
import '../nodatavalue/NoDataValue.dart';
import '../resources/app_text_style.dart';

class AdvertisementBookingStatus extends StatelessWidget {
  const AdvertisementBookingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvertisementbookingstatusPage(),
    );
  }
}

class AdvertisementbookingstatusPage extends StatefulWidget {

  const AdvertisementbookingstatusPage({super.key});

  @override
  State<AdvertisementbookingstatusPage> createState() =>
      _AdvertisementbookingstatusPageState();
}

class _AdvertisementbookingstatusPageState extends State<AdvertisementbookingstatusPage> {
  //

  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>>? _filteredData;
  bool isLoading = true;

  var sRequestNo;

  pendingInternalComplaintResponse() async {
    pendingInternalComplaintList = await GetAdvertismentRequestStatusRepo()
        .getAdvertisementStatus(context);
    print('-----37----xx--$pendingInternalComplaintList');
    _filteredData =
        List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }

  // payment Dialog
  void showPaymentGatewayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Choose Payment Gateway",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const Divider(height: 30),

                // Row with two card options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: (){
                          //var requestNo = item['sRequestNo'];
                          var sPageName = "Advertisement Booking Status";
                          // call a Payment page
                          var baseurl = "https://www.diusmartcity.com/AdvertisementPaymentGatewayMobile.aspx?QS=";
                          var paymentUrl = "$baseurl$sRequestNo";
                          print(paymentUrl);


                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                AboutDiuPage(
                                    name: sPageName, sPageLink: paymentUrl)),
                          );


                          //  var requestNo = item['sTranNo'];
                          // var sPageName = "Property Transfer Status";
                          // // call a Payment page
                          // var baseurl = "https://www.diusmartcity.com/PropertyTransferPaymentGatewayMobile.aspx?QS=";
                          // var paymentUrl = "$baseurl$sTranNo";
                          // print('------187---$paymentUrl');
                          //
                          //
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) =>
                          //       AboutDiuPage(
                          //           name: sPageName, sPageLink: paymentUrl)),
                          // );

                          //
                          // var sPageName = "Community Hall Status";
                          // // Payment URL
                          // var baseurl = "https://www.diusmartcity.com/CommunityHallPaymentGatewayMobile.aspx?QS=";
                          // var paymentUrl = "$baseurl$sBookingReqId";
                          //
                          // print(paymentUrl);
                          //
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => AboutDiuPage(name: sPageName, sPageLink: paymentUrl),
                          //   ),
                          // );

                        },
                        child: _buildGatewayCard('assets/images/bankborda.png', 'Pay with BOB',Color(0xFFff5e62))),

                    GestureDetector(
                        onTap: (){
                          var sPageName = "Advertisement Booking Status";
                          // call a Payment page
                          var baseurl = "https://www.diusmartcity.com/AdvertisementPaymentGatewayMobile.aspx?QS=";
                          var paymentUrl = "$baseurl$sRequestNo";
                          print(paymentUrl);


                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) =>
                          //       AboutDiuPage(
                          //           name: sPageName, sPageLink: paymentUrl)),
                          // );

                          // var sPageName = "Community Hall Status";
                          // // Payment URL
                          // /// TODO HERE YOU SHOUL CHNAGE THE PATH
                          //
                          // var baseurl = "https://www.diusmartcity.com/CommunityHallPaymentGatewayMobile.aspx?QS=";
                          // var paymentUrl = "$baseurl$sBookingReqId";
                          //
                          // print(paymentUrl);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => AboutDiuPage(name: sPageName, sPageLink: paymentUrl),
                          //   ),
                          // );

                          // var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
                          //print('-----737---Sbi---');

                          // var baseurl = "https://www.diusmartcity.com/LicensePaymentGatewayMobile.aspx?QS=";
                          // var paymentUrl = "$baseurl$licenseRequestId";
                          // var sPageName = "Online License";
                          // //
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) =>
                          //       AboutDiuPage(name: sPageName, sPageLink: paymentUrl)),
                          // );
                        },
                        child: _buildGatewayCard('assets/images/banksbi.png', 'Pay with SBI',Color(0xFF005BAC))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildGatewayCard(String assetPath, String title, Color textColor) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Image.asset(assetPath, height: 40),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 14,
                color: textColor
            )),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    pendingInternalComplaintResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF12375e),
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        backgroundColor: Color(0xFF255898),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            print("------back---");
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ComplaintHomePage()),
            );
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Advertisemet Booking Status',
            style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        //centerTitle: true,
        elevation: 0, // Removes shadow under the AppBar
      ),
      body: isLoading
          ? Center(child: Container())
          : (pendingInternalComplaintList == null ||
                  pendingInternalComplaintList!.isEmpty)
              ? NoDataScreenPage()
              : Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                            itemCount: _filteredData?.length ?? 0,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> item = _filteredData![index];
                              var sStatus = item['sStatus'];
                             sRequestNo = item['sRequestNo'];
                              // to change a colore behafe of sStatus
                              Color color;
                              if (sStatus == "Pending") {
                                color = Colors.yellow;
                              } else if (sStatus == "Rejected") {
                                color = Colors.red;
                              } else if (sStatus == "Approved") {
                                color = Colors.green;
                              } else {
                                color = Colors.grey; // Default color if none of the conditions match
                              }

                              return Container(
                                color: Colors.white,
                                child: Card(
                                    elevation: 2,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 65,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 4,
                                                    color: Colors.green,
                                                  ),
                                                  SizedBox(width: 5),
                                                  //
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 12),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Text(item['sContent'] ?? '',
                                                              style: AppTextStyle
                                                                  .font12OpenSansRegularBlack45TextStyle,
                                                            ),
                                                            Text(
                                                                "Advertisement Place : ${item['sAdSpacePlace'] ?? ''}",
                                                                style: AppTextStyle
                                                                    .font14OpenSansRegularBlack26TextStyle)
                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end, // Align to right
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        decoration: BoxDecoration(
                                                          color: color,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        alignment: Alignment.center,
                                                   // sStatus
                                                        child: Text(item['sStatus'] ?? '',
                                                          textAlign: TextAlign.center,
                                                            style: AppTextStyle.font14OpenSansRegularWhiteTextStyle


                                                        ),
                                                      ),
                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            height: 0.5,
                                            color: Colors.black26,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 5),
                                                  CircleWithSpacing(),
                                                  SizedBox(width: 5),
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(height: 5),
                                                      Text('Content Description',style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                      SizedBox(height: 2),
                                                      Text(item['sContentDescription'] ?? '', style: AppTextStyle.font14OpenSansRegularBlack26TextStyle),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    const Icon(
                                                      Icons.watch_later_rounded,
                                                      color: Colors.black26,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(item['dPostedAt'] ?? '', style: AppTextStyle
                                                    .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 5),
                                                  CircleWithSpacing(),
                                                  SizedBox(width: 5),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(height: 5),
                                                      Text('Rent',
                                                          style: AppTextStyle
                                                              .font14OpenSansRegularBlack45TextStyle),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        '₹ ${item['fTotalAmount'].toString() ?? ''}',
                                                        style: AppTextStyle
                                                            .font14OpenSansRegularBlack26TextStyle,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  // Add padding around the text
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors
                                                          .black, // Border color
                                                      width:
                                                          1.0, // Border width
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5), // Optional: Rounded corners
                                                  ),
                                                  child: Text(
                                                    'No Of Day : ${item['sDays'].toString() ?? ''}',
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularBlack26TextStyle,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                            height: 0.5,
                                            color: Colors.black26,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(width: 5),
                                                  // CircleWithSpacing(),
                                                  Icon(Icons.calendar_month,
                                                      size: 20),
                                                  SizedBox(width: 5),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(height: 5),
                                                      Text('From Date', style: AppTextStyle
                                                              .font14OpenSansRegularBlack45TextStyle),
                                                      SizedBox(height: 2),
                                                      Text(
                                                          item['dFromDate'].toString() ??
                                                              '',
                                                          style: AppTextStyle
                                                              .font14OpenSansRegularBlack26TextStyle),
                                                    ],
                                                  )
                                                  // Text('Complaint Details',
                                                  //     style: AppTextStyle
                                                  //         .font14OpenSansRegularBlack45TextStyle),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 5),
                                                    // CircleWithSpacing(),
                                                    Icon(Icons.calendar_month,
                                                        size: 20),
                                                    SizedBox(width: 5),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        SizedBox(height: 5),
                                                        Text('To Date',
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlack45TextStyle),
                                                        SizedBox(height: 2),
                                                        Text(
                                                            item['dToDate']
                                                                    .toString() ??
                                                                '',
                                                            style: AppTextStyle
                                                                .font14OpenSansRegularBlack26TextStyle),
                                                      ],
                                                    )
                                                    // Text('Complaint Details',
                                                    //     style: AppTextStyle
                                                    //         .font14OpenSansRegularBlack45TextStyle),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          const Divider(
                                            height: 0.5,
                                            color: Colors.black26,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.file_copy_outlined,
                                                    size: 22,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                      'Req.No : ${item['sRequestNo'].toString() ?? ''}',
                                                      style: AppTextStyle
                                                          .font14OpenSansRegularBlack45TextStyle)
                                                ],
                                              ),
                                              // Apply a payment
                                              sStatus=="Approved" ?

                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: InkWell(
                                                  onTap: (){
                                                    showPaymentGatewayDialog(context);

                                                     // var requestNo = item['sRequestNo'];
                                                     // var sPageName = "Advertisement Booking Status";
                                                     // // call a Payment page
                                                     // var baseurl = "https://www.diusmartcity.com/AdvertisementPaymentGatewayMobile.aspx?QS=";
                                                     // var paymentUrl = "$baseurl$requestNo";
                                                     // print(paymentUrl);
                                                     //
                                                     // //
                                                     // Navigator.push(
                                                     //   context,
                                                     //   MaterialPageRoute(builder: (context) =>
                                                     //       AboutDiuPage(
                                                     //           name: sPageName, sPageLink: paymentUrl)),
                                                     // );

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
                                              ):
                                              SizedBox.shrink()
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    )),
                              );
                            }))
                  ],
                ),
    );
  }
}
