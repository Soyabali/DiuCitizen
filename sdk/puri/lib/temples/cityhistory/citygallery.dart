
import 'package:flutter/material.dart';

import '../cookie_detail.dart';

class CityGallery extends StatelessWidget {
  const CityGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/images/temples.png',
      'assets/images/temple_0.png',
      'assets/images/temple_1.jpg',
      'assets/images/temple_2.jpg',
      'assets/images/temple_3.png',
      'assets/images/temple_4.png',
    ];
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 10,
        shadowColor: Colors.orange,
        toolbarOpacity: 0.5,
        leading: Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                // Adjust the left margin as needed
                child: Transform.scale(
                  scale: 0.8,
                  // Adjust the scale factor as needed to reduce the image size
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      child: Image.asset("assets/images/back.png"),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/header_line1.png",
              width: 80,
              height: 15,
            ),
            SizedBox(width: 10),
            const Text(
              'CITY GALLERY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 10),
            Image.asset(
              "assets/images/header_line2.png",
              width: 75,
              height: 10,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10.0, // Space between columns
            mainAxisSpacing: 10.0, // Space between rows
            childAspectRatio: 1, // Aspect ratio of each grid item
          ),
          itemCount: imagePaths.length,
          itemBuilder: (context, index)
          {
            return GestureDetector(
                onTap: () {
                  var imagePath = '${imagePaths[index]}';

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => CookieDetail(assetPath:imagePath))
                  );

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => CookieDetail(assetPath:imagePath)));

                },
                child: ImageCard(imagePath: imagePaths[index]));  //ImageCard(imagePath: imagePaths[index]);
          },
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imagePath;
  const ImageCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}