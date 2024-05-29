import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:puri/app/generalFunction.dart';
import 'package:puri/temples/templedetail.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';

class TemplesHome extends StatefulWidget {
  const TemplesHome({super.key});

  @override
  State<TemplesHome> createState() => _TemplesHomeState();
}

class _TemplesHomeState extends State<TemplesHome> {
 // GeneralFunction? generalFunction;
  GeneralFunction generalFunction = GeneralFunction();

  final List<Map<String, String>> itemList = [
    {'image': 'https://www.drishtiias.com/images/uploads/1698053713_image1.png','temple': 'Jagannath Temple'},
    {'image': 'https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-hinohp2v89f6sovfrqk7d6bfj7-20231002122234.Medi.jpeg','temple': 'PanchaTirtha'},
    {'image': 'https://images.indianexpress.com/2021/08/Puri-temple-1.jpeg','temple': 'Lokanath Temple'},
    {'image': 'https://t4.ftcdn.net/jpg/03/57/53/11/360_F_357531159_cumH01clbXOo32Ytvkb7qGYspCJjj4gB.jpg','temple': 'Vimala Temple'},
    {'image': 'https://w0.peakpx.com/wallpaper/672/441/HD-wallpaper-puri-jagannath-temple-cloud.jpg','temple': 'Varahi Temple'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar("TEMPLES"),
        drawer: generalFunction.drawerFunction(context,'Suaib Ali','9871950881'),
        body: Container(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.7,
                    child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageAssets.templepuri4),
                          // Provide the path to your image asset
                          fit: BoxFit.cover, // Adjust how the image fits into the container
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 50,
                      left: 20,
                      child: Image.asset(ImageAssets.cityname, height: 100)),
                  Positioned(
                      top: 75,
                      left: 40,
                      child: Text("TEMPLES",
                          style:
                              AppTextStyle.font30penSansExtraboldWhiteTextStyle))
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        border: Border.all(
                          color: Colors.orange, // Set the golden border color
                          width: 1.0, // Set the width of the border
                        ),
                      ),
                      child: InkWell(
                        onTap: (){
                          var templeName = "${itemList[index]['temple']}";
                          var image  =  "${itemList[index]['image']}";
                          print('-----165---$templeName');
                          print('-----166---$image');
                          // navigator
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => TemplesDetail(
                              templeName:templeName,image:image)));
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(builder: (context) => TemplesDetail(templeName:templeName,image:image)),
                          // );
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
                                    child: Image.network('${itemList[index]['image']}',height: 90,width: 90, fit: BoxFit.cover,)),
                              ),
                              ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: ListTile(
                                      title: Text(
                                        "${itemList[index]['temple']}",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: Image.asset('assets/images/arrow.png',
                                        height: 12,
                                        width: 12,
                                      )
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
                  },
                  ),
                ),
              )
              ]

          ),
        )
         // ],
        );
  }
}
