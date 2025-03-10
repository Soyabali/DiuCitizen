import 'package:flutter/material.dart';

import '../../app/generalFunction.dart';

class ParkImageDetail extends StatelessWidget {

  final assetPath;
  ParkImageDetail({super.key, this.assetPath});

  @override
  Widget build(BuildContext context) {
    var title ="Title";
    return Scaffold(
      appBar: getAppBarBack(context,'IMAGES'),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Hero(
                  tag: assetPath,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10.0,
                          spreadRadius: 5.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        assetPath, // Replace with your image URL
                        width: 200, // Adjust as needed
                        height: 200, // Adjust as needed
                        fit: BoxFit.cover, // Adjust as needed
                      ),
                      // child: Image.asset(
                      //   assetPath,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
