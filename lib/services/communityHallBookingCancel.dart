import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class CommunityHallBookingCancel {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future communityHallBooking(
      BuildContext context, bookingRequuestId, String sCancelRemarks, String? sContactNo,) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    // String? sContact = prefs.getString('sContact');

    print("----token---$sToken");
    print("----bookingRequuestId---$bookingRequuestId");
    print("----sCancelRemarks---$sCancelRemarks");
    print("----sContactNo---$sContactNo");

    try {
      //print('----phsRequestNoone-----31--$feedback');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "CommunityHallBookingCancel/CommunityHallBookingCancel";
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
            "sBookingReqId":bookingRequuestId,
            "sCancelRemarks":sCancelRemarks,
            "sCanceledBy":sContactNo
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

