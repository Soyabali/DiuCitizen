import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/GetLisenceTradeList.dart';
import '../../../services/GetWaterSupTaxTypeListRepo.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';


class WaterSupplyTaxtTypelist extends StatefulWidget {

  final licenseRequestId;
  const WaterSupplyTaxtTypelist({super.key, required this.licenseRequestId});

  @override
  State<WaterSupplyTaxtTypelist> createState() => _TradeDetailsPageState();
}

class _TradeDetailsPageState extends State<WaterSupplyTaxtTypelist> {

  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>> _filteredData = [];
  bool isLoading = true;
  var licenseRequestId;


  pendingInternalComplaintResponse(licenseRequestId) async {
    pendingInternalComplaintList = await GetWaterSupTaxtTypeListRepo().getWaterTypeList(context,licenseRequestId);
    print('-----28--->>>>>>----$pendingInternalComplaintList');
    _filteredData = List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    licenseRequestId = "${widget.licenseRequestId}";
    print("--38---xx--$licenseRequestId");
    if(licenseRequestId!=null){
      pendingInternalComplaintResponse(licenseRequestId);
    }
    //pendingInternalComplaintResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBaar
      appBar:AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF12375e),
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        centerTitle: true,
        backgroundColor: Color(0xFF255898),
        leading: GestureDetector(
          onTap: (){
            print("------back---");
            Navigator.pop(context);
            // Navigator.pop(context);
            //  Navigator.push(
            //    context,
            //    MaterialPageRoute(builder: (context) =>LicenseStatus()),
            //  );

          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios,
              color: Colors.white,),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Water Supply Details',
            style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        //centerTitle: true,
        elevation: 0, // Removes shadow under the AppBar
      ),
      body:
      isLoading
          ? Center(child:
      Container())
          : (pendingInternalComplaintList == null || pendingInternalComplaintList!.isEmpty)
          ? NoDataScreenPage()
          :
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length ?? 0,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = _filteredData[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              'assets/images/cartimage.jpeg',
                              fit: BoxFit.fill,
                              height: 35,
                              width: 35,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Icon(Icons.error, size: 25);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(item['sItemName'], style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text('${index+1} .', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                  SizedBox(width: 2),
                                  Text(item['sWaterTaxType'], style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('Water tax Name', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                            ],),
                          // Text('Quantity: ${item['fQty']}', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                        ],
                      ),
                      Divider(),
                      Container(
                        height: 45,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 14,
                                        width: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      //Text(item['sUoM'], style: AppTextStyle.font14OpenSansRegularBlackTextStyle),
                                      Text(item['sDescription'], style: AppTextStyle.font14OpenSansRegularBlackTextStyle),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text('Description', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              color: Color(0xFF0098a6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Text('₹ ${item['fAmount']}',
                                style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                                textAlign: TextAlign.center,
                              ),
                              // child: Text('₹ ${item['fAmount']}',
                              //   style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                              //   textAlign: TextAlign.center,
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

