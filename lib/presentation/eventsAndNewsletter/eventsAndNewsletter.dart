import 'package:flutter/material.dart';
import 'package:puri/presentation/eventsAndNewsletter/webviewEventsAndNewsletter.dart';
import '../../app/generalFunction.dart';

class EventsAndNewSletter extends StatefulWidget {

  final name;
  const EventsAndNewSletter({super.key, this.name});

  @override
  State<EventsAndNewSletter> createState() => _MarriageCertificateState();
}

class _MarriageCertificateState extends State<EventsAndNewSletter> {


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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBarBack(context,'${widget.name}'),
      drawer:
      generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: EventsWebViewStack()),

    );

  }
}
