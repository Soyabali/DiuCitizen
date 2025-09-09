import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/generalFunction.dart';
import '../../../app/loader_helper.dart';
import '../../../services/bindCityzenWardRepo.dart';
import '../../../services/bindComplaintCategory.dart';
import '../../../services/cityzenpostcomplaintRepo.dart';
import '../../resources/app_text_style.dart';
import '../../resources/values_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class OnlineComplaintForm extends StatefulWidget {
  final complaintName;
  final categoryCode;

  OnlineComplaintForm({super.key, this.complaintName, this.categoryCode});

  @override
  State<OnlineComplaintForm> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<OnlineComplaintForm> {

  GeneralFunction generalFunction = GeneralFunction();
  final _formKey = GlobalKey<FormState>();
  File? image;
  String? todayDate;
  var result2,msg2;
  List distList = [];
  var _dropDownValueDistric;
  List stateList = [];
  List blockList = [];
  List marklocationList = [];// bindComplaintSubCategory
  List bindComplaintSubCategory = [];
  List bindComplintWard = [];

  var _dropDownValueWard;
  var _dropDownValueComplaintSubCategory;
  var _selectedValueWard;
  var _selectedbindComplaintSubCategory;
  var _selectedBlockId;
  // Focus
  FocusNode namefieldfocus = FocusNode();
  final distDropdownFocus = GlobalKey();
  // controller
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController landmarkTextEditingController = TextEditingController();
  TextEditingController mentionTextEditingController = TextEditingController();
  // focus
  FocusNode categoryfocus = FocusNode();
  FocusNode addressfocus = FocusNode();
  FocusNode landMarkfocus = FocusNode();
  FocusNode mentionfocus = FocusNode();
  var uplodedImage;


  // get api BindComplaintApi

  marklocationData() async {
    bindComplaintSubCategory = await BindComplaintSubCategoryRepo().getbindcomplaintSub("${widget.categoryCode}");
    print(" -----xxxxx-  bindComplaintSubCategory--- Data--51---> $marklocationList");
    setState(() {});
  }
  // bindCityzenWard
  bindCityzenData() async {
    bindComplintWard = await BindCityzenWardRepo().getbindWard(context);
    print(" -----xxxxx-  bindComplaintWard--- 62---> $bindComplintWard");
    setState(() {});
  }

  //

  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      // Create a multipart request
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://upegov.in/purionecitizenapi/api/PostImage/PostImage'));

      // Add headers
      request.headers['token'] = token;
      request.headers['sFolder'] = "CompImage";

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file', imageFile.path,
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
      print('----174--  xxxxx-$uplodedImage');
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }



  // PickImage
  Future pickImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---Token----128---xxxxx----$sToken');

    try {
      final pickFileid = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 20);
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print(' Proof-------135----->$image');
        // multipartProdecudre();
        uploadImage(sToken!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  /// Todo bind SubCategory
  Widget _bindSubCategory() {
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
                text: TextSpan(
                  text: "Select Sub Category",
                  style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
                  children: <TextSpan>[
                    TextSpan(
                      text: '',
                      style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
                    ),
                  ],
                ),
              ),
              value: _dropDownValueComplaintSubCategory,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueComplaintSubCategory = newValue;
                  print('---131---D Ca--$_dropDownValueComplaintSubCategory');
                  bindComplaintSubCategory.forEach((element) {
                    if (element["sSubCategoryName"] == _dropDownValueComplaintSubCategory) {
                      setState(() {
                        _selectedbindComplaintSubCategory = element['iSubCategoryCode'];
                        print('----xxxx C VALUE ---$_selectedbindComplaintSubCategory');
                      });
                    }
                  });
                });
              },
              items: bindComplaintSubCategory.map((dynamic item) {
                return DropdownMenuItem(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      item['sSubCategoryName'].toString(),
                    ),
                  ),
                  value: item["iSubCategoryCode"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
  // bindi ward
  Widget _bindWard() {
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
                text: TextSpan(
                  text: "Select Ward",
                  style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: AppTextStyle
                            .font14penSansExtraboldBlack45TextStyle),
                  ],
                ),
              ), // Not necessary for Option 1
              value: _dropDownValueWard,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueWard = newValue;
                  print('---33-------$_dropDownValueWard');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  bindComplintWard.forEach((element) {
                    if (element["sWardName"] == _dropDownValueWard) {
                      setState(() {
                        _selectedValueWard = element['sWardCode'];
                        print('----Selectred Ward---198--------$_selectedValueWard');
                      });
                      print('-----Point id----241---$_selectedValueWard');
                      if (_selectedValueWard != null) {
                        // updatedBlock();
                        print('-----Point id----244---$_selectedValueWard');
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
              items: bindComplintWard.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sWardName'].toString()),
                  value: item["sWardCode"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    marklocationData();
    bindCityzenData();
    categoryfocus = FocusNode();
    addressfocus = FocusNode();
    landMarkfocus = FocusNode();
    mentionfocus = FocusNode();
    super.initState();
   // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    categoryfocus.dispose();
    addressfocus.dispose();
    landMarkfocus.dispose();
    mentionfocus.dispose();

   // BackButtonInterceptor.remove(myInterceptor);

    super.dispose();
  }
  // toast
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context,'${widget.complaintName}'),
      drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),

      body: ListView(
        children: <Widget>[
          middleHeader(context, '${widget.complaintName}'),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15,bottom: 20),
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
              padding: const EdgeInsets.only(left: 15, right: 15,bottom: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 0, right: 10, top: 10),
                            child: Image.asset(
                              'assets/images/ic_expense.png', // Replace with your image asset path
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Fill the below details',
                                style: AppTextStyle
                                    .font16penSansExtraboldBlack45TextStyle),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                  color: Colors.black54
                              ),
                            ),
                            SizedBox(width: 5),
                            // Container(
                            //     margin: const EdgeInsets.only(
                            //         left: 0, right: 2, bottom: 2),
                            //     child: const Icon(
                            //       Icons.forward_sharp,
                            //       size: 12,
                            //       color: Colors.black54,
                            //     )),
                            Text('Category',
                                style: AppTextStyle
                                    .font14penSansExtraboldBlack45TextStyle),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 5),
                            Text('${widget.complaintName}',
                                style: AppTextStyle
                                    .font14penSansExtraboldBlack45TextStyle),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54
                              ),
                            ),
                            SizedBox(width: 5),
                            // Container(
                            //     margin: EdgeInsets.only(left: 0, right: 2),
                            //     child: const Icon(
                            //       Icons.forward_sharp,
                            //       size: 12,
                            //       color: Colors.black54,
                            //     )),
                            Text('Sub Category',
                                style: AppTextStyle
                                    .font14penSansExtraboldBlack45TextStyle),
                          ],
                        ),
                      ),
                      _bindSubCategory(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54
                              ),
                            ),
                            SizedBox(width: 5),
                            // Container(
                            //     margin: EdgeInsets.only(left: 0, right: 2),
                            //     child: const Icon(
                            //       Icons.forward_sharp,
                            //       size: 12,
                            //       color: Colors.black54,
                            //     )),
                            Text('Ward',
                                style: AppTextStyle
                                    .font14penSansExtraboldBlack45TextStyle),
                          ],
                        ),
                      ),
                      _bindWard(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54
                              ),
                            ),
                            SizedBox(width: 5),
                            // Container(
                            //     margin: EdgeInsets.only(left: 0, right: 2),
                            //     child: const Icon(
                            //       Icons.forward_sharp,
                            //       size: 12,
                            //       color: Colors.black54,
                            //     )),
                            Text('Address',
                                style: AppTextStyle
                                    .font14penSansExtraboldBlack45TextStyle),
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
                              focusNode: addressfocus,
                              controller: addressTextEditingController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                // labelText: AppStrings.txtMobile,
                                // border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: AppPadding.p10),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Enter location';
                              //   }
                              //   return null;
                              // },
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
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54
                              ),
                            ),
                            SizedBox(width: 5),
                            // Container(
                            //     margin: EdgeInsets.only(left: 0, right: 2),
                            //     child: const Icon(
                            //       Icons.forward_sharp,
                            //       size: 12,
                            //       color: Colors.black54,
                            //     )),
                            Text('Landmark',
                                style: AppTextStyle
                                    .font14penSansExtraboldBlack45TextStyle),
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
                              focusNode: landMarkfocus,
                              controller: landmarkTextEditingController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                // labelText: AppStrings.txtMobile,
                                //  border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: AppPadding.p10),
                                //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Enter Description';
                              //   }
                              //   return null;
                              // },
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
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54
                              ),
                            ),
                            SizedBox(width: 5),
                            // Container(
                            //     margin: EdgeInsets.only(left: 0, right: 2),
                            //     child: const Icon(
                            //       Icons.forward_sharp,
                            //       size: 12,
                            //       color: Colors.black54,
                            //     )),
                            Text('Mention your concerns here',
                                style: AppTextStyle
                                    .font14penSansExtraboldBlack45TextStyle),
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
                              focusNode: mentionfocus,
                              controller: mentionTextEditingController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                // labelText: AppStrings.txtMobile,
                                //  border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: AppPadding.p10),
                                //prefixIcon: Icon(Icons.phone,color:Color(0xFF255899),),
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Enter Description';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFf2f3f5),
                          //color: Colors.blueGrey,
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        'Please click here to take a photo',
                                        style: AppTextStyle
                                            .font12penSansExtraboldRedTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // pickImage();
                                  // _getImageFromCamera();
                                  pickImage();
                                  print('---------530-----');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 10, top: 5),
                                  //child: Image(image: AssetImage('assets/images/ic_camera.PNG'),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/ic_camera.PNG'),
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
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
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             FullScreenPage(
                                          //               child: image!,
                                          //               dark: true,
                                          //             )));
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
                                : Text("",
                                    style: AppTextStyle
                                        .font14penSansExtraboldRedTextStyle),
                          ]),
                      SizedBox(height: 0),
                      ElevatedButton(
                          onPressed: () async {

                            var random = Random();
                            // Generate an 8-digit random number
                            int randomNumber = random.nextInt(99999999 - 10000000) + 10000000;
                            print('Random 8-digit number---770--: $randomNumber');

                            var address = addressTextEditingController.text;
                            var landmark = landmarkTextEditingController.text;
                            var mention = mentionTextEditingController.text;

                            print('---address--$address');
                            print('---landmark--$landmark');
                            print('---mention--$mention');
                            print('--DropDownSubCategory--$_dropDownValueComplaintSubCategory');
                            print('--DropDownward-----$_dropDownValueWard');// uplodedImage
                            print('--uplodedImage-----$uplodedImage');// randomNumber
                            print('--randomNumber-----$randomNumber');
                            print('--images-----$randomNumber');

                            if (_formKey.currentState!.validate() &&
                                _dropDownValueComplaintSubCategory !=null &&
                                _dropDownValueWard !=null &&
                                address != null &&
                                landmark != null &&
                                mention !=null &&
                                uplodedImage !=null
                            ) {

                              var markPointSubmitResponse =
                              await MarkPointSubmitRepo().markpointsubmit(
                                  context,
                                  randomNumber,
                                  address,
                                  landmark,
                                  mention,
                                  _dropDownValueComplaintSubCategory,
                                  _dropDownValueWard,
                                  uplodedImage
                              );

                              print('----805---$markPointSubmitResponse');
                               result2 = markPointSubmitResponse['Result'];
                               print('---result---xxx---$result2');
                               msg2 = markPointSubmitResponse['Msg'];

                            } else {
                              print('---call Api not call---');
                              if(_dropDownValueComplaintSubCategory==null){
                                displayToast('select Category');
                              }else if(_dropDownValueWard==null){
                                displayToast('select Ward');
                              }else if(address==""){
                                displayToast('Enter Address');
                              }else if(uplodedImage==null){
                                displayToast('Pick a Image');
                              }else{

                              }
                            }
                            if(result2=="1"){
                              print('------823----xxxxxxxxxxxxxxx----');
                              print('------823---result2  -xxxxxxxxxxxxxxx--$result2');
                              displayToast(msg2);
                              Navigator.pop(context);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const HomePage()),
                              // );
                            }else{

                              displayToast(msg2);
                            }

                            /// Todo next Apply condition
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                                0xFF255899), // Hex color code (FF for alpha, followed by RGB)
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          )
                      )

                      // ElevatedButton(
                      //     onPressed: () async {
                      //       // random number
                      //       var random = Random();
                      //       // Generate an 8-digit random number
                      //       int randomNumber = random.nextInt(
                      //           99999999 - 10000000) + 10000000;
                      //       print(
                      //           'Random 8-digit number---770--: $randomNumber');
                      //
                      //       DateTime currentDate = DateTime.now();
                      //       todayDate = DateFormat('dd/MMM/yyyy HH:mm').format(
                      //           currentDate);
                      //
                      //       // SharedPreferences prefs =
                      //       // await SharedPreferences.getInstance();
                      //       // iUserTypeCode = prefs.getString('iUserTypeCode');
                      //       // userId = prefs.getString('iUserId');
                      //       // slat = prefs.getDouble('lat');
                      //       // slong = prefs.getDouble('long');
                      //       // print('--774--lati--$slat');
                      //       // print('--775--longitude--$slong');
                      //
                      //       var category = categoryTextEditingController.text;
                      //       var address = addressTextEditingController.text;
                      //       var landmark = landmarkTextEditingController.text;
                      //       var mention = mentionTextEditingController.text;
                      //       print('-category---$category');
                      //       print('-address---$address');
                      //       print('-landmark---$landmark');
                      //       print('-mention---$mention');
                      //
                      //
                      //       // apply condition
                      //       if (_formKey.currentState!.validate() &&
                      //           category != null &&
                      //           address != null &&
                      //           landmark != null &&
                      //           mention != null) {
                      //         print('-category---$category');
                      //         print('-address---$address');
                      //         print('-landmark---$landmark');
                      //         print('-mention---$mention');
                      //         print('-randomNumber---$randomNumber');
                      //
                      //
                      //         print('---call Api---');
                      //         var markPointSubmitResponse =
                      //         await MarkPointSubmitRepo().markpointsubmit(
                      //             context,
                      //             randomNumber,
                      //             _dropDownValueComplaintSubCategory,
                      //             _selectedValueWard,
                      //             location,
                      //             slat,
                      //             slong,
                      //             description,
                      //             uplodedImage,
                      //             todayDate,
                      //             userId);
                      //         print('----760---$markPointSubmitResponse');
                      //         result2 = markPointSubmitResponse['Result'];
                      //         msg2 = markPointSubmitResponse['Msg'];
                      //         print('---806---xxxxx----$result2');
                      //         //print('---807--$msg');
                      //         //
                      //
                      //       } else {
                      //         if (_dropDownValueComplaintSubCategory == null) {
                      //           displayToast('select Sub Category');
                      //         } else if (_dropDownValueDistric == null) {
                      //           displayToast('select sector');
                      //           // }else if(location==""){
                      //           //   displayToast('Enter location');
                      //           // }else if(uplodedImage==null){
                      //           //   displayToast('Pick image');
                      //           // }else{
                      //           // }
                      //         }
                      //         if (result2 == "1") {
                      //           print('------823----xxxxxxxxxxxxxxx----');
                      //           print(
                      //               '------823---result2  -xxxxxxxxxxxxxxx--$result2');
                      //           displayToast(msg2);
                      //           //Navigator.pop(context);
                      //           // Navigator.push(
                      //           //   context,
                      //           //   MaterialPageRoute(
                      //           //       builder: (context) => const HomePage()),
                      //           // );
                      //         } else {
                      //           displayToast(msg2);
                      //         }
                      //
                      //         /// Todo next Apply condition
                      //       }
                      //       style:
                      //       ElevatedButton.styleFrom(
                      //         backgroundColor: Color(
                      //             0xFF255899), // Hex color code (FF for alpha, followed by RGB)
                      //       );
                      //       child:
                      //       const Text(
                      //         "Submit",
                      //         style: TextStyle(
                      //             fontFamily: 'Montserrat',
                      //             color: Colors.white,
                      //             fontSize: 16.0,
                      //             fontWeight: FontWeight.bold),
                      //       );
                      //     }
                      //     )
                    ]
                  )


                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10),
                      //   child: Center(
                      //     child: Container(
                      //       height: 45,
                      //       decoration: BoxDecoration(
                      //         color: Colors.red,
                      //         // Background color of the container
                      //         borderRadius: BorderRadius.circular(28.0),
                      //         // Circular border radius
                      //         border: Border.all(
                      //           color: Colors.yellow, // Border color
                      //           width: 0.5, // Border width
                      //         ),
                      //       ),
                      //       child: ElevatedButton(
                      //           onPressed: () async {
                      //             var random = Random();
                      //             int randomNumber = random.nextInt(99999999 - 10000000) + 10000000;
                      //
                      //             var category = categoryTextEditingController.text;
                      //             var address = addressTextEditingController.text;
                      //             var landmark = landmarkTextEditingController.text;
                      //             var mention = mentionTextEditingController.text;
                      //             // ward value --  _dropDownValueWard
                      //             // category value -- _dropDownValueComplaintSubCategory
                      //             // image ----  image
                      //
                      //             // apply condition
                      //             print('--category----739--$category');
                      //             print('--address-----740---$address');
                      //             print('--landmark---741---$landmark');
                      //             print('--mention----742---$mention');
                      //             print('--dropdownvalueCategory----743---$_dropDownValueComplaintSubCategory');
                      //             print('--_dropDownValueWard----744---$_dropDownValueWard');
                      //             print('---RanddomNumber----745----$randomNumber');
                      //
                      //             if (_formKey.currentState!.validate() &&
                      //                 category != null &&
                      //                 address != null &&
                      //                 landmark != null &&
                      //                 mention !=null &&
                      //                 _dropDownValueComplaintSubCategory !=null&&
                      //                 _dropDownValueWard !=null
                      //             ) {
                      //               print('---call Api---');
                      //                var markPointSubmitResponse =
                      //                await MarkPointSubmitRepo().markpointsubmit(
                      //                    context,
                      //                    randomNumber,
                      //                    category,
                      //                    _dropDownValueComplaintSubCategory,
                      //                    _dropDownValueWard,
                      //                    address,
                      //                    landmark,
                      //                    mention,
                      //                    image,
                      //                );
                      //               print('----699---$markPointSubmitResponse');
                      //
                      //               // var cityzenpostResponse =
                      //               // await CityzenPostComplaintRepo().cityzenPostComplaint(
                      //               //     context,
                      //               //     random,
                      //               //     category,
                      //               //     _dropDownValueComplaintSubCategory,
                      //               //     _dropDownValueWard,
                      //               //     address,
                      //               //     landmark,
                      //               //     mention,
                      //               //     image
                      //               //     );
                      //
                      //
                      //               // print('----699---$cityzenpostResponse');
                      //               // result2 = markPointSubmitResponse['Result'];
                      //               // msg2 = markPointSubmitResponse['Msg'];
                      //
                      //             } else {
                      //               // if(_dropDownValueMarkLocation==null){
                      //               //   displayToast('select Point Type');
                      //               // }else if(_dropDownValueDistric==null){
                      //               //   displayToast('select sector');
                      //               // }else if(location==""){
                      //               //   displayToast('Enter location');
                      //               // }else if(uplodedImage==null){
                      //               //   displayToast('Pick image');
                      //               // }else{
                      //               // }
                      //             }
                      //             // if(result2=="1"){
                      //             //   displayToast(msg2);
                      //             //   Navigator.push(
                      //             //     context,
                      //             //     MaterialPageRoute(
                      //             //         builder: (context) => const HomePage()),
                      //             //   );
                      //             // }else{
                      //             //   displayToast(msg2);
                      //             // }
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: const Color(
                      //                 0xFF255899), // Hex color code (FF for alpha, followed by RGB)
                      //           ),
                      //           child: const Text(
                      //             "Submit",
                      //             style: TextStyle(
                      //                 fontFamily: 'Montserrat',
                      //                 color: Colors.white,
                      //                 fontSize: 16.0,
                      //                 fontWeight: FontWeight.bold),
                      //           )),
                      //
                      //     ),
                      //   ),
                      // ),




                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}
