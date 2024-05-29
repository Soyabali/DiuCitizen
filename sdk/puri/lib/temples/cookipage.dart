import 'package:flutter/material.dart';
import 'cookie_detail.dart';

class CookiePage extends StatelessWidget {
  const CookiePage({Key? key}) : super(key: key);

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CookieDetail(assetPath:imagePath)));

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