import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';
import '../app/generalFunction.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import 'cookipage.dart';

class TempleGallery extends StatefulWidget {

  TempleGallery({super.key,});

  @override
  State<TempleGallery> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<TempleGallery> with SingleTickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     // appBar: getAppBar("GALLERY"),
      appBar: getAppBarBack("GALLERY"),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/cityelementone.png',
                            // Replace with your first image path
                            height: 50.0,
                            width: 50.0,
                          ),
                          Spacer(),
                          Image.asset(
                            'assets/images/listelementtop.png',
                            // Replace with your second image path
                            height: 50.0,
                            width: 50.0,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.transparent,
                            labelColor: Color(0xFFC88D67),
                            isScrollable:true,
                            labelPadding: EdgeInsets.only(right: 45.0),
                            unselectedLabelColor: Color(0xFFCDCDCD),
                            tabs: const [
                              Tab(
                                child: Text('PHOTOS',
                                  style: TextStyle(
                                    fontFamily:'Verela',
                                    fontSize: 21.0 ,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text('VIDEOS',
                                  style: TextStyle(
                                    fontFamily:'Verela',
                                    fontSize: 21.0 ,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Positioned(
                        top: 80,
                        child: Image.asset('assets/images/templelement2.png',
                            // Replace with your first image path
                            height: 50.0,
                            width: MediaQuery.of(context).size.width),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 50.0,
            width:  double.infinity,
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                /// here you put gallery code
                CookiePage(),
                CookiePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
