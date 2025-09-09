
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/generalFunction.dart';
import '../../../services/citizenMyPostedComplaint.dart';
import '../../homepage/homepage.dart';

class PendingComplaintScreen extends StatelessWidget {
  const PendingComplaintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SchedulePointScreen(),
    );
  }
}

class SchedulePointScreen extends StatefulWidget {
  const SchedulePointScreen({Key? key}) : super(key: key);

  @override
  State<SchedulePointScreen> createState() => _SchedulePointScreenState();
}

class _SchedulePointScreenState extends State<SchedulePointScreen> {

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
  var _dropDownAgency2;
  var _dropDownValueUserAgency;
  final distDropdownFocus = GlobalKey();
  var result, msg;
  var userAjencyData;
  var result1;
  var msg1;
  GeneralFunction generalfunction = GeneralFunction();

  // Api response

  pendingInternalComplaintResponse() async {
    pendingInternalComplaintList =
    await CitizenMyPostComplaintRepo().cityzenpostcomplaint(context);
    print('-----50----$pendingInternalComplaintList');
    _filteredData =
    List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    pendingInternalComplaintResponse();
    _searchController.addListener(_search);
   // bindAjency();
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
        String location = item['sLocation'].toLowerCase();
        String pointType = item['sPointTypeName'].toLowerCase();
        String sector = item['sSectorName'].toLowerCase();
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

  // bindAjency() async {
  //   bindAjencyList = await BindAjencyRepo().bindajency();
  //   print(" -----157---bindAjencyList---> $bindAjencyList");
  //   setState(() {});
  // }

  // userAjency(int ajencyCode) async {
  //
  //   userAjencyList = await AjencyUserRepo().ajencyuser(ajencyCode);
  //   setState(() {
  //   });
  //   if(userAjencyList ==null || userAjencyList.isEmpty){
  //   }else{
  //     displayToast("Record Found");
  //   }
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF255899),
        leading: GestureDetector(
            onTap: () {

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_ios),
            )),
        title: const Text(
          'Grievance Status',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
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
                          elevation: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Colors.grey, // Outline border color
                                width: 0.2, // Outline border width
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15.0),
                                            border: Border.all(
                                              color: Color(0xFF255899),
                                              // Outline border color
                                              width:
                                              0.5, // Outline border width
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: const Center(
                                              child: Icon(Icons.ac_unit_rounded,
                                                  color: Color(0xFF255899),
                                                  size: 20)),
                                        ),
                                        SizedBox(width: 5),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              item['sPointTypeName'] ?? '',
                                              style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xff3f617d),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              'Point Name',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xff3f617d),
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 0),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              var fLatitude =
                                                  item['fLatitude'] ?? '';
                                              var fLongitude =
                                                  item['fLongitude'] ?? '';
                                              print('----462----${fLatitude}');
                                              print('-----463---${fLongitude}');
                                              if (fLatitude != null &&
                                                  fLongitude != null) {
                                                generalfunction.launchGoogleMaps(fLatitude,fLongitude);

                                              } else {
                                                displayToast(
                                                    "Please check the location.");
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              height: 40,
                                              width: 40,
                                              child: const Image(
                                                  image: AssetImage(
                                                      'assets/images/ic_google_maps.PNG')),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Container(
                                      height: 0.5,
                                      color: const Color(0xff3f617d),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.forward,
                                        size: 10,
                                        color: Color(0xff3f617d),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Complaint NO',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF255899),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      item['iCompCode'].toString() ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff3f617d),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.forward,
                                        size: 10,
                                        color: Color(0xff3f617d),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Sector',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF255899),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      item['sSectorName'] ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff3f617d),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.forward,
                                        size: 10,
                                        color: Color(0xff3f617d),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Posted At',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF255899),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      item['dPostedOn'] ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff3f617d),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.forward,
                                          size: 10, color: Color(0xff3f617d)),
                                      SizedBox(width: 5),
                                      Text(
                                        'Location',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF255899),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      item['sLocation'] ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff3f617d),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.forward,
                                          size: 10, color: Color(0xff3f617d)),
                                      SizedBox(width: 5),
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF255899),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      item['sDescription'] ?? '',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff3f617d),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.calendar_month,
                                        size: 10,
                                        color: Color(0xff3f617d),
                                      ),
                                      SizedBox(width: 5),
                                      const Text(
                                        'Pending Since :-',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFF255899),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        item['sPendingFrom'] ?? '',
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xff3f617d),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      color: Color(0xffe4e4e4),
                                      height: 40,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  var sBeforePhoto =
                                                      "${item['sBeforePhoto']}";
                                                  print('---$sBeforePhoto');

                                                  if (sBeforePhoto != null) {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (
                                                    //             context) =>
                                                    //             ImageScreen(
                                                    //                 sBeforePhoto:
                                                    //                 sBeforePhoto)));
                                                  } else {
                                                    // toast
                                                  }
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'View Image',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'Montserrat',
                                                          color:
                                                          Color(0xFF255899),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.forward_sharp,
                                                      color: Color(0xFF255899),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                height: 10,
                                                width: 1,
                                                color: Colors.grey),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Action',
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'Montserrat',
                                                          color:
                                                          Color(0xFF255899),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.forward_sharp,
                                                      color: Color(0xFF255899),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                height: 10,
                                                width: 1,
                                                color: Colors.grey),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  //bindAjency();
                                                  _showBottomSheet(context);
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text('Forward',
                                                        style: TextStyle(
                                                            fontFamily:
                                                            'Montserrat',
                                                            color:
                                                            Color(0xFF255899),
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                            FontWeight.bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }

// bottom screen
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey,
      builder: (BuildContext context) {
        return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            height: 280,
            // Adjust height as needed
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0), // Adjust the radius as needed
                topRight: Radius.circular(20.0), // Adjust the radius as needed
              ),
            ),
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // Background color of the container
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            // Color of the shadow
                            spreadRadius: 5,
                            // Spread radius
                            blurRadius: 7,
                            // Blur radius
                            offset: Offset(0, 3), // Offset of the shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15,top: 0),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin:
                                  EdgeInsets.only(left: 0, right: 10, top: 10),
                                  child: Image.asset(
                                    'assets/images/ic_expense.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Fill the below details',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, right: 2, bottom: 2),
                                      child: const Icon(
                                        Icons.forward_sharp,
                                        size: 12,
                                        color: Colors.black54,
                                      )),
                                  const Text('Agency',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 50,
                              height: 50,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      hint: RichText(
                                        text: const TextSpan(
                                          text: 'Please choose a Agency ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      value: _dropDownAgency2,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _dropDownAgency2 = newValue;
                                          userAjencyList = [];
                                          _dropDownValueUserAgency = null;
                                          bindAjencyList.forEach((element) async {
                                            if (element["sAgencyName"] == _dropDownAgency2) {
                                              iAgencyCode = element['iAgencyCode'];
                                              setState(() {});
                                              if (iAgencyCode != null) {
                                                // TODO: update next api
                                              //  userAjency(iAgencyCode);

                                              } else {
                                                print('Please Select State name');
                                              }
                                            }
                                          });
                                        });
                                      },
                                      items: bindAjencyList.map((dynamic item) {
                                        return DropdownMenuItem(
                                          child: Text(item['sAgencyName'].toString()),
                                          value: item["sAgencyName"].toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, right: 2),
                                      child: const Icon(
                                        Icons.forward_sharp,
                                        size: 12,
                                        color: Colors.black54,
                                      )),
                                  const Text('User',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 50,
                              height: 50,
                              child:
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      hint: RichText(
                                        text: const TextSpan(
                                          text: 'Please choose a State ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      value: _dropDownValueUserAgency,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _dropDownValueUserAgency = newValue;
                                          userAjencyList.forEach((element) async {
                                            if (element["sName"] == _dropDownValueUserAgency) {
                                              agencyUserId = element['iUserId'];
                                              setState(() {});
                                             }
                                          });
                                        });
                                      },
                                      items: userAjencyList.map((dynamic item) {
                                        return DropdownMenuItem(
                                          child: Text(item['sName'].toString()),
                                          value: item["sName"].toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )

                              )
                            ),

                            SizedBox(height: 10),
                            // ElevatedButton(
                            //     onPressed: () async {
                            //       /// TODO REMOVE COMMENT AND apply proper api below and handle api data
                            //       // print('----clicked--xxxxxxxx--');
                            //       if (iAgencyCode != null &&
                            //           agencyUserId != null) {
                            //         var complaintForwardResponse = await ComplaintForwardRepo()
                            //             .complaintForward(context,
                            //             iAgencyCode, agencyUserId);
                            //         result1 = "${complaintForwardResponse['Result']}";
                            //          msg1 = "${complaintForwardResponse['Msg']}";
                            //         if(result1=="1"){
                            //           displayToast(msg1);
                            //           Navigator.pop(context);
                            //
                            //         }else{
                            //           displayToast(msg1);
                            //         }
                            //
                            //       } else {
                            //         print('----Not call a Api--');
                            //       }
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: const Color(
                            //           0xFF255899), // Hex color code (FF for alpha, followed by RGB)
                            //     ),
                            //     child: const Text("Submit",
                            //       style: TextStyle(
                            //           fontFamily: 'Montserrat',
                            //           color: Colors.white,
                            //           fontSize: 16.0,
                            //           fontWeight: FontWeight.bold),
                            //     ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}


  class MyListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return ListTile(
  leading: Container(
  width: 50.0,
  height: 50.0,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(25.0),
  border: Border.all(
  color: Colors.grey, // Outline border color
  width: 0.5, // Outline border width
  ),
  color: Colors.white,
  ),
  child: const Center(
  child: Text(
  "1.",
  style: TextStyle(color: Colors.black, fontSize: 20),
  ),
  )),
  title: const Text(
  'C&D Waste',
  style: TextStyle(
  fontFamily: 'Montserrat',
  color: Colors.black,
  fontSize: 16.0,
  fontWeight: FontWeight.bold),
  ),
  subtitle: const Text(
  'Point Name',
  style: TextStyle(
  fontFamily: 'Montserrat',
  color: Colors.black54,
  fontSize: 14.0,
  fontWeight: FontWeight.bold),
  ),
  onTap: () {
  // Handle onTap
  },
  );
  }
  }

