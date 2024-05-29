
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:puri/homepage/homepage.dart';
import '../../resources/app_strings.dart';
import '../../resources/app_text_style.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_managements.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _goNextPage();
  }
  _goNextPage(){
    Future.delayed(Duration(seconds: 2), () {
      // SchedulerBinding.instance?.addPostFrameCallback((_)
      // {
      // //  _appPreferences.setIsUserLoggedIn();
      //   Navigator.of(context).pushReplacementNamed(Routes.homePageRoute);
      // });
     // Navigator.of(context).pushNamed(Routes.homePageRoute);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));

    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomRight,
          children: [
            Opacity(
              opacity: 0.8,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageAssets.templepuri4), // Replace 'background_image.jpg' with your image path
                    fit: BoxFit.cover, // Cover the entire container
                  ),
                ),
              ),
            ),
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                     Container(
                       child: Image.asset(ImageAssets.cityname,
                         height: 200,
                         width: 300,),
                     ),
                     Positioned(
                         child: Text(AppStrings.puriOne,
                           style:AppTextStyle.font30penSansExtraboldWhiteTextStyle,
                         ),
                     )
                ],
              )
            )

          ],
      )
    );
  }
}
