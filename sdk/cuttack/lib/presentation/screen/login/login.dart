
import 'package:cuttack/presentation/resources/routes_manager.dart';
import 'package:cuttack/presentation/screen/otp/otpverification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_text_style.dart';
import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../registration/registration.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  bool _isObscured = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
         Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: AppSize.s18),
                  SizedBox(
                    height: AppSize.s75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(AppMargin.m10),
                          width: AppSize.s50,
                          height: AppSize.s50,
                          child: Image.asset(
                            ImageAssets.cuttackmani, // Replace with your image asset path
                            width: AppSize.s50,
                            height: AppSize.s50,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: AppPadding.p10),
                          child: Container(
                            margin: EdgeInsets.all(AppMargin.m10),
                            child: Image.asset(
                              ImageAssets.cuttack, // Replace with your image asset path
                              width: AppSize.s50,
                              height: AppSize.s50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSize.s18),
                 Container(
                        height: AppSize.s145,
                        width: AppSize.s145,
                        margin: const EdgeInsets.all(AppMargin.m20),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ImageAssets.logo,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppMargin.m16),
                          child: Image.asset(ImageAssets.logo, // Replace with your image asset path
                            width: AppSize.s145,
                            height: AppSize.s145,
                            fit: BoxFit.contain, // Adjust as needed
                          ),
                        ),
                      ),
                  Align(
                   alignment: Alignment.centerLeft,
                   child: Padding(
                     padding: EdgeInsets.only(left: AppPadding.p15),
                     child: Text(AppStrings.login,style:AppTextStyle.font18Poppinscd036A7BBold),
                   ),
                 ),
                  const SizedBox(height: AppSize.s20),
                  // mobile field
                  Padding(
                    padding: const EdgeInsets.only(left: AppPadding.p15,right: AppPadding.p15),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: AppStrings.mobileNumber,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: AppPadding.p10),
                        prefixIcon: Icon(Icons.call,color:AppColors.green,),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  Container(
         width: MediaQuery.of(context).size.width-AppPadding.p30,
        child: ElevatedButton(
          onPressed: () {
            // Otp verification
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OtpPage()),
            );
            // Navigator.pushReplacementNamed(
            //     context, Routes.otpRoute);
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
          child: Text(AppStrings.login, style:AppTextStyle.font16PoppinsWhiteRegular)),
          ),

                  SizedBox(height: AppSize.s10),
                  Padding(
                    padding: EdgeInsets.only(left: AppPadding.p15,right: AppPadding.p15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(AppStrings.newUser,style: Theme.of(context).textTheme.titleMedium),

                        InkWell(
                          onTap: (){
                            print('----Registration--');

                            // Navigator.pushReplacementNamed(
                            //     context, Routes.registerRoute);
                           // Navigator.pushReplacementNamed(context,Routes.registerRoute);
                            // Navigator.pushReplacementNamed(
                            //     context, Routes.registerRoute);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => RegistrationScreen()),
                            );

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              // Background color of the container
                              borderRadius: BorderRadius.circular(5), // Circular shape
                              border: Border.all(
                                color: Colors.black, // Border color
                                width: AppSize.s4, // Border width
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: AppPadding.p15,
                                  right:AppPadding.p15,top: AppPadding.p2,bottom: AppPadding.p2),
                              child: Text(AppStrings.registerhere,style: Theme.of(context).textTheme.titleMedium)),
                            ),
                          ),
                        ],
                    ),
                  ),
                ],
              ),

            Spacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                 Text(AppStrings.powerby,style: Theme.of(context).textTheme.titleMedium)
                ,Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppStrings.companyName,
                      style:AppTextStyle.font18PoppinsC77962Regular,
                    ),
                    SizedBox(width: AppPadding.p5),
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
                    ), //Co
                  ],
                )
              ]),
          ),

        ],
          )

    );
  }
}
