import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:math';

import '../../../app/loader_helper.dart';
import '../../../services/cityzenpostcomplaintRepo.dart';
import '../../../services/district_repo.dart';
import '../../../services/markLocationRepo.dart';
import '../../../services/postimagerepo.dart';
import '../../fullscreen/flull_screen_image.dart';
import '../../homepage/homepage.dart';
import '../../resources/values_manager.dart';


class MarkPointScreen extends StatelessWidget {
  const MarkPointScreen({super.key});

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List stateList = [];
  List distList = [];
  List blockList = [];
  List marklocationList = [];
  var result2,msg2;
  //File? image;

  //
  // Distic List
  updatedSector() async {
    distList = await DistRepo().getDistList();
    print(" -----xxxxx-  list Data--65---> $distList");
    setState(() {});
  }

  marklocationData() async {
    marklocationList = await MarkLocationRepo().getmarklocation();
    print(" -----xxxxx-  marklocationList--- Data--62---> $marklocationList");
    setState(() {});
  }

  // postImage
  postimage() async {
    var postimageResponse =
        await PostImageRepo().postImage(context, _imageFile);
    print(" -----xxxxx-  --72---> $postimageResponse");
    setState(() {});
  }
  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  // focus
  FocusNode locationfocus = FocusNode();
  FocusNode descriptionfocus = FocusNode();
  String? todayDate;

