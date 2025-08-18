
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../app/generalFunction.dart';
import 'AbutdiuWebPage.dart';
import 'package:upi_india/upi_india.dart';

class AboutDiuPage extends StatefulWidget {

  final name,sPageLink;
  AboutDiuPage({super.key,
    this.name, required this.sPageLink});

  @override
  State<AboutDiuPage> createState() => _BirthAndDeathState();
}

class _BirthAndDeathState extends State<AboutDiuPage> {

  GeneralFunction generalFunction = GeneralFunction();
  var webPage;

  @override
  void initState() {
    super.initState();
     webPage="${widget.sPageLink}";
     print("-----26--WebLink---$webPage");
     print("----27----WebName--${widget.name}");
    // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context,"${widget.name}"),
      drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        //child: Container(),
         child: AbutDiuWebPage(webPage)
         // child: BirthAndDeathWebViewStack()),
    ));
  }
}
