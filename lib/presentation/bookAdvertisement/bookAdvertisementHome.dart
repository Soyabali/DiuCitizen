
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../advertisementBookingStatus/advertisementBookingStatus.dart';
import '../resources/app_text_style.dart';
import 'bookAdvertisement.dart';

class BookadvertisementHome extends StatefulWidget {

  final name;
  BookadvertisementHome({super.key, this.name});

  @override
  State<BookadvertisementHome> createState() => _OnlineComplaintState();
}

class _OnlineComplaintState extends State<BookadvertisementHome> {

  final List<Map<String, dynamic>> itemList2 = [
    {
      'title': 'Book Advertisement',
    },
    {
      'title': 'Book Advertisement Status',
    },

  ];

  final List<Color> borderColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // statusBarColore
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF12375e),
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          // backgroundColor: Colors.blu
          backgroundColor: Color(0xFF255898),
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              print("------back---");
              Navigator.pop(context);
              //  Navigator.push(
              //    context,
              //    MaterialPageRoute(builder: (context) => const ComplaintHomePage()),
              //  );
            },
            child: Icon(Icons.arrow_back_ios,
              color: Colors.white,),
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Book Advertisement',
              style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          //centerTitle: true,
          elevation: 0, // Removes shadow under the AppBar
        ),
        body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // middleHeader(context, '${widget.name}'),
            Container(
              height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemList2.length ?? 0,
                itemBuilder: (context, index) {
                  final color = borderColors[index % borderColors.length];
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: GestureDetector(
                          onTap: () {
                            var title = itemList2[index]['title'];
                            if(title=="Book Advertisement"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BookAdvertisement(name: "Book Advertisement")),
                              );
                              return;
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdvertisementBookingStatus()),
                              );
                            }
                            },
                          child: ListTile(
                            // leading Icon
                            leading: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: color, // Set the dynamic color
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(Icons.ac_unit,
                                  color: Colors.white,
                                )
                            ),
                            // Title
                            title: Text(
                              itemList2![index]['title']!,
                              style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                            ),
                            //  traling icon
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                    'assets/images/arrow.png',
                                    height: 12,
                                    width: 12,
                                    color: color
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Container(
                          height: 1,
                          color: Colors.grey, // Gray color for the bottom line
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),

      ),
    );
  }
}

