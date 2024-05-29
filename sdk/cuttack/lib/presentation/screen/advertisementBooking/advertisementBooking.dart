import 'package:flutter/material.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvertisementBooking(),
    );
  }
}
class AdvertisementBooking extends StatefulWidget {
  const AdvertisementBooking({super.key});

  @override
  State<AdvertisementBooking> createState() => _AdvertisementBookingState();
}

class _AdvertisementBookingState extends State<AdvertisementBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
          child: Center(
            child: Text("Advertisement Booking Status",style: TextStyle(
                color: Colors.black,fontSize: 20
            ),),
          ),
                ),
        )
        ],
      ),
    );
  }
}