  List? data;
  var _dropDownValueDistric;
  var _dropDownValueMarkLocation;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  File? _imageFile;
  var _selectedPointId;
  var _selectedBlockId;
  final _formKey = GlobalKey<FormState>();
  var iUserTypeCode;
  var userId;
  var slat;
  var slong;
  File? image;
  var uplodedImage;

  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 65);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
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
  // image code
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));

      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body);

      // Print the response data
      print(responseData);
      hideLoader();
      print('---------172---$responseData');
      uplodedImage = "${responseData['Data'][0]['sImagePath']}";
      print('----174---$uplodedImage');
    } catch (error) {
      showLoader();
      print('Error uploading image: $error');
    }
  }

  multipartProdecudre() async {
    print('----139--$image');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token---$sToken');

    var headers = {
      'token': '$sToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://upegov.in/noidaoneapi/Api/PostImage/PostImage'));
    request.body = json.encode({
      "sImagePath": "$image"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      print('---155----$responseData');

  }
  // datepicker
  // InitState

  @override
  void initState() {
    // TODO: implement initState
    updatedSector();
    marklocationData();
    super.initState();
    locationfocus = FocusNode();
    descriptionfocus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationfocus.dispose();
    descriptionfocus.dispose();
  }

  // Todo bind sector code
  Widget _bindSector() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: const TextSpan(
                  text: "Please choose a Sector",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ), // Not necessary for Option 1
              value: _dropDownValueDistric,
              key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueDistric = newValue;
                  print('---187---$_dropDownValueDistric');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  distList.forEach((element) {
                    if (element["sSectorName"] == _dropDownValueDistric) {
                      setState(() {
                        _selectedBlockId = element['iSectorCode'];
                      });
                      print('-----170--$_selectedBlockId');
                    }
                  });
                });
              },
              items: distList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sSectorName'].toString()),
                  value: item["sSectorName"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Todo same way you should bind point Type data.
  Widget _bindMarkLocation() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 42,
        color: Color(0xFFf2f3f5),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: const TextSpan(
                  text: "Please choose a Sector",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ), // Not necessary for Option 1
              value: _dropDownValueMarkLocation,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueMarkLocation = newValue;
                  print('---333-------$_dropDownValueMarkLocation');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  marklocationList.forEach((element) {
                    if (element["sPointTypeName"] ==
                        _dropDownValueMarkLocation) {
                      setState(() {
                        _selectedPointId = element['iPointTypeCode'];
                        print('----341------$_selectedPointId');
                      });
                      print('-----Point id----241---$_selectedPointId');
                      if (_selectedPointId != null) {
                        // updatedBlock();
                        print('-----Point id----244---$_selectedPointId');
                      } else {
                        print('-------');
                      }
                      // print("Distic Id value xxxxx.... $_selectedDisticId");
                      print("Distic Name xxxxxxx.... $_dropDownValueDistric");
                      print("Block list Ali xxxxxxxxx.... $blockList");
                    }
                  });
                });
              },
              items: marklocationList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sPointTypeName'].toString()),
                  value: item["sPointTypeName"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF255899),
        leading: GestureDetector(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_ios),
            )),
        title: const Text(
          'Mark Points',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150, // Height of the container
              width: 200, // Width of the container
              child: Opacity(
                opacity: 0.9,
                //step3.jpg
                child: Image.asset(
                  'assets/images/markpointheader.jpeg', // Replace 'image_name.png' with your asset image path
                  fit: BoxFit.cover, // Adjust the image fit to cover the container
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Color of the shadow
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Offset of the shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // 'assets/images/favicon.png',
                            Container(
                              margin:
                                  EdgeInsets.only(left: 0, right: 10, top: 10),
                              child: Image.asset(
                                'assets/images/ic_expense.png', // Replace with your image asset path
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
                          padding: const EdgeInsets.only(bottom: 5,top: 10),
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
                              const Text('Point Type',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        _bindMarkLocation(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Sector',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        _bindSector(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Location',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 42,
                            color: Color(0xFFf2f3f5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                focusNode: locationfocus,
                                controller: _locationController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: const InputDecoration(
                                  // labelText: AppStrings.txtMobile,
                                  // border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppPadding.p10),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Description',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            height: 42,
                            //  color: Colors.black12,
                            color: Color(0xFFf2f3f5),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                focusNode: descriptionfocus,
                                controller: _descriptionController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppPadding.p10),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0, right: 2),
                                  child: const Icon(
                                    Icons.forward_sharp,
                                    size: 12,
                                    color: Colors.black54,
                                  )),
                              const Text('Upload Photo',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF707d83),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        //ContainerWithRow(),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFf2f3f5),
                            borderRadius:
                                BorderRadius.circular(10.0), // Border radius
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Click Photo',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black54,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Please clock here to take a photo',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.redAccent,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // SizedBox(width: 10),
                                            // Image(image: AssetImage('assets/images/ic_long_right_arrow.PNG'),
                                            //   width: 15,
                                            //   height: 15,
                                            //   fit: BoxFit.fill,
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 10, top: 5),
                                    child: Image(image: AssetImage('assets/images/ic_camera.PNG'),
                                    width: 40,
                                      height: 40,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              image != null
                                  ? Stack(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullScreenPage(
                                                          child: image!,
                                                          dark: true,
                                                        )));
                                          },
                                          child: Container(
                                              color: Colors.lightGreenAccent,
                                              height: 100,
                                              width: 70,
                                              child: Image.file(
                                                image!,
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                        Positioned(
                                            bottom: 65,
                                            left: 35,
                                            child: IconButton(
                                              onPressed: () {
                                                image = null;
                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ))
                                      ],
                                    )
                                  : Text(
                                      "Photo is required.",
                                      style: TextStyle(color: Colors.red[700]),
                                    )
                            ]),

                        ElevatedButton(
                            onPressed: () async {
                              // random number
                              var random = Random();
                              // Generate an 8-digit random number
                              int randomNumber =
                                  random.nextInt(99999999 - 10000000) +
                                      10000000;
                              DateTime currentDate = DateTime.now();
                              todayDate = DateFormat('dd/MMM/yyyy HH:mm').format(currentDate);

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              iUserTypeCode = prefs.getString('iUserTypeCode');
                              userId = prefs.getString('iUserId');
                              slat = prefs.getDouble('lat');
                              slong = prefs.getDouble('long');

                              var location = _locationController.text;
                              var description = _descriptionController.text;

                              print('---call Api---');
                              print('random number-----$randomNumber');
                              print('_selectedPointId -----$_selectedPointId');
                              print('_selectedBlockId -----$_selectedBlockId');
                              print('location -----$location');
                              print('slat -----$slat');
                              print('slong -----$slong');
                              print('description -----$description');
                              print('uplodedImage -----$uplodedImage');
                              print('todayDate -----$todayDate');
                              print('userId -----$userId');

                              // apply condition
                              if (_formKey.currentState!.validate() &&
                                  location != null &&
                                  _dropDownValueMarkLocation != null &&
                                  _dropDownValueDistric != null && uplodedImage !=null) {

                                //

                                  // var markPointSubmitResponse =
                                  //   await MarkPointSubmitRepo().markpointsubmit(
                                  //       context,
                                  //       randomNumber,
                                  //       _selectedPointId,
                                  //       _selectedBlockId,
                                  //       location,
                                  //       slat,
                                  //       slong,
                                  //       description,
                                  //       uplodedImage,
                                  //       iCompCode,
                                  //       userId);
                                  // print('----699---$markPointSubmitResponse');
                                  //
                                  // result2 = markPointSubmitResponse['Result'];
                                  // msg2 = markPointSubmitResponse['Msg'];

                              } else {
                                if(_dropDownValueMarkLocation==null){
                                  displayToast('select Point Type');
                                }else if(_dropDownValueDistric==null){
                                  displayToast('select sector');
                                }else if(location==""){
                                  displayToast('Enter location');
                                }else if(uplodedImage==null){
                                  displayToast('Pick image');
                                }else{
                                }
                              }
                              if(result2=="1"){
                                  displayToast(msg2);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                  );
                              }else{
                                displayToast(msg2);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF255899), // Hex color code (FF for alpha, followed by RGB)
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

