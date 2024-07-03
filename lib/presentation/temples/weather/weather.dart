
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/app/generalFunction.dart';
import '../../../services/weather_repo.dart';
import '../../nodatavalue/NoDataValue.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<WeatherHome> {
  GeneralFunction generalFunction = GeneralFunction();
  List<Map<String, dynamic>>? weatherinfo;
  bool isLoading = true;

  weatherResponse() async {
    weatherinfo = await WeatherRepo().getWeatherInfo(context);
    print('------22----$weatherinfo');
    setState(() {
     // weatherinfo=[];
      isLoading = false;
    });
  }

  final List<Map<String, String>> itemList = [
    {
      'image':
          'https://www.drishtiias.com/images/uploads/1698053713_image1.png',
      'day': 'Monday'
    },
    {
      'image':
          'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg',
      'day': 'Tuesday'
    },
    {
      'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg',
      'day': 'Lokanath Temple'
    },
    {
      'image':
          'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg',
      'day': 'Wednesday'
    },
    {
      'image':
          'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg',
      'day': 'Thursday'
    },
    {
      'image':
          'https://www.drishtiias.com/images/uploads/1698053713_image1.png',
      'day': 'Friday'
    },
    {
      'image':
          'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg',
      'day': 'Saturday'
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    weatherResponse();
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
        // appBar
        appBar: getAppBar("Weather"),
        // drawer
        drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body:
        isLoading
            ? Center(child:
              Container())
            : (weatherinfo == null || weatherinfo!.isEmpty)
            ? NoDataScreenPage()
            :
        Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.7,
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/clear_sky_top.png"),
                      // Provide the path to your image asset
                      fit: BoxFit
                          .cover, // Adjust how the image fits into the container
                    ),
                  ),
                  child: Container(),
                ),
              ),
              Positioned(
                  top: 50,
                  left: 20,
                  child: Image.asset(
                    "assets/images/clear_sky_front.png",
                    width: 100,
                    height: 100,
                  )),
              Positioned(
                  top: 40,
                  left: 130,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Today',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              weatherinfo![0]['temperature'].toString(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(width: 15),
                            Text(
                                weatherinfo![0]['wind_speed'].toString(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          weatherinfo![0]['weather_description'].toString(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'Humidity :',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(width: 2),
                            Text(
                              weatherinfo![0]['humidity'].toString(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            //Spacer(),
                            SizedBox(width: 4),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Wind:',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(width: 4),
                                Text(
                                    weatherinfo![0]['wind_speed'].toString(),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(weatherinfo?.length ?? 0, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange,
                            // Set the golden border color
                            width: 1.0, // Set the width of the border
                          ),
                        ),
                        child: InkWell(
                          onTap: () {

                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      '${itemList[index]['image']}',
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            weatherinfo![0]['city_name'].toString(),
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                weatherinfo![0]['temperature'].toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                weatherinfo![index]['weather_description'].toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Condition',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                weatherinfo![index]['weather_description'].toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Image.asset(
                                        "assets/images/listelementtop.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                    SizedBox(height: 35),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset(
                                        "assets/images/listelementbottom.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          )
        ]
        )
        // ],
        );
  }
}
