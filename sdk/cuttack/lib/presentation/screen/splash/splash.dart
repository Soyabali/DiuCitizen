
import 'dart:async';

import 'package:cuttack/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import '../../resources/assets_manager.dart';
import '../../resources/values_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplaceState();
}

class _SplaceState extends State<SplashView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2),
            (){
              Navigator.pushReplacementNamed(
                  context, Routes.loginRoute);
            }
            );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplaceScreen(),
    );
  }
}

class SplaceScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: AppSize.s50),
            // Top bar with two images
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
            // Centered image
            Expanded(
              child: Center(
                child: Container(
                  height: AppSize.s160,
                  width: AppSize.s160,
                  margin: EdgeInsets.all(AppMargin.m20),//20
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Container(),
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
