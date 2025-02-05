import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puri/app/generalFunction.dart';
import 'package:puri/presentation/onlineService/buildingPlan/buildingPlan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AdvertiseMentPlaceTypeRepo
{
  GeneralFunction generalFunction = GeneralFunction();
  List advertisementPlaceTypeList = [];
  Future<List> advertisementPlaceType(BuildContext context) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetAdSpaceType/GetAdSpaceType";
      var advertisementPlaceTypeApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('GET', Uri.parse('$advertisementPlaceTypeApi'));

      // request.body = json.encode({
      //   "iCategoryCode": "1",
      // });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if(response.statusCode ==401){
        generalFunction.logout(context);
      }
      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        advertisementPlaceTypeList = parsedJson['Data'];
        print("Dist list advertisementPlaceTypeList Api ----71------>:$advertisementPlaceTypeList");
        return advertisementPlaceTypeList;
      } else
      {
        hideLoader();
        return advertisementPlaceTypeList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
