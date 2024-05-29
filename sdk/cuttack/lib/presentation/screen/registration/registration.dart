import 'package:cuttack/presentation/resources/strings_manager.dart';
import 'package:cuttack/presentation/screen/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_text_style.dart';
import '../../resources/assets_manager.dart';
import '../../resources/values_manager.dart';


class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

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
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: AppPadding.p15),
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
                    const SizedBox(height: AppSize.s15),
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
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: AppPadding.p15),
                              child: Text(AppStrings.registration,
                                  style:AppTextStyle.font18Poppinscd036A7BBold),
                            ),
                          ),
                          const SizedBox(height: AppSize.s20),
                          // name field
                          Padding(
                            padding: const EdgeInsets.only(left: AppPadding.p15,right: AppPadding.p15),
                            child: TextFormField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText:AppStrings.username,        //  "User Name",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: AppPadding.p10),
                                prefixIcon: Icon(Icons.account_box,color:AppColors.green),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSize.s10),
                          // mobile nubmer
                          Padding(
                            padding: const EdgeInsets.only(left: AppPadding.p15,right: AppPadding.p15),
                            child: TextFormField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText:AppStrings.mobileNumber, //      "Mobile Number",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: AppPadding.p10),
                                prefixIcon: Icon(Icons.phone,color:AppColors.green),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSize.s10),
                          Container(
                            width: MediaQuery.of(context).size.width-AppPadding.p30,
                            child: ElevatedButton(
                                onPressed: () {
                                  // Add your button press logic here
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
                          SizedBox(height: AppPadding.p10),
                          Padding(
                            padding: const EdgeInsets.only(left: AppPadding.p15,
                                right: AppPadding.p15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(AppStrings.alreadyUser,
                                    style: Theme.of(context).textTheme.titleMedium),
                                InkWell(
                                  onTap: (){
                                    // Navigator.pushReplacementNamed(
                                    //     context, Routes.loginRoute);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
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
                                      padding: EdgeInsets.only(left: AppPadding.p15,right: AppPadding.p15,top: AppPadding.p2,bottom: AppPadding.p2),
                                      child: Text(AppStrings.signup, style: Theme.of(context).textTheme.titleMedium
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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
         )
      );
  }
}
