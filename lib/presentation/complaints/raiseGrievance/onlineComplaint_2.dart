import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../app/generalFunction.dart';
import '../../resources/app_text_style.dart';


class OnlineComplaint_2 extends StatefulWidget {
  final name;

  OnlineComplaint_2({super.key, this.name});

  @override
  State<OnlineComplaint_2> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<OnlineComplaint_2> {
  GeneralFunction generalFunction = GeneralFunction();

  final List<Map<String, String>> itemList = [
    {
      'image':
      'https://www.drishtiias.com/images/uploads/1698053713_image1.png',
      'temple': 'Sanitation & Public Health'
    },
    {
      'image':
      'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg',
      'temple': 'Water, Drainage & Sewerage'
    },
    {
      'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg',
      'temple': 'Lokanath Temple'
    },
    {
      'image':
      'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg',
      'temple': 'Stay Animals Catching Services'
    },
    {
      'image':
      'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg',
      'temple': 'Encroachment'
    },
    {
      'image':
      'https://www.drishtiias.com/images/uploads/1698053713_image1.png',
      'temple': 'Miscellaneous'
    },
    {
      'image':
      'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg',
      'temple': 'Holding Tax'
    },
    {
      'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg',
      'temple': 'Civic Infrastructure'
    },
    {
      'image':
      'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg',
      'temple': 'Slum /Project/Welfare Schemes'
    },
    {
      'image':
      'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg',
      'temple': 'Licence & Parking'
    },
  ];

  final List<Map<String, dynamic>> itemList2 = [
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'ICICI BANK CC PAYMENT',
      'subtitle': 'Utility & Bill Payments',
      'transactions': '1 transaction',
      'amount': ' 7,86,698',
      'temple': 'Sanitation & Public Health'
    },
    {
    //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'APTRONIX',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 1,69,800',
      'temple': 'Water, Drainage & Sewerage'
    },
    {
      //'leadingIcon': Icons.account_box,
      'leadingIcon': 'assets/images/shopping-bag2.png',
      'title': 'MICROSOFT INDIA',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 30,752',
      'temple': 'Lokanath Temple'
    },
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'SARVODAYA HOSPITAL U O',
      'subtitle': 'Medical',
      'transactions': '1 transaction',
      'amount': '@ 27,556',
      'temple': 'Stay Animals Catching Services'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'MOHAMMED ZUBER',
      'subtitle': 'UPI Payment',
      'transactions': '1 transaction',
      'amount': '@ 25,000',
      'temple': 'Encroachment'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/church.png',
      'title': 'MOHAMMED ZUBER',
      'subtitle': 'UPI Payment',
      'transactions': '1 transaction',
      'amount': '@ 25,000',
      'temple': 'Miscellaneous'
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/church.png',
      'title': 'MOHAMMED ZUBER',
      'subtitle': 'UPI Payment',
      'transactions': '1 transaction',
      'amount': '@ 25,000',
      'temple': 'Holding Tax'
    },
  ];

  final List<Color> borderColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
  ];

  Color getRandomBorderColor() {
    final random = Random();
    return borderColors[random.nextInt(borderColors.length)];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  void dispose() {
   // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context, '${widget.name}'),
      drawer:
      generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              middleHeader(context, '${widget.name}'),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: itemList2.length,
                  itemBuilder: (context, index) {
                    return Padding(
                     // padding: const EdgeInsets.only(left: 5,right: 5),
                      padding: const EdgeInsets.symmetric(vertical: 1.0),

                        child: ListTile(
                          leading:Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(
                                  colors: [Colors.red, Colors.orange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),

                              ),
                              child: Center(
                                child: Image.asset(
                               itemList2[index]['leadingIcon'],
                               width:30,
                               height:30,
                               fit:BoxFit.cover
                              ),
                            ),),
                          title: Text(itemList2[index]['temple'], style: AppTextStyle.font14penSansExtraboldBlack87TextStyle),

                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/arrow.png',
                                  height: 12,
                                  width: 12,
                                ),
                              ],
                            ),
                          ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

