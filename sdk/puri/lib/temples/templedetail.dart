import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/temples/temple_gallery.dart';
import 'package:readmore/readmore.dart';
import '../app/generalFunction.dart';
import '../resources/app_text_style.dart';


class TemplesDetail extends StatefulWidget {
  final templeName;
  final image;

  TemplesDetail({super.key, this.templeName, this.image});

  @override
  State<TemplesDetail> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<TemplesDetail> {
  GeneralFunction generalFunction = GeneralFunction();
  final List<Map<String, String>> itemList = [
    {
      'image':
          'https://www.drishtiias.com/images/uploads/1698053713_image1.png',
      'temple': 'Jagannath Temple'
    },
    {
      'image':
          'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg',
      'temple': 'PanchaTirtha'
    },
    {
      'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg',
      'temple': 'Lokanath Temple'
    },
    {
      'image':
          'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg',
      'temple': 'Vimala Temple'
    },
    {
      'image':
          'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg',
      'temple': 'Varahi Temple'
    },
  ];

  @override
  void initState() {
    print('-----27--${widget.templeName}');
    print('-----28--${widget.image}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar
      //appBar: getAppBar("TEMPLES"),
      appBar: getAppBarBack('TEMPLES'),
      drawer: generalFunction.drawerFunction(context,'Suaib Ali','9871950881'),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.network('${widget.image}', fit: BoxFit.cover),
              ),
              Positioned(
                top: 135,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: (){
                      print('----118---');
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => TempleGallery(
                      )));
                    },
                    child: Container(
                      height: 56.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        // Background color of the container
                        borderRadius: BorderRadius.circular(28.0),
                        // Circular border radius
                        border: Border.all(
                          color: Colors.yellow, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/gallery.png',
                            // Replace with your image path
                            height: 25.0,
                            width: 25.0,
                          ),
                          const SizedBox(width: 10.0),
                          // Space between image and text
                          Text('VIEW GALLERY',
                              style: AppTextStyle
                                  .font18penSansExtraboldWhiteTextStyle),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 5),
          Stack(
            children: <Widget>[
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/cityelementone.png',
                          // Replace with your first image path
                          height: 50.0,
                          width: 50.0,
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/listelementtop.png',
                          // Replace with your second image path
                          height: 50.0,
                          width: 50.0,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 20,
                      child: Image.asset('assets/images/templeelement1.png',
                          // Replace with your first image path
                          height: 50.0,
                          width: MediaQuery.of(context).size.width),
                    ),
                    Positioned(
                        top: 80,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text('${widget.templeName}',
                              style: AppTextStyle
                                  .font18penSansExtraboldRedTextStyle),
                        ))
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width - 50,
              color: Color(0xFFD3D3D3),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Text('Temple Timings',
                      style: AppTextStyle.font18penSansExtraboldRedTextStyle),
                  SizedBox(height: 15),
                  Text('Summer',
                      style: AppTextStyle.font18penSansExtraboldRedTextStyle),
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Morning 05:00 ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('am to ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('12:00 pm',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Evening 02:00 ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('pm to ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('8:00 pm',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Winter',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Morning 05:00 ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('am to ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('12:00 pm',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Evening 02:00 ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('pm to ',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                        Text('8:00 pm',
                            style: AppTextStyle
                                .font16penSansExtraboldBlack45TextStyle),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Aarti Time',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ' ',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                        Text(
                          '',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Container(
              height: 56.0,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.red,
                // Background color of the container
                borderRadius: BorderRadius.circular(28.0),
                // Circular border radius
                border: Border.all(
                  color: Colors.yellow, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('LIVE DARSHAN',
                      style: AppTextStyle
                          .font18penSansExtraboldWhiteTextStyle),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Image.asset('assets/images/templelement2.png',
              // Replace with your first image path
              height: 50.0,
              width: MediaQuery.of(context).size.width),
          SizedBox(height: 15),
          Center(
            child: Text('About Temple',
                style: AppTextStyle
                    .font18penSansExtraboldRedTextStyle),
          ),
          SizedBox(height: 15),
    Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: ReadMoreText(
      '''Jagannatha is regarded as the supreme god and the sovereign monarch of the Odishan empire. The entire ritual pattern of Jagannatha has been conceived keeping such twin aspects in view. The ritual system of the temple is very elaborate and complex involving a multitude of functionaries above one thousand spread over one hundred categories. The rituals of Jagannatha can broadly be divided into three parts - the daily , the occasional and the festive. In Jagannatha temple these rituals assume the term 'niti'.

Daily Rituals:''',
      trimLines: 1,
      colorClickableText: Colors.red,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      style: TextStyle(color: Colors.black, fontSize: 18),
      moreStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.red),
      textAlign: TextAlign.justify, // Justify text alignment
      ),
    ),

          // const ReadMoreText(
          //   '''GeeksForGeeks is the best tutorial website for programmers.
          //   If you are beginner or intermediate or expert programmer
          // GeeksForGeeks is the best website for learning to code and
          // learn different frameworks.''',
          //   trimLines: 2,
          //  // textScaleFactor: 1,
          //   colorClickableText: Colors.red,
          //   trimMode: TrimMode.Line,
          //   trimCollapsedText: 'Show more',
          //   trimExpandedText: 'Show less',
          //   style: TextStyle(color: Colors.black, fontSize: 18),
          //   moreStyle: TextStyle(
          //       fontSize: 15,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.red),
          // ),
          SizedBox(height: 15),
          Image.asset('assets/images/templeelement3.png',
              // Replace with your first image path
              height: 50.0,
              width: MediaQuery.of(context).size.width),
          SizedBox(height: 15),
          Center(
            child: Container(
              height: 56.0,
              width: MediaQuery.of(context).size.width-50,
              decoration: BoxDecoration(
                color: Colors.red,
                // Background color of the container
                borderRadius: BorderRadius.circular(28.0),
                // Circular border radius
                border: Border.all(
                  color: Colors.yellow, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('CLICK ON MAP TO NAVIGATE',
                      style: AppTextStyle
                          .font18penSansExtraboldWhiteTextStyle),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),

          // ReadMoreText(
          //   '''GeeksForGeeks is the best tutorial website for programmers.
          //   If you are beginner or intermediate or expert programmer
          // GeeksForGeeks is the best website for learning to code and
          // learn different frameworks.
          //   ''',
          //   trimLines: 4,
          // //  textScaleFactor: 1,
          //   colorClickableText: Colors.red,
          //   trimMode: TrimMode.Line,
          //   trimCollapsedText: 'Show more',
          //   trimExpandedText: 'Show less',
          //   style: TextStyle(color: Colors.black, fontSize: 18),
          //   moreStyle: TextStyle(
          //       fontSize: 15,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.red),
          // ),


        ],
      ),
    );
  }
}
