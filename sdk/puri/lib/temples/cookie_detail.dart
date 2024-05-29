import 'package:flutter/material.dart';

import '../app/generalFunction.dart';

class CookieDetail extends StatelessWidget {
  final assetPath;

  CookieDetail({super.key, this.assetPath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: getAppBar("IMAGES"),
      appBar: getAppBarBack('IMAGES'),
      body: ListView(
        children: [
            Hero(
              tag: assetPath,
              child: Image.asset(assetPath,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill
              )
            ),
        ]
      ));
  }
}
