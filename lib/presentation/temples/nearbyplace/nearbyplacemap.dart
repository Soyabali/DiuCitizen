import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/presentation/parklocator/parkWebView.dart';

import '../../../app/generalFunction.dart';
import '../../../app/navigationUtils.dart';
import 'nearbyplaceweb.dart';



class NearByPlaceMap extends StatefulWidget {

  final name;
  NearByPlaceMap({super.key, this.name});

  @override
  State<NearByPlaceMap> createState() => _MarriageCertificateState();
}

class _MarriageCertificateState extends State<NearByPlaceMap> {


  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    print('-----27--${widget.name}');
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    NavigationUtils.onWillPop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context,'${"Near by Place"}'),
      drawer:
      generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: NearByPlaceWebView()),
    );
  }
}
