import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class VerifyAppVersionRepo {

  // this is a loginApi call functin

  GeneralFunction generalFunction = GeneralFunction();
  Future verifyAppVersion(BuildContext context, String sVersion) async {

    try {
      print('----version-----17--$sVersion');
      //  https://erpapi.diusmartcity.com/DiuCitizenApi/api/
      // https://erpapi.diusmartcity.com/DiuCitizenApi/api/VerifyAppVersionV1/VerifyAppVersionV1
      var baseURL = BaseRepo().baseurl;
      //var endPoint = "VerifyAppVersion/VerifyAppVersion";
      var endPoint = "VerifyAppVersionV1/VerifyAppVersionV1";
      var verifyAppVersionApi = "$baseURL$endPoint";
      print('------------23---verifyAppVersionApi---$verifyAppVersionApi');

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('$verifyAppVersionApi'));
      request.body = json.encode(
          {
            "sVersion": sVersion,
            "sAppType": "I"
          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---sVersion RESPONSE----$map');

      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----44-${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---sVersion RESPONSE----$map');
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
