import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../app/generalFunction.dart';
import '../../services/login_repo.dart';
import '../homepage/homepage.dart';
import '../login/loginScreen_2.dart';
import '../otp/otpverification.dart';
import '../resources/app_text_style.dart';
import '../resources/custom_elevated_button.dart';
import '../resources/values_manager.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  var loginProvider;

  // focus
  FocusNode phoneNumberfocus = FocusNode();
  FocusNode namefocus = FocusNode();

  bool passwordVisible = false;

  // Visible and Unvisble value
  int selectedId = 0;
  var msg;
  var result;
  var loginMap;
  double? lat, long;
  GeneralFunction generalFunction = GeneralFunction();

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure?',
              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
            ),
            content: new Text(
              'Do you want to exit app',
              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                //<-- SEE HERE
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  exit(0);
                }, //Navigator.of(context).pop(true), // <-- SEE HERE
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

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
    nameController.dispose();
    super.dispose();
  }

  void clearText() {
    _phoneNumberController.clear();
    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.red,
              elevation: 10,
              shadowColor: Colors.orange,
              toolbarOpacity: 0.5,
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Adjust padding if necessary
                  child: Image.asset(
                    "assets/images/back.png",
                    fit: BoxFit
                        .contain, // BoxFit.contain ensures the image is not distorted
                  ),
                ),
              ),
              title: Text(
                'Registration',
                style: AppTextStyle.font16penSansExtraboldWhiteTextStyle,
              ),
              centerTitle: true,
            ),
            drawer: generalFunction.drawerFunction(
                context, 'Suaib Ali', '9871950881'),
            body: Padding(
              padding: const EdgeInsets.only(top: 25),
              child:Column(
                  children: <Widget>[
                    middleHeaderPuri(context, 'Citizen Services'),
                    Container(
                        height: AppSize.s145,
                        width: MediaQuery.of(context).size.width - 50,
                        margin: const EdgeInsets.all(AppMargin.m20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/temple_3.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Container()),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Form(
                        key: _formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppPadding.p15, right: AppPadding.p15),
                              // PHONE NUMBER TextField
                              child: TextFormField(
                                focusNode: namefocus,
                                controller: nameController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: const InputDecoration(
                                  // labelText: 'Mobile',
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0), // Padding for the label
                                    child: Text('User Name'),
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0),
                                  prefixIcon: Icon(
                                    Icons.account_box,
                                    color: Colors.orange,
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter user number';
                                  }
                                  return null;
                                },
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
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  // Limit to 10 digits
                                  //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow digits
                                ],
                                decoration: const InputDecoration(
                                  // labelText: 'Mobile',
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0), // Padding for the label
                                    child: Text('Mobile No'),
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0),
                                  prefixIcon: Icon(
                                    Icons.call,
                                    color: Colors.orange,
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter mobile number';
                                  }
                                  if (value.length > 1 && value.length < 10) {
                                    return 'Enter 10 digit mobile number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10),

                            ElevatedButton(
                              child: Text('SIGNUP'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shadowColor: Colors.red, // Custom shadow color
                                elevation: 5, // Text color
                              ).copyWith(
                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.yellow; // Splash color when pressed
                                    }
                                    return null; // Default splash color
                                  },
                                )),
                              onPressed: () async {
                                var phone = _phoneNumberController.text;
                                var name = nameController.text;
                                if (_formKey.currentState!.validate() &&
                                    name != null &&
                                    name != null) {
                                  print('----name---$name');
                                  print('----phone---$phone');
                                  print('---call Api---');
                
                                  loginMap = await RegistrationRepo()
                                      .authenticate(context, phone!, name!);
                                  print('-----280---$loginMap');
                                  result = "${loginMap['Result']}";
                                  msg = "${loginMap['Msg']}";
                                  print('----283---msg--$msg');
                                } else {
                                  if (nameController.text.isEmpty) {
                                    namefocus.requestFocus();
                                  } else if (_phoneNumberController
                                      .text.isEmpty) {
                                    phoneNumberfocus.requestFocus();
                                  }
                                }
                                if(result=="1"){
                                            print('----Success---');
                                           // displayToast(msg);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => OtpPage(phone: phone)),
                                            );
                                            Fluttertoast.showToast(
                                                   msg: msg,
                                                   toastLength: Toast.LENGTH_SHORT,
                                                   gravity: ToastGravity.CENTER,
                                                   timeInSecForIosWeb: 1,
                                                   textColor: Colors.white,
                                                   fontSize: 16.0
                                               );
                                }else{
                                  Fluttertoast.showToast(
                                      msg: msg,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              },
                            ),



                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Already a user ?',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 8),
                                  // Add some spacing between the texts
                                  GestureDetector(
                                    onTap: () {
                                      //Handle the click event
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen_2()),
                                      );
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           // SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    // Spacer(),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 80),
                    //   child: Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: Padding(
                    //         padding: EdgeInsets.only(bottom: 5.0, left: 15),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.only(right: 80),
                    //               child: Text('Powered by :',
                    //                   style: AppTextStyle
                    //                       .font14OpenSansRegularBlackTextStyle),
                    //             ),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: <Widget>[
                    //                 const Text(
                    //                   'Synergy Telmatics Pvt.Ltd.',
                    //                   style: TextStyle(
                    //                     fontFamily: 'Montserrat',
                    //                     color: Color(0xffF37339), //#F37339
                    //                     fontSize: 14.0,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //                 SizedBox(width: 10),
                    //                 Padding(
                    //                   padding:
                    //                       EdgeInsets.only(right: AppSize.s10),
                    //                   child: SizedBox(
                    //                     width: 25,
                    //                     height: 25,
                    //                     child: Image.asset(
                    //                       'assets/images/favicon.png',
                    //                       width: 25,
                    //                       height: 25,
                    //                       fit: BoxFit
                    //                           .fill, // Changed BoxFit to fill
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         )),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ));
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$msg'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  // toast code
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
}
