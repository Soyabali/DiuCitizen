import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class FeedbackRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future feedfack(
      BuildContext context,
      String feedback, String? sContactNo) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    // String? sContact = prefs.getString('sContact');

    print("----token---$sToken");
    print("----feedback---$feedback");
    print("----sContactNo---$sContactNo");

    try {
      print('----phsRequestNoone-----31--$feedback');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "PostCitizenFeedback/PostCitizenFeedback";
      var bookAdvertisementApi = "$baseURL$endPoint";
      print('------------17---Api---$bookAdvertisementApi');
      showLoader();
      // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request(
          'POST', Uri.parse('$bookAdvertisementApi'));
      request.body = json.encode(
          {
            "dPostedBy":sContactNo,
            "sFeadback":feedback
          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---LOGINaPI RESPONSE----$map');

      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----44-${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---bookAdvertisement RESPONSE----$map');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }
}

