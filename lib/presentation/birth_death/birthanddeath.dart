
import 'package:flutter/material.dart';
import '../../app/generalFunction.dart';
import 'birthanddeathwebView.dart';

class BirthAndDeathCertificate extends StatefulWidget {

  final name;
  BirthAndDeathCertificate({super.key,this.name});

  @override
  State<BirthAndDeathCertificate> createState() => _BirthAndDeathState();
}

class _BirthAndDeathState extends State<BirthAndDeathCertificate> {

  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context,"Birth & Death Certificate"),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BirthAndDeathWebViewStack()),
      ),
    );
  }
}
