import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/generalFunction.dart';
import '../../../app/loader_helper.dart';



class MarkPointSubmitRepo {
  GeneralFunction generalFunction = GeneralFunction();

  Future markpointsubmit(
      BuildContext context,
      randomNumber,
      dropDownValueMarkLocation,
      dropDownValueDistric,
      String location,
      slat,
      slong,
      String description,
      String uplodedImage,
      String? todayDate,
      userId) async {
    // sharedP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('sToken');
    try {

      String jsonResponse =
          '{"sArray":[{"iCompCode":$randomNumber,"iSubCategoryCode":$dropDownValueMarkLocation,"sWardCode":$dropDownValueDistric,"sAddress":"$location","sLandmark":$slat,"sComplaintDetails":$slong,"sComplaintPhoto":"$description","sPostedBy":"$uplodedImage","fLatitude":"$todayDate","fLongitude":$userId}]}';
// Parse the JSON response
      Map<String, dynamic> parsedResponse = jsonDecode(jsonResponse);

// Get the array value
      List<dynamic> sArray = parsedResponse['sArray'];

// Convert the array to a string representation
      String sArrayAsString = jsonEncode(sArray);

// Update the response object with the string representation of the array
      parsedResponse['sArray'] = sArrayAsString;

// Convert the updated response object back to JSON string
      String updatedJsonResponse = jsonEncode(parsedResponse);

// Print the updated JSON response (optional)
      print(updatedJsonResponse);
      print('---63-----$updatedJsonResponse');

//Your API call
      var headers = {'token': '$token', 'Content-Type': 'application/json'};

      var request = http.Request(
          'POST',
          Uri.parse(
              'https://upegov.in/noidaoneapi/Api/MarkLocation/MarkLocation'));
      request.body =
          updatedJsonResponse; // Assign the JSON string to the request body
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('---90---${response.statusCode}');
      if (response.statusCode == 200) {
        hideLoader();
        print('----------96-----$map');
        return map;
      } else if(response.statusCode==401)
      {
        generalFunction.logout(context);
      }else{
        print('----------99----$map');
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
