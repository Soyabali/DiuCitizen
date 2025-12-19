
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/generalFunction.dart';
import '../../services/loginRepo.dart';
import '../otp/otpverification.dart';
import '../registration/registration.dart';
import '../resources/app_strings.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';


class LoginScreen_2 extends StatelessWidget {
  const LoginScreen_2({super.key});

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
  final _formKey = GlobalKey<FormState>();
  // focus
  FocusNode phoneNumberfocus = FocusNode();
  var msg;
  var result;
  var loginMap;
   //double? lat, long;
  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    super.dispose();
  }
  void clearText() {
    _phoneNumberController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pop Screen Disabled.'),
            backgroundColor: Colors.red,
          ),
        );
        return false; // Prevent the back button action
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(AppMargin.m10),
                            width: AppSize.s50,
                            height: AppSize.s50,
                            child: Image.asset(
                              ImageAssets.logintopleft,
                              width: AppSize.s50,
                              height: AppSize.s50,
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            margin: const EdgeInsets.all(AppMargin.m10),
                            width: AppSize.s50,
                            height: AppSize.s50,
                            child: Image.asset(
                              ImageAssets.toprightlogin,
                              width: AppSize.s50,
                              height: AppSize.s50,
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
                               width: AppSize.s145,
                              height: AppSize.s145,
                              fit: BoxFit.contain, // Adjust as needed
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Align(
                          alignment: Alignment.centerLeft, // Align to the left
                          child: Text(
                            AppStrings.txtLogin,
                            style: AppTextStyle.font14penSansBlackTextStyle,
                          ),
                        ),
                      ),
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13,right: 13),
                                      child: InkWell(
                                        onTap: () async {
                                          String phone = _phoneNumberController.text.trim();

                                          // 1️⃣ Empty check
                                          if (phone.isEmpty) {
                                            displayToast("Please enter mobile number");
                                            phoneNumberfocus.requestFocus();
                                            return;
                                          }

                                          // 2️⃣ Length validation (MAIN REQUIREMENT)
                                          if (phone.length < 10) {
                                            displayToast("Please enter minimum 10 digit number");
                                            phoneNumberfocus.requestFocus();
                                            return;
                                          }

                                          // 3️⃣ Optional: form validation
                                          if (!_formKey.currentState!.validate()) {
                                            return;
                                          }

                                          // 4️⃣ Call API only when phone is valid
                                          loginMap = await LoginRepo().login(context, phone);
                                          print("------299---$loginMap");

                                          result = "${loginMap['Result']}";
                                          msg = "${loginMap['Msg']}";

                                          // 5️⃣ API response handling
                                          if (result == "1") {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OtpPage(phone: phone),
                                              ),
                                                  (Route<dynamic> route) => false,
                                            );
                                          } else {
                                            displayToast(msg);
                                          }
                                        },

                                        // onTap: () async {
                                        //   var phone = _phoneNumberController.text;
                                        //   if(_formKey.currentState!.validate() && phone != null && phone!='') {
                                        //     // Call Api
                                        //     loginMap = await LoginRepo().login(context, phone);
                                        //     print("------299---$loginMap");
                                        //     result = "${loginMap['Result']}";
                                        //     msg = "${loginMap['Msg']}";
                                        //   }else{
                                        //     if(_phoneNumberController.text.isEmpty){
                                        //       phoneNumberfocus.requestFocus();
                                        //     }
                                        //   } // condition to fetch a response form a api
                                        //   if(result=="1"){
                                        //
                                        //     Navigator.pushAndRemoveUntil(
                                        //       context,
                                        //       MaterialPageRoute(builder: (context) => OtpPage(phone:phone)),
                                        //           (Route<dynamic> route) => false, // This condition removes all previous routes
                                        //     );
                                        //
                                        //   }else{
                                        //     displayToast(msg);
                                        //
                                        //   }
                                        // },
                                        child: Container(
                                          width: double.infinity, // Make container fill the width of its parent
                                          height: AppSize.s45,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF255899), // Background color using HEX value
                                            borderRadius: BorderRadius.circular(
                                                AppMargin.m10), // Rounded corners
                                          ),
                                          child: const Center(
                                            child: Text(
                                              AppStrings.txtLogin,
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
                                            Container(
                                              child: Text(
                                                "If you are a new user ?",
                                                style: AppTextStyle.font14penSansBlackTextStyle,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                // Registration
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const Registration()),
                                                );

                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.0), // 10dp padding around the text
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Color(0xFF255899)), // Gray border color
                                                  borderRadius: BorderRadius.circular(8.0), // Rounded corners for the border
                                                ),
                                                child: Text(
                                                  "Register Here",
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
                )),
          )),
    );
  }
  // toast code
}

