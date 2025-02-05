import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puri/services/GetAdvertismentRequestStatus.dart';
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
  State<AdvertisementbookingstatusPage> createState() => _AdvertisementbookingstatusPageState();
}

class _AdvertisementbookingstatusPageState extends State<AdvertisementbookingstatusPage> {

  //
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>>? _filteredData;
  bool isLoading=true;

  pendingInternalComplaintResponse() async {
    pendingInternalComplaintList = await GetAdvertismentRequestStatusRepo().getAdvertisementStatus(context);
    print('-----37----$pendingInternalComplaintList');
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
          onTap: (){
            print("------back---");
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
            );
          },
          child: const Icon(Icons.arrow_back_ios,
            color: Colors.white,),
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
      body:  isLoading
          ? Center(child:
      Container())
          : (pendingInternalComplaintList == null || pendingInternalComplaintList!.isEmpty)
          ? NoDataScreenPage()
          :

      Column(
        children: <Widget>[
    Expanded(
      child: ListView.builder(
      itemCount: _filteredData?.length ?? 0,
      itemBuilder: (context, index) {
        Map<String, dynamic> item = _filteredData![index];
        return Container(
          color: Colors.white,
          child: Card(
              elevation: 2,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 65,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 45,
                              width: 4,
                              color: Colors.green,
                            ),
                            SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item['sContent'] ?? '',style: AppTextStyle
                                      .font12OpenSansRegularBlack45TextStyle,),
                                  Text("Advertisement Place : ${item['sAdSpacePlace'] ?? ''}",
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack26TextStyle)
                                ],
                              ),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5),
                                Text('Content Description',
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle),
                                SizedBox(height: 2),
                                Text(item['sContentDescription'] ?? '',
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
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(Icons.watch_later_rounded,
                                color: Colors.black26,
                              ),
                              SizedBox(width: 5),
                              Text(item['dPostedAt'] ?? '',
                                  style: AppTextStyle
                                      .font14OpenSansRegularBlack45TextStyle),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 2),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            // Add padding around the text
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 5),
                            // CircleWithSpacing(),
                            Icon(Icons.calendar_month, size: 20),
                            SizedBox(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5),
                                Text('From Date',
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle),
                                SizedBox(height: 2),
                                Text(item['dFromDate'].toString() ?? '',
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
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 5),
                              // CircleWithSpacing(),
                              Icon(Icons.calendar_month, size: 20),
                              SizedBox(width: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5),
                                  Text('To Date',
                                      style: AppTextStyle
                                          .font14OpenSansRegularBlack45TextStyle),
                                  SizedBox(height: 2),
                                  Text(item['dToDate'].toString() ?? '',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.file_copy_outlined,
                              size: 22,
                            ),
                            SizedBox(width: 4),
                            Text('Req.No : ${item['sRequestNo'].toString() ?? ''}',
                                style: AppTextStyle
                                    .font14OpenSansRegularBlack45TextStyle)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, top: 5),
                          child: Container(
                            height: 35,
                            // Increased height for proper text alignment
                            width: 100,
                            decoration: const BoxDecoration(
                              color: Colors.yellow, // Background color
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(20),
                                // Half of the height for a circle
                                right: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                item['sStatus'].toString() ?? '',
                                style: AppTextStyle
                                    .font14OpenSansRegularBlack26TextStyle,
                                textAlign: TextAlign
                                    .center, // Ensure text is centered
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
          ),
        );
      }
      )
    )  ],
      ),
    );
  }
}

