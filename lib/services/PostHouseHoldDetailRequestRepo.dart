import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';

class PostHouseHoldDetailRequestRepo {
  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future postHouseHoldDetailRequestRepo(BuildContext context, String allThreeFormJson) async {
    // sharedP
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('sToken');

    try {
     // print('----allThreeFormJson---->>>---21----$allThreeFormJson');
      print("---response---xxxx---");
      debugPrint(allThreeFormJson, wrapWidth: 1024);

      var baseURL = BaseRepo().baseurl;

      /// TODO CHANGE HERE
      var endPoint = "PostHouseHoldDetailRequest/PostHouseHoldDetailRequest";
      var markPointSubmitApi = "$baseURL$endPoint";
      print('------------39---postHouseHoldDetailRequestApi---$markPointSubmitApi');

      // String jsonResponse = '{"sArray":$allThreeFormJson"}';
      String jsonResponse = '{"sArray":$allThreeFormJson}';
      // String jsonResponse = 'sArray":$allThreeFormJson';
      // String jsonResponse = '{"sArray":"$allThreeFormJson"}';
      //------------
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
      print('---70-----$updatedJsonResponse');

//Your API call
      var headers = {'token': '$token', 'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('$markPointSubmitApi'));
      // var request = http.Request('POST', Uri.parse('http://115.244.7.153/diucitizenapi/api/PostHouseHoldDetailRequest/PostHouseHoldDetailRequest'));
      request.body = updatedJsonResponse; // Assign the JSON string to the request body
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('-------89--$map');
      print('---90---${response.statusCode}');
      // var response;
      // var map;
      //print('----------20---LOGINaPI RESPONSE----$map');
      if(response.statusCode ==401){
        generalFunction.logout(context);
      }
      if (response.statusCode == 200) {
        print('------92----xxxxxxxxxxxxxxx----');
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../app/generalFunction.dart';
// import '../app/loader_helper.dart';
// import 'baseurl.dart';
//
//
// class PostHouseHoldDetailRequestRepo {
//
//   // this is a loginApi call functin
//   GeneralFunction generalFunction = GeneralFunction();
//
//   Future postHouseHoldDetail(BuildContext context, String formattedDate, dropDownPremisesWardCode,
//       String houseNo, String ownerName, String houseAddress, String dConstructionYear,
//       String sPropertyType, String grooundFloorSq, String firstFloorSq, String secondFloorSq,
//       String thirdFloorSq, String basementSq, String totalResidentialProperty,
//       String nonResidentialProperty, String useOfNonResidentialProperty, String groundFloorCommercial,
//       String firstFloorCommercial, String secondFloorCommercial, String thirdFloorCommercial, String basementSqFtCommercial, String mazzanineFloorsProperty, String totalResidentialPropertyCommercial, String residentialRentalAreaCommercial, String rentOfTheResidentialRentalCommercial, String nonResidentialPropertyCommercial, String useOfNonResidentialPropertyCommercial, String totalCarpetArea, String mobileNo, String residentialRentalAreaSf, String rentOfTheResidentialRental,
//       String surveyNo, String allThreeFormJson,
//       ) async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? contactNo = prefs.getString('sContactNo');
//
//     // print all values according to match key
//     print("sHouseHoldRequestId :  $formattedDate");
//     print("iWardCode :  $dropDownPremisesWardCode");
//     print("sHouseNo :  $houseNo");
//     print("sHouseOwnerName :  $ownerName");
//     print("sHouseAddress :  $houseAddress");
//     print("dConstructionYear :  $dConstructionYear");
//     print("sPropertyType :  $sPropertyType");
//     print("fGFResidential :  $grooundFloorSq");
//     print("fFFResidential :  $firstFloorSq");
//     print("fSFResidential :  $secondFloorSq");
//     print("fTFResidential :  $thirdFloorSq");
//     print("fBasementResidential :  $basementSq");
//     print("fTotalResidentialArea :  $totalResidentialProperty");
//     print("fTotalNonResidentialArea :  $nonResidentialProperty");
//     print("sUsesNonResidentialArea :  $useOfNonResidentialProperty");
//      //  fGFCommercial
//     print("fGFCommercial :  $groundFloorCommercial");
//     print("fFFCommercial :  $firstFloorCommercial");
//     print("fSFCommercial :  $secondFloorCommercial");
//     print("fTFCommercial :  $thirdFloorCommercial");
//     print("fMezzFCommercial :  $mazzanineFloorsProperty");
//     print("fBasementCommercial :  $basementSqFtCommercial");
//     print("fTotalCommercialArea :  $totalResidentialPropertyCommercial");
//     print("fTotalRentalCommercialArea :  $residentialRentalAreaCommercial");
//     print("fTotalRentRentalCommercialArea : $residentialRentalAreaCommercial");
//     print("fTotalNonCommercialArea :  $nonResidentialPropertyCommercial");
//     print("sUsesNonCommercialArea :  $useOfNonResidentialPropertyCommercial");
//     print("fTotalCarpetArea :  $totalCarpetArea");
//     print("sMobileNo :  $mobileNo");
//     print("sAppliedBy :  $contactNo");
//     print("fTotalRentalResidentialArea :  $residentialRentalAreaSf");
//     print("RentOfTotalRentalResidentialArea :  $rentOfTheResidentialRental");
//     print("sSurveyNo :  $surveyNo");
//     print("DocumentUploadList :  $allThreeFormJson");
//
//
//     try {
//       //print('----phone-----17--$phone');
//       //print('----name-----17--$name');
//
//       var baseURL = BaseRepo().baseurl;
//       var endPoint = "PostHouseHoldDetailRequest/PostHouseHoldDetailRequest";
//       var registrationApi = "$baseURL$endPoint";
//       print('------------17---registrationApi---$registrationApi');
//
//       showLoader();
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//           'POST',
//           Uri.parse('$registrationApi'));
//
//       request.body = json.encode(
//           {
//             "sHouseHoldRequestId": "$formattedDate",
//             "iWardCode": "2",
//             "sHouseNo":"$houseNo",
//             "sHouseOwnerName":"$ownerName",
//             "sHouseAddress":"$houseAddress",
//             "dConstructionYear":"$dConstructionYear",
//             "sPropertyType":"$sPropertyType",
//             "fGFResidential":"$grooundFloorSq",
//             "fFFResidential":"$firstFloorSq",
//             "fSFResidential":"$secondFloorSq",
//             "fTFResidential":"$thirdFloorSq",
//             "fBasementResidential":"$basementSq",
//             "fTotalResidentialArea":"$totalResidentialProperty",
//             "fTotalNonResidentialArea":"$nonResidentialProperty",
//             "sUsesNonResidentialArea":"$useOfNonResidentialProperty",
//             "fGFCommercial":"$groundFloorCommercial",
//             "fFFCommercial":"$firstFloorCommercial",
//             "fSFCommercial":"$secondFloorCommercial",
//             "fTFCommercial":"$thirdFloorCommercial",
//             "fMezzFCommercial":"$mazzanineFloorsProperty",
//             "fBasementCommercial":"$basementSqFtCommercial",
//             "fTotalCommercialArea":"$totalResidentialPropertyCommercial",
//             "fTotalRentalCommercialArea":"$residentialRentalAreaCommercial",
//             "fTotalRentRentalCommercialArea":"$rentOfTheResidentialRentalCommercial",
//             "fTotalNonCommercialArea":"$nonResidentialPropertyCommercial",
//             "sUsesNonCommercialArea":"$useOfNonResidentialPropertyCommercial",
//             "fTotalCarpetArea":"$totalCarpetArea",
//             "sMobileNo":"$mobileNo",
//             "sAppliedBy":"$contactNo",
//             "fTotalRentalResidentialArea":"$residentialRentalAreaSf",
//             "RentOfTotalRentalResidentialArea":"$rentOfTheResidentialRental",
//             "sSurveyNo":"$surveyNo",
//             "DocumentUploadList":allThreeFormJson
//
//           });
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       var map;
//       var data = await response.stream.bytesToString();
//       map = json.decode(data);
//       print('----------20---Registration response----$map');
//
//       if (response.statusCode == 200) {
//         // create an instance of auth class
//         print('----44-${response.statusCode}');
//         hideLoader();
//         print('----------22-----$map');
//         return map;
//       } else {
//         print('----------29---Registration response----$map');
//         hideLoader();
//         print(response.reasonPhrase);
//         return map;
//       }
//     } catch (e) {
//       hideLoader();
//       debugPrint("exception: $e");
//       throw e;
//     }
//   }
//
// }
