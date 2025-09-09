import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/generalFunction.dart';
import '../../../services/buildingPlanApplicationStatusRepo.dart';
import '../../circle/circle.dart';
import '../../fullscreen/imageDisplay.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';

class BuildingPlanStatus extends StatefulWidget {

  final name,iCategoryCode;
  BuildingPlanStatus({super.key, this.name, required this.iCategoryCode});

  @override
  State<BuildingPlanStatus> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<BuildingPlanStatus> {

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
    pendingInternalComplaintList =
    await BuildingPlanApplicationStatusRepo().buildingPlainStatus(context);
    print('-----54----$pendingInternalComplaintList');
    _filteredData =
    List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

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
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = pendingInternalComplaintList?.where((item) {
        String location = item['sProjectName'].toLowerCase();
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
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context,'${widget.name}'),
        // appBar: getAppBarBack(context,'jjsjsjsj'),
        drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body :
        // pendingInternalComplaintList == null
        //   ? NoDataScreen()
        //   :
        isLoading
            ? Center(child:
        Container())
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
                                                title: Text(
                                                  //"202411211334552667",
                                                    item['iApplicationId'] ?? '',
                                                    style: AppTextStyle
                                                        .font14penSansExtraboldBlack45TextStyle),
                                              )),
                                          Positioned(
                                            top: 10,
                                            right: 15,
                                            child: GestureDetector(
                                              onTap: (){
                                                var image = "${item['sUploadBuildingPlanPath']}";
                                                // FullScreenImages
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => FullScreenImages(image:image)),
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
                                      Text('Project Name',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(
                                     // "ASD Project",
                                        item['sProjectName'] ?? '',
                                        style: AppTextStyle
                                            .font14OpenSansRegularRedTextStyle),
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
                                    child: Text(
                                      //"Architect Name",
                                        item['sApplicantName'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Application Mobile Number',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(
                                     // "9871950888",
                                        item['sMobileNo'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 5),
                                      CircleWithSpacing(),
                                      Text('Email Id',
                                          style: AppTextStyle
                                              .font14OpenSansRegularBlack45TextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(
                                     // "test@gmail.com",
                                        item['sEmailId'] ?? '',
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
                                    child: Text(
                                     // "Diu",
                                       item['sAddress'] ?? '',
                                        style: AppTextStyle
                                            .font14penSansExtraboldBlack26TextStyle),
                                  ),
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
                                    child: Text(
                                     // "Certificate Issued",
                                        item['sStatusType'] ?? '',
                                        style:
                                        AppTextStyle.font14OpenSansRegularGreenTextStyle),
                                  ),
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
                                                  Text('Architect Name',
                                                      style: AppTextStyle
                                                          .font140penSansExtraboldWhiteTextStyle),
                                                  Text(
                                                   // "Anil",
                                                      item['sArchitectName'] ?? '',
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
                                                    Text('Posted At',
                                                        style: AppTextStyle
                                                            .font140penSansExtraboldWhiteTextStyle),
                                                    Text(
                                                       // "21/Nov/2024 13:34",
                                                        item['dCreatedDate'] ?? '',
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



        // body: GestureDetector(
        //   onTap: (){
        //     FocusScope.of(context).unfocus();
        //   },
        //   child:
        //   // pendingInternalComplaintList == null
        //   //   ? NoDataScreen()
        //   //   :
        //   Padding(
        //     padding: const EdgeInsets.only(left: 5, right: 10, bottom: 0),
        //     child: SingleChildScrollView(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           SizedBox(height: 5),
        //            // searchBar
        //            Padding(
        //             padding: EdgeInsets.only(left: 5,right: 5,top: 5),
        //             child: SearchBar2(),
        //           ),
        //           SizedBox(height: 5),
        //
        //
        //           Container(
        //               color: Colors.white,
        //               child:
        //               Card(
        //                 elevation: 4,
        //                 shadowColor: Colors.white,
        //                 child: Container(
        //                   color: Colors.white,
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       SizedBox(height: 5),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 2,right: 2),
        //                         child: Container(
        //                            height: 50,
        //                            decoration: BoxDecoration(
        //                             borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
        //                             color :Colors.white,
        //                             border: Border.all(
        //                               color: Colors.grey, // Border color
        //                               width: 1, // Border width
        //                             ),
        //                           ),
        //
        //                           child: Stack(
        //                             children: [
        //                               Container(
        //                                   decoration: BoxDecoration(
        //                                     borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
        //                                     color :Color(0xFFF5F5F5),
        //                                   ),
        //                                   child: ListTile(
        //                                     leading: Container(
        //                                      // color: Colors.blueGrey,
        //                                       width: 35,
        //                                       height: 35,
        //                                       // Height and width must be equal to make it circular
        //                                       decoration: const BoxDecoration(
        //                                        // color: Colors.orange,
        //                                         shape: BoxShape.circle,
        //                                       ),
        //                                       child: Center(
        //                                         child: Image.asset(
        //                                           'assets/images/home12.jpeg',
        //                                           height: 25,
        //                                           width: 25,
        //                                           fit: BoxFit.cover,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     title: const Text(
        //                                       "Ward No -5",
        //                                       style: TextStyle(
        //                                           color: Colors.black45, fontSize: 14),
        //                                     ),
        //                                   )),
        //                               Positioned(
        //                                 top: 10,
        //                                 right: 15,
        //                                 child: Container(
        //                                   width: 30,
        //                                   height: 30,
        //                                   // Height and width must be equal to make it circular
        //                                   decoration: const BoxDecoration(
        //                                     color: Colors.white,
        //                                     shape: BoxShape.circle,
        //                                     // Makes the container circular
        //                                     boxShadow: [
        //                                       BoxShadow(
        //                                         color: Colors.black26,
        //                                         blurRadius: 5,
        //                                         offset: Offset(0, 2),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                   child: Center(
        //
        //                                     child: Image.asset(
        //                                       'assets/images/picture.png',
        //                                       height: 25,
        //                                       width: 25,
        //                                       fit: BoxFit.fill,
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                       SizedBox(height: 5),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: <Widget>[
        //                           SizedBox(width: 5),
        //                           Container(
        //                             width: 8,
        //                             height: 8,
        //                             decoration: const BoxDecoration(
        //                                 shape: BoxShape.circle,
        //                                 color: Colors.black54
        //                             ),
        //                           ),
        //                           SizedBox(width: 5),
        //                           Text('Complaint No',
        //                               style: AppTextStyle
        //                                   .font16penSansExtraboldBlack45TextStyle),
        //                         ],
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 15),
        //                         child: Text('202405310001',
        //                             style: AppTextStyle
        //                                 .font14penSansExtraboldBlack26TextStyle),
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: <Widget>[
        //                           SizedBox(width: 5),
        //                           Container(
        //                             width: 8,
        //                             height: 8,
        //                             decoration: const BoxDecoration(
        //                                 shape: BoxShape.circle,
        //                                 color: Colors.black54
        //                             ),
        //                           ),
        //                           SizedBox(width: 5),
        //                           Text('Category',
        //                               style: AppTextStyle
        //                                   .font16penSansExtraboldBlack45TextStyle),
        //                         ],
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 15),
        //                         child: Text('Sanitation & Public Health',
        //                             style: AppTextStyle
        //                                 .font14penSansExtraboldBlack26TextStyle),
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: <Widget>[
        //                           SizedBox(width: 5),
        //                           Container(
        //                             width: 8,
        //                             height: 8,
        //                             decoration: const BoxDecoration(
        //                                 shape: BoxShape.circle,
        //                                 color: Colors.black54
        //                             ),
        //                           ),
        //                           SizedBox(width: 5),
        //                           Text('Sub Category',
        //                               style: AppTextStyle
        //                                   .font16penSansExtraboldBlack45TextStyle),
        //                         ],
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 15),
        //                         child: Text('Night Sweeping',
        //                             style: AppTextStyle
        //                                 .font14penSansExtraboldBlack26TextStyle),
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: <Widget>[
        //                           SizedBox(width: 5),
        //                           Container(
        //                             width: 8,
        //                             height: 8,
        //                             decoration: const BoxDecoration(
        //                                 shape: BoxShape.circle,
        //                                 color: Colors.black54
        //                             ),
        //                           ),
        //                           SizedBox(width: 5),
        //                           Text('Complaint Details',
        //                               style: AppTextStyle
        //                                   .font16penSansExtraboldBlack45TextStyle),
        //                         ],
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 15),
        //                         child: Text('complaint related to Category',
        //                             style: AppTextStyle
        //                                 .font14penSansExtraboldBlack26TextStyle),
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: <Widget>[
        //                           SizedBox(width: 5),
        //                           Container(
        //                             width: 8,
        //                             height: 8,
        //                             decoration: const BoxDecoration(
        //                                 shape: BoxShape.circle,
        //                                 color: Colors.black54
        //                             ),
        //                           ),
        //                           SizedBox(width: 5),
        //                           Text('Address',
        //                               style: AppTextStyle
        //                                   .font16penSansExtraboldBlack45TextStyle),
        //                         ],
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 15),
        //                         child: Text('Puri Odisha',
        //                             style: AppTextStyle
        //                                 .font14penSansExtraboldBlack26TextStyle),
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.start,
        //                         children: <Widget>[
        //                           SizedBox(width: 5),
        //                           Container(
        //                             width: 8,
        //                             height: 8,
        //                             decoration: const BoxDecoration(
        //                                 shape: BoxShape.circle,
        //                                 color: Colors.black54
        //                             ),
        //                           ),
        //                           SizedBox(width: 5),
        //                           Text('Status',
        //                               style: AppTextStyle
        //                                   .font16penSansExtraboldBlack45TextStyle),
        //                         ],
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 15),
        //                         child: Text('Pending',
        //                             style:
        //                                 AppTextStyle.font14penSansExtraboldRedTextStyle),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(bottom: 5,left: 5,right: 5,top: 5),
        //                         child: Row(
        //                           children: [
        //                             // First Container
        //                             Expanded(
        //                               child: Container(
        //                                 height: 50,
        //                                 //color: Colors.blue,
        //                                 decoration: BoxDecoration(
        //                                   borderRadius: BorderRadius.circular(5),
        //                                   gradient: const LinearGradient(
        //                                     colors: [Colors.red, Colors.orange],
        //                                     begin: Alignment.topLeft,
        //                                     end: Alignment.bottomRight,
        //                                   ),
        //
        //                                 ),
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.only(left: 10, top: 5),
        //                                   child: Column(
        //                                     mainAxisAlignment: MainAxisAlignment.start,
        //                                     crossAxisAlignment: CrossAxisAlignment.start,
        //                                     children: [
        //                                       Text('Posted By',
        //                                           style: AppTextStyle
        //                                               .font140penSansExtraboldWhiteTextStyle),
        //                                       Text('Soyab',
        //                                           style: AppTextStyle
        //                                               .font140penSansExtraboldWhiteTextStyle)
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                             SizedBox(width: 5),
        //                             // Second Container
        //                             Expanded(
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(bottom: 0),
        //                                 child: Container(
        //                                   height: 50,
        //                                   //color: Colors.blue,
        //                                   decoration: BoxDecoration(
        //                                     borderRadius: BorderRadius.circular(5),
        //                                     gradient: const LinearGradient(
        //                                       colors: [Colors.red, Colors.orange],
        //                                       begin: Alignment.topLeft,
        //                                       end: Alignment.bottomRight,
        //                                     ),
        //                                   ),
        //                                   child: Padding(
        //                                     padding: const EdgeInsets.only(left: 10, top: 5),
        //                                     child: Column(
        //                                       mainAxisAlignment: MainAxisAlignment.start,
        //                                       crossAxisAlignment: CrossAxisAlignment.start,
        //                                       children: [
        //                                         Text('Posted At',
        //                                             style: AppTextStyle
        //                                                 .font140penSansExtraboldWhiteTextStyle),
        //                                         Text('31/May/2024 15:53',
        //                                             style: AppTextStyle
        //                                                 .font140penSansExtraboldWhiteTextStyle)
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //
        //
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
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
