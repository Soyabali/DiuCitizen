import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/resources/app_strings.dart';
import 'package:puri/resources/assets_manager.dart';
import '../resources/app_text_style.dart';
import '../resources/routes_managements.dart';
import '../temples/templehome.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: 0.8,
            child: Container(
              width: MediaQuery.of(context).size.width-50,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(ImageAssets.templepuri4,
              fit: BoxFit.cover,),
            ),
          ),
          Positioned(
            top: 100,
              right: 10,
              left: 10,
              child: Center(
                child: Container(
                   child: Stack(
                     children: <Widget>[
                       Image.asset(ImageAssets.cityname,
                           height: 200),
                               Positioned(
                                 top: 75,
                                 left: 85,
                                 child: Text(AppStrings.puriOne,
                                   style: AppTextStyle.font30penSansExtraboldWhiteTextStyle
                                 )

                               )

                     ],
                   )
                ),
              )
          ),
          Positioned(
            top: 330,
              left: 15,
              right: 15,
              child: Container(
                height: 360,
                width: MediaQuery.of(context).size.width-50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Set the border radius
                  image: const DecorationImage(
                    image: AssetImage(ImageAssets.changecitybackground), // Provide your image path here
                    fit: BoxFit.cover, // Cover the entire container
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                       top: 170,
                      left: 132,
                      right: 100,
                    child: Text("SELECT PLACE", style:AppTextStyle.font14penSansExtraboldWhiteTextStyle)
                      ),
                    Positioned(
                        top: 40,
                        left: 135,
                        right: 40,
                        child: InkWell(
                          onTap: (){
                            print("-----105----");
                           // Navigator.of(context).pushNamed(Routes.templePagehome);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => TemplesHome()),
                            );
                          },
                            child: Text('Temples',
                              style: AppTextStyle.font20penSansExtraboldWhiteTextStyle
                            )
                        )),
                    Positioned(
                        top: 150,
                        left: 10,
                        right: 40,
                        child: InkWell(
                          onTap: (){
                            print('-----114-----');
                          },
                            child: Text('Help Line',
                              style: AppTextStyle.font20penSansExtraboldWhiteTextStyle
                            )
                        )),
                    Positioned(
                        top: 150,
                        right: 5,
                        child: InkWell(
                            onTap: (){
                              print('----122------');
                            },
                            child: Text('Complaints',
                              style: AppTextStyle.font20penSansExtraboldWhiteTextStyle,
                              ))),
                    Positioned(
                        bottom: 70,
                        right: 40,
                        child: InkWell(
                          onTap: (){
                            print('----130------');
                          },
                            child: Text('Near by Place',
                              style: AppTextStyle.font20penSansExtraboldWhiteTextStyle

                            ))),
                    Positioned(
                        bottom: 70,
                        left: 40,
                        child: InkWell(
                          onTap: (){
                            print('----138------');
                          },
                            child: Text('Toilet Locator ',
                              style: AppTextStyle.font20penSansExtraboldWhiteTextStyle,
                              ))),
                  ],
                )
              )
          )

        ],
      )
    );
  }
}

