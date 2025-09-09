import 'dart:io';

import 'package:flutter/material.dart';
import '../../app/generalFunction.dart';
import '../resources/app_text_style.dart';

class KnowYourWard extends StatefulWidget {
  final name;

  KnowYourWard({super.key, this.name});

  @override
  State<KnowYourWard> createState() => _KnowYourWardState();
}

class _KnowYourWardState extends State<KnowYourWard> {
  // Date PICKER
  DateTime selectedDate = DateTime.now();
  GeneralFunction generalFunction = GeneralFunction();

  File? image;
  List distList = [];
  var _dropDownValueDistric;
  List stateList = [];
  List blockList = [];
  List marklocationList = [];
  var _dropDownValueMarkLocation;
  var _selectedPointId;

  /// Todo bind SubCategory
  Widget _bindSubCategory() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 25,
        height: 42,
        //color: Color(0xFFf2f3f5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Set the outline color
            width: 1.0, // Set the outline width
          ),
        ),

        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              hint: RichText(
                text: TextSpan(
                  text: "Select Sub Category",
                  style: AppTextStyle.font14penSansExtraboldBlack45TextStyle,
                  children: <TextSpan>[
                    TextSpan(
                        text: '',
                        style: AppTextStyle
                            .font14penSansExtraboldBlack45TextStyle),
                  ],
                ),
              ),
              // Not necessary for Option 1
              value: _dropDownValueMarkLocation,
              // key: distDropdownFocus,
              onChanged: (newValue) {
                setState(() {
                  _dropDownValueMarkLocation = newValue;
                  print('---333-------$_dropDownValueMarkLocation');
                  //  _isShowChosenDistError = false;
                  // Iterate the List
                  marklocationList.forEach((element) {
                    if (element["sPointTypeName"] ==
                        _dropDownValueMarkLocation) {
                      setState(() {
                        _selectedPointId = element['iPointTypeCode'];
                        print('----341------$_selectedPointId');
                      });
                      print('-----Point id----241---$_selectedPointId');
                      if (_selectedPointId != null) {
                        // updatedBlock();
                        print('-----Point id----244---$_selectedPointId');
                      } else {
                        print('-------');
                      }
                      // print("Distic Id value xxxxx.... $_selectedDisticId");
                      print("Distic Name xxxxxxx.... $_dropDownValueDistric");
                      print("Block list Ali xxxxxxxxx.... $blockList");
                    }
                  });
                });
              },
              items: marklocationList.map((dynamic item) {
                return DropdownMenuItem(
                  child: Text(item['sPointTypeName'].toString()),
                  value: item["sPointTypeName"].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    print('-----27--${widget.name}');
    super.initState();
   // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   NavigationUtils.onWillPop(context);
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context,'${widget.name}'),
      drawer:
          generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),

       body: ListView(
         children: [
           middleHeader(context, '${widget.name}'),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                padding: const EdgeInsets.all(10),
                  child: Column(
                  children: [
                    _bindSubCategory(),

                     SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 0,right: 2),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${"BHANU SENAPATI"}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"Contact No"}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"Agency Name"}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"Description Of Ward"}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"Address"}: ",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),

                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "${"Party Name :-INC"}",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"8847875092"}",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"Not Specified"}",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"Bidansi, Kumbharasahi"}",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),
                              Text(
                                "${"Not Specified"}",
                                style: AppTextStyle
                                    .font14OpenSansRegularBlackTextStyle,
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
         ],
       ),
     ]
    )
    );

  }
}
