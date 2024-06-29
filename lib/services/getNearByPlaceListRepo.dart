
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';

class NearByPlaceListRepo {

  GeneralFunction generalFunction = GeneralFunction();
  Future<List<Map<String, dynamic>>?> getNearByTempleList(BuildContext context, lat,long,iTypeCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? iCitizenCode = prefs.getString('iCitizenCode');

    print('-----16---$sToken');
    print('-----17---$iCitizenCode');
    print('---token----$sToken');
    print('--lat---21--$lat');
    print('--long---21--$long');
    print('--long---23--$iTypeCode');
    // print('---iHeadCode----$iHeadCode');

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetNearByPlaceList/GetNearByPlaceList";
      var nearByplaceApi = "$baseURL$endPoint";
      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$nearByplaceApi'));

      request.body = json.encode({
        "fLatitude": lat,
        "fLongitude": long,
        "iTypeCode":iTypeCode
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      // if(response.statusCode ==401){
      //   generalFunction.logout(context);
      // }
      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        List<dynamic>? dataList = parsedJson['Data'];

        if (dataList != null) {
          List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
          print("xxxxx------46----: $notificationList");
          return notificationList;
        } else{
          return null;
        }
      } else {
        hideLoader();
        return null;
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
      throw e;
    }
  }
}
