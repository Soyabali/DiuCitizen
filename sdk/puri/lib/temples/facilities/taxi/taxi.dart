import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/temples/facilities/taxi/taxiStand.dart';
import 'package:puri/temples/facilities/taxi/taxihome.dart';

class Taxi extends StatefulWidget {
  const Taxi({super.key});

  @override
  State<Taxi> createState() => _FacilitiesHomeState();
}

class _FacilitiesHomeState extends State<Taxi> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  final List<Map<String, String>> itemList = [
    {'image': 'https://www.drishtiias.com/images/uploads/1698053713_image1.png','temple': 'Jagannath Temple'},
    {'image': 'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg','temple': 'PanchaTirtha'},
    {'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg','temple': 'Lokanath Temple'},
    {'image': 'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg','temple': 'Vimala Temple'},
    {'image': 'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg','temple': 'Varahi Temple'},
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar
            body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.red,
                    isScrollable:true,
                    labelPadding: EdgeInsets.only(right: 45.0),
                    unselectedLabelColor: Colors.black45,

                    tabs: const [
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text('TAXI STAND',style: TextStyle(fontSize: 12),)
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('TAXI',style: TextStyle(fontSize: 12),)
                          ],
                        ),
                      ),


                    ]),
              ),
              SizedBox(height: 5),
              Container(
                height: MediaQuery.of(context).size.height - 50.0,
                width:  double.infinity,
                child: TabBarView(
                  controller: _tabController,
                  children: const <Widget>[
                    /// here you put gallery code
                    // CookiePage(),
                    TaxiStand(),
                    TaxiHome(),

                  ],
                ),
              ),

            ]
        )
      // ],
    );
  }
}
