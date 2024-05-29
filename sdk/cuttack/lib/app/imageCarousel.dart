import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;
  final List<String> imageList = [
    'assets/images/burger1.jpg',
    'assets/images/burger2.jpg',
    'assets/images/burger3.jpg',
    'assets/images/burger4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 250.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
            onPageChanged: (index, _) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imageList.map((path) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageList.map((url) {
            int index = imageList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}