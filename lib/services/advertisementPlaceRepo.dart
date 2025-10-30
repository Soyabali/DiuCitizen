import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AdvertiseMentPlaceRepo
{
  List advertisementPlaceList = [];
  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<List> advertisementPlace(dropDownValueAdvertisementPlaceType) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---19-  TOKEN---$sToken');
    print('-----17---$dropDownValueAdvertisementPlaceType');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetAdSpace/GetAdSpace";
      var advertisementPlaceApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('POST', Uri.parse('$advertisementPlaceApi'));

      request.body = json.encode({
        "iAdSpaceTypeCode":dropDownValueAdvertisementPlaceType,
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);

        // Safely check for the 'Data' key and its value
        if (parsedJson['Data'] != null && parsedJson['Data'] is List) {
          advertisementPlaceList = parsedJson['Data'];
        } else {
          advertisementPlaceList = []; // Assign an empty list
          displayToast("No data available for this ID."); // Show a toast
        }



        print("Dist advertisementPlaceList Api ----71------>:$advertisementPlaceList");
        return advertisementPlaceList;
      } else
      {
        hideLoader();
        return advertisementPlaceList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
