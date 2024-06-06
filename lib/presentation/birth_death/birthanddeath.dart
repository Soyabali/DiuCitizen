import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../app/generalFunction.dart';
import 'birthanddeathwebView.dart';


class BirthAndDeathCertificate extends StatefulWidget {

  final name;
  BirthAndDeathCertificate({super.key, this.name});

  @override
  State<BirthAndDeathCertificate> createState() => _BirthAndDeathState();
}

class _BirthAndDeathState extends State<BirthAndDeathCertificate> {

  GeneralFunction generalFunction = GeneralFunction();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack('${widget.name}'),
      drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BirthAndDeathWebViewStack()),
    );
  }
}