
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherRepo {
  GeneralFunction generalFunction = GeneralFunction();
  Future<List<Map<String, dynamic>>?> getWeatherInfo(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? sToken = prefs.getString('sToken');
    // String? iCitizenCode = prefs.getString('iCitizenCode');
    //
    // print('-----16---$sToken');
    // print('-----17---$iCitizenCode');
    // print('---token----$sToken');

    try {
     // var baseURL = BaseRepo().baseurl;
      //var endPoint = "GetNearByPlacesType/GetNearByPlacesType";
      var weatherApi = "https://api.weatherbit.io/v2.0/current?key=5d196d3c564c4598ba1cd29557ffd149&lat=19.804897504582037&lon=85.81792786738797";
      showLoader();

      // var headers = {
      //   'token': '$sToken',
      //   'Content-Type': 'application/json'
      // };
      var request = http.Request('GET', Uri.parse('$weatherApi'));
     // request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      // if(response.statusCode ==401){
      //   generalFunction.logout(context);
      // }
      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        List<dynamic>? dataList = parsedJson['data'];

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
