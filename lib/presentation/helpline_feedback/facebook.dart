import 'package:flutter/material.dart';
import '../../app/generalFunction.dart';
import 'facebookWeb.dart';


class FacebookPage extends StatefulWidget {

  final name;
  FacebookPage({super.key, this.name});

  @override
  State<FacebookPage> createState() => _MarriageCertificateState();
}

class _MarriageCertificateState extends State<FacebookPage> {


  GeneralFunction generalFunction = GeneralFunction();

  @override
  void initState() {
    print('-----27--${widget.name}');
    super.initState();
   // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
   // BackButtonInterceptor.remove(myInterceptor);
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FaceBookWeb()),

    );

  }
}
