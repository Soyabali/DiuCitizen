import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:puri/presentation/onlineService/propertyAssessment/propertyAssessment.dart';
import 'package:puri/presentation/onlineService/propertyMutation/propertyMutation.dart';
import 'package:puri/presentation/onlineService/propertyTax/propertyTax.dart';
import 'package:puri/presentation/onlineService/waterSupply/waterSupply.dart';
import '../../app/generalFunction.dart';
import '../../services/GetReceiptPageNameRepo.dart';
import '../../services/getEmergencyContactTitleRepo.dart';
import '../aboutDiu/Aboutdiupage.dart';
import '../complaints/complaintHomePage.dart';
import '../nodatavalue/NoDataValue.dart';
import '../onlineService/buildingPlan/buildingPlan.dart';
import '../onlineService/communityHall/communityHall.dart';
import '../onlineService/license/license.dart';
import '../resources/app_text_style.dart';
import 'downlodereceipt.dart';

class TaxReceipt extends StatefulWidget {
  final name;
  TaxReceipt({super.key, this.name});

  @override
  State<TaxReceipt> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<TaxReceipt> {

  GeneralFunction generalFunction = GeneralFunction();

  List<Map<String, dynamic>>? emergencyTitleList;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  // GeneralFunction generalFunction = GeneralFunction();

  getEmergencyTitleResponse() async {
    emergencyTitleList = await GetReceiptPageName().getReceipt(context);
    print('------43---XXXX-----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }

  final List<Map<String, dynamic>> itemList2 = [
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'ICICI BANK CC PAYMENT',
      'subtitle': 'Utility & Bill Payments',
      'transactions': '1 transaction',
      'amount': ' 7,86,698',
      'temple': 'Fire Emergency',
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'APTRONIX',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 1,69,800',
      'temple': 'Police',
    },
    {
      //'leadingIcon': Icons.account_box,
      'leadingIcon': 'assets/images/shopping-bag2.png',
      'title': 'MICROSOFT INDIA',
      'subtitle': 'Shopping',
      'transactions': '1 transaction',
      'amount': '@ 30,752',
      'temple': 'Women Help',
    },
    {
      //'leadingIcon': Icons.account_balance_wallet,
      'leadingIcon': 'assets/images/credit-card.png',
      'title': 'SARVODAYA HOSPITAL U O',
      'subtitle': 'Medical',
      'transactions': '1 transaction',
      'amount': '@ 27,556',
      'temple': 'Medical Emergency',
    },
    {
      //  'leadingIcon': Icons.ac_unit_outlined,
      'leadingIcon': 'assets/images/shopping-bag.png',
      'title': 'MOHAMMED ZUBER',
      'subtitle': 'UPI Payment',
      'transactions': '1 transaction',
      'amount': '@ 25,000',
      'temple': 'Other Important Numbers',
    },
  ];
  var OnlineTitle = [
    "Property Tax",
    // "Building Plan",
    "Property Assessment",
    "License",
    "Community Hall",
    "Property Transfer",
    "Water Supply",
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
    getEmergencyTitleResponse();
    super.initState();
  }

  @override
  void dispose() {
    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF12375e),
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF255898),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: const Text(
            'Download Receipt',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
        ),
        body: isLoading
            ? buildShimmerList()
            : (emergencyTitleList == null || emergencyTitleList!.isEmpty)
            ? NoDataScreenPage()
            : ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: emergencyTitleList?.length ?? 0,
          itemBuilder: (context, index) {
            final item = emergencyTitleList![index];
            final color = borderColors[index % borderColors.length];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.ac_unit, color: Colors.white),
                ),
                title: Text(
                  item['sPageName'] ?? '',
                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                ),
                trailing: Image.asset(
                  'assets/images/arrow.png',
                  height: 12,
                  width: 12,
                  color: color,
                ),
                onTap: () {
                  // Convert to int safely
                  final rawPageCode = item['iPageCode'];
                  final int? pageCode = rawPageCode is int
                      ? rawPageCode
                      : int.tryParse(rawPageCode.toString());
                  final pageName = item['sPageName'] ?? '';
                  final pageCode2 = item['iPageCode'] ?? '';
                  // to bind the data on a listview

                  print("----208---pageName--$pageName");
                  print("----208---pageCode--$rawPageCode");


                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownlodeReceipt(pageName:pageName,pageCode:rawPageCode)),
                  );


                  // Navigate if pageCode is valid
                  if (pageCode != null) {
                    // Navigate to next page or handle logic
                  } else {
                    print("Invalid pageCode type");
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
