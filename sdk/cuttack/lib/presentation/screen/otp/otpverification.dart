import 'package:cuttack/presentation/resources/routes_manager.dart';
import 'package:cuttack/presentation/resources/strings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../home/homeScreen.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_text_style.dart';
import '../../resources/assets_manager.dart';
import '../../resources/values_manager.dart';

class OtpPage extends StatefulWidget {
  //final phone;
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<OtpPage> {

  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController>? controllers;
  List<FocusNode>? focusNodes;
  bool _isObscured = true;
  bool _isObscurednewpassword = true;
  FocusNode _newPasswordfocus = FocusNode();
  FocusNode _confirmpasswordfoucs = FocusNode();
  var otpverificationResponse;
  var result ;
  var msg ;

  void clearText() {
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('------71----${widget.phone}');
    _newPasswordfocus = FocusNode();
    _confirmpasswordfoucs = FocusNode();
    controllers = List.generate(4, (_) => TextEditingController());
    focusNodes = List.generate(4, (_) => FocusNode());
    focusNodes?[0].requestFocus();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _newPasswordfocus.dispose();
    _confirmpasswordfoucs.dispose();
    for (var controller in controllers!) {
      controller.dispose();
    }
    for (var node in focusNodes!) {
      node.dispose();
    }
    super.dispose();
  }
  // Toast msg
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
//
  final TextEditingController _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer
        body:  Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppSize.s20),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: AppSize.s75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(AppSize.s10),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageAssets.solidCircleIc), // Replace with your image asset path
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: AppSize.s50,
                          height: AppSize.s50,
                          child: Image.asset(ImageAssets.cuttackmani, // Replace with your image asset path
                            width: AppSize.s50,
                            height: AppSize.s50,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: AppSize.s10),
                          child: Container(
                            margin: EdgeInsets.all(AppSize.s10),
                            child: Image.asset(
                              ImageAssets.cuttack,
                              width: AppSize.s50,
                              height: AppSize.s50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  AppStrings.otpVerification,
                                  style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: AppSize.s60),
                              Container(
                                //color: Colors.white,
                                height: 300,
                                decoration: BoxDecoration(
                                  // Set container color
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(20), // Set border radius
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 10.0),
                                        Center(
                                          child: Card(
                                            elevation: 5,
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(40),
                                                // border: Border.all(color: Colors.black),
                                                // Just for visualization
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white.withOpacity(0.5), // Set shadow color
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.phone,
                                                size: 35,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(AppStrings.otpmessage,style: Theme.of(context).textTheme.titleSmall),
                                        Text('+91 9871950881',style: Theme.of(context).textTheme.titleMedium),
                                        SizedBox(height: 0),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: List.generate(4, (index) {
                                              return SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 5, top: 0),
                                                  child: Center(
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: TextField(
                                                        controller: controllers?[index],
                                                        focusNode: focusNodes?[index],
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(1),
                                                        ],
                                                        onChanged: (value) {
                                                          if (value.isNotEmpty &&
                                                              index < 3) {
                                                            FocusScope.of(context)
                                                                .requestFocus(focusNodes?[
                                                            index + 1]);
                                                          } else if (value.isEmpty &&
                                                              index > 0) {
                                                            FocusScope.of(context)
                                                                .requestFocus(focusNodes?[
                                                            index - 1]);
                                                          }
                                                        },
                                                        // maxLength: 1,
                                                        textAlign: TextAlign.center,
                                                        keyboardType: TextInputType.number,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: MediaQuery.of(context).size.width-AppPadding.p30,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                // print('----271---');
                                                // Add your button press logic here
                                                String otp = '';
                                                for (var controller in controllers!)
                                                {
                                                  otp += controller.text;
                                                }
                                                // Now you have the OTP value in the 'otp' variable
                                                print('OTP---319: $otp');
                                                // route--
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context)
                                                  => HomePage()),
                                                );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.green), // Background color
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                  EdgeInsets.symmetric(vertical: AppPadding.p15, horizontal: AppPadding.p30), // Padding
                                                ),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(AppPadding.p10), // Border radius
                                                  ),
                                                ),
                                              ),
                                              child: Text(AppStrings.register, style:AppTextStyle.font16PoppinsWhiteRegular)),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(AppStrings.powerby,style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(AppStrings.companyName,
                            style:AppTextStyle.font18PoppinsC77962Regular,
                          ),
                          SizedBox(width: AppSize.s5),
                          Container(
                            width: AppSize.s25,
                            height: AppSize.s25,
                            //BoxDecoration Widget
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(ImageAssets.favicon),
                                fit: BoxFit.cover,
                              ), //DecorationImage
                              border: Border.all(
                                color: Colors.grey,
                                width: AppPadding.p1,
                              ), //Border.all
                              borderRadius: BorderRadius.circular(AppPadding.p15),
                            ), //BoxDecoration
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}
