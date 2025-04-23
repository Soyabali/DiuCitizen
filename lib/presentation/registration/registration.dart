
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/citizenRegistrationRepo.dart';
import '../login/loginScreen_2.dart';
import '../otp/otpverification.dart';
import '../resources/app_strings.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Registration extends StatelessWidget {

  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegistrationPage> {

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _userController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  var loginProvider;

  // focus
  FocusNode phoneNumberfocus = FocusNode();
  FocusNode userfocus = FocusNode();

  bool passwordVisible = false;
  // Visible and Unvisble value
  int selectedId = 0;
  var msg;
  var result;
  var loginMap;
  double? lat, long;
  GeneralFunction generalFunction = GeneralFunction();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getLocation();
    Future.delayed(const Duration(milliseconds: 100), () {
      // requestLocationPermission();
      setState(() {
        // Here you can write your code for open new view
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    _userController.dispose();
    super.dispose();
  }
  void clearText() {
    _phoneNumberController.clear();
    _userController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // mention all widget here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(AppMargin.m10),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(ImageAssets.roundcircle), // Replace with your image asset path
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: AppSize.s50,
                            height: AppSize.s50,
                            child: Image.asset(
                              "assets/images/dmc_logo.png",
                              // ImageAssets.noidaauthoritylogo, // Replace with your image asset path
                              width: AppSize.s50,
                              height: AppSize.s50,
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Image.asset(
                                "assets/images/daman_state_logo.png", // Replace with your image asset path
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: AppSize.s145,
                        width: AppSize.s145,
                        margin: const EdgeInsets.all(AppMargin.m20),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              ImageAssets.roundcircle,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppMargin.m16),
                          child: Center(
                            child: Image.asset(
                              "assets/images/Diu_icon-02.png",
                              //"assets/images/ic_launcher.png",
                             // ImageAssets.iclauncher, // Replace with your image asset path
                              width: AppSize.s145,
                              height: AppSize.s145,
                              fit: BoxFit.contain, // Adjust as needed
                            ),
                            // child: Image.asset(
                            //   "assets/images/home.png",
                            //   //ImageAssets.loginIcon, // Replace with your image asset path
                            //   width: AppSize.s145,
                            //   height: AppSize.s145,
                            //   fit: BoxFit.contain, // Adjust as needed
                            // ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Align(
                          alignment: Alignment.centerLeft, // Align to the left
                          child: Text(
                            "Registration",
                            style: AppTextStyle.font14penSansBlackTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      /// Todo here we mention main code for a login ui.
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppPadding.p15, right: AppPadding.p15),
                                      // PHONE NUMBER TextField
                                      child: TextFormField(
                                        focusNode: userfocus,
                                        controller: _userController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                       // keyboardType: TextInputType.phone,
                                        //inputFormatters: [LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                       // ],
                                        decoration: const InputDecoration(
                                          labelText: "User Name",
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: AppPadding.p10,
                                            horizontal: AppPadding.p10, // Add horizontal padding
                                          ),

                                          prefixIcon: Icon(
                                            Icons.how_to_reg,
                                            color: Color(0xFF255899),
                                          ),
                                          // errorBorder
                                          // errorBorder: OutlineInputBorder(
                                          //     borderSide: BorderSide(color: Colors.green, width: 0.5))
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return 'Enter User Name';
                                        //   }
                                        //   // if (value.length > 1 && value.length < 10) {
                                        //   //   return 'Enter 10 digit mobile number';
                                        //   // }
                                        //   return null;
                                        // },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppPadding.p15, right: AppPadding.p15),
                                      // PHONE NUMBER TextField
                                      child: TextFormField(
                                        focusNode: phoneNumberfocus,
                                        controller: _phoneNumberController,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                        ],
                                        decoration: const InputDecoration(
                                          labelText: AppStrings.txtMobile,
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: AppPadding.p10,
                                            horizontal: AppPadding.p10, // Add horizontal padding
                                          ),

                                          prefixIcon: Icon(
                                            Icons.phone,
                                            color: Color(0xFF255899),
                                          ),
                                          // errorBorder
                                          // errorBorder: OutlineInputBorder(
                                          //     borderSide: BorderSide(color: Colors.green, width: 0.5))
                                        ),
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return 'Enter mobile number';
                                        //   }
                                        //   if (value.length > 1 && value.length < 10) {
                                        //     return 'Enter 10 digit mobile number';
                                        //   }
                                        //   return null;
                                        // },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13,right: 13),
                                      child: InkWell(
                                        onTap: () async {
                                           var name = _userController.text.trim();
                                          var phone = _phoneNumberController.text.trim();

                                          if(_formKey.currentState!.validate() && name.isNotEmpty && phone.isNotEmpty){
                                            // Call Api
                                            loginMap = await CitizenRegistrationRepo().citizenRegistration(context, name!, phone);

                                            print('---358----$loginMap');
                                            result = "${loginMap['Result']}";
                                            msg = "${loginMap['Msg']}";
                                            print('---361----$result');
                                            print('---362----$msg');
                                          }else{
                                            if(name.isEmpty){
                                             displayToast("Please Enter Name");
                                             return;
                                            } if(phone.isEmpty){
                                              displayToast("Please Enter Mobile Number");
                                            }
                                          } // condition to fetch a response form a api
                                          if(result=="1"){

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => OtpPage(phone:phone)),
                                            );

                                          }else{
                                            print('----373---To display error msg---');
                                            displayToast(msg);

                                          }
                                        },

                                        child: Container(
                                          width: double.infinity, // Make container fill the width of its parent
                                          height: AppSize.s45,
                                          //  padding: EdgeInsets.all(AppPadding.p5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF255899), // Background color using HEX value
                                            borderRadius: BorderRadius.circular(
                                                AppMargin.m10), // Rounded corners
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Sign up",
                                              style: TextStyle(
                                                  fontSize: AppSize.s16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13,right: 13),
                                      child: Container(
                                        height: 45,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between texts
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(builder: (context) => OtpPage(phone: "987195081",)),
                                                // );
                                              },
                                              child: Container(
                                                child: Text(
                                                  "Already a user ?",
                                                  style: AppTextStyle.font14penSansBlackTextStyle,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                // Registration
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const LoginScreen_2()),
                                                );

                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.0), // 10dp padding around the text
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Color(0xFF255899)), // Gray border color
                                                  borderRadius: BorderRadius.circular(8.0), // Rounded corners for the border
                                                ),
                                                child: Text(
                                                  "Login",
                                                  style: AppTextStyle.font14penSansBlackTextStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
      ),
    );
  }
  // toast code
  void displayToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
