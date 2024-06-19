import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';


class SendOtpForCitizenLoginRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future sendOtpForCitizenLogin(BuildContext context,String contactNo) async {

    try {
      print('----contactNo------18-$contactNo');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "SendOTPForCitizenLogin/SendOTPForCitizenLogin";
      var loginApi = "$baseURL$endPoint";
      print('------------17---SendOTPForCitizenLogin"---$loginApi');

      showLoader();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse('$loginApi'));
      request.body = json.encode({"sContactNo": contactNo});
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
        print('----------29---LOGINaPI RESPONSE----$map');
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