
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import '../model/PropertyTaxSearchResponse.dart';
import 'baseurl.dart';

class SearchPropertyTaxForPaymentRepo {
  GeneralFunction generalFunction = GeneralFunction();
  Future<PropertyTaxSearchResponse> searchPropertyTaxForPayment(
      BuildContext context,
      selectedWardId,
      String houseno,
      String houseOwnerName,
      ) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "SearchPropertyTaxForPayment/SearchPropertyTaxForPayment";
      var apiUrl = "$baseURL$endPoint";

      showLoader();

      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(apiUrl));
      request.body = json.encode({
        "iWardCode": selectedWardId,
        "sHouseNo": houseno,
        "sHouseOwnerName": houseOwnerName,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 401) {
        generalFunction.logout(context);
      }

      var body = await response.stream.bytesToString();
      hideLoader();

      Map<String, dynamic> parsedJson = jsonDecode(body);
      print("FULL RESPONSE 👉 $parsedJson");

      return PropertyTaxSearchResponse.fromJson(parsedJson);

    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
      rethrow;
    }
  }

// Future<List<Map<String, dynamic>>?> searchPropertyTaxForPayment(BuildContext context, selectedWardId, String houseno, String houseOwnerName) async {
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? sToken = prefs.getString('sToken');
  //   String? iCitizenCode = prefs.getString('iCitizenCode');
  //
  //   print('-----16---$sToken');
  //   print('-----17---$iCitizenCode');
  //   print('---token----$sToken');
  //   print("------21-----$selectedWardId");
  //   // houseOwnerName
  //   print("------23-----$houseno");
  //   print("------24-----$houseOwnerName");
  //   try {
  //     var baseURL = BaseRepo().baseurl;
  //     var endPoint = "SearchPropertyTaxForPayment/SearchPropertyTaxForPayment";
  //     var getEmergencyContactListApi = "$baseURL$endPoint";
  //     showLoader();
  //
  //     var headers = {
  //       'token': '$sToken',
  //       'Content-Type': 'application/json'
  //     };
  //     var request = http.Request('Post', Uri.parse('$getEmergencyContactListApi'));
  //     request.body = json.encode(
  //         {
  //           "iWardCode": selectedWardId,
  //           "sHouseNo":houseno,
  //           "sHouseOwnerName":houseOwnerName
  //           // "iWardCode": "03" ,
  //           // "sHouseNo":"81(1)-1",
  //           // "sHouseOwnerName":""
  //         });
  //     request.headers.addAll(headers);
  //     http.StreamedResponse response = await request.send();
  //     if(response.statusCode ==401){
  //       generalFunction.logout(context);
  //     }
  //     if (response.statusCode == 200) {
  //       hideLoader();
  //       var data = await response.stream.bytesToString();
  //       Map<String, dynamic> parsedJson = jsonDecode(data);
  //
  //       print("-----55------$parsedJson");
  //
  //       List<dynamic>? dataList = parsedJson['Data'];
  //
  //       if (dataList != null) {
  //         List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
  //         print("xxxxx------46----: $notificationList");
  //         return notificationList;
  //       } else{
  //         return null;
  //       }
  //     } else {
  //       hideLoader();
  //       return null;
  //     }
  //   } catch (e) {
  //     hideLoader();
  //     debugPrint("Exception: $e");
  //     throw e;
  //   }
  // }


}

// class SearchPropertyTaxForPaymentRepo {
//   GeneralFunction generalFunction = GeneralFunction();
//   Future<List<Map<String, dynamic>>?> searchPropertyTaxForPayment(BuildContext context, selectedWardId, String houseno, String houseOwnerName) async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//     String? iCitizenCode = prefs.getString('iCitizenCode');
//
//     print('-----16---$sToken');
//     print('-----17---$iCitizenCode');
//     print('---token----$sToken');
//     print("------21-----$selectedWardId");
//     // houseOwnerName
//     print("------23-----$houseno");
//     print("------24-----$houseOwnerName");
//     try {
//       var baseURL = BaseRepo().baseurl;
//       var endPoint = "SearchPropertyTaxForPayment/SearchPropertyTaxForPayment";
//       var getEmergencyContactListApi = "$baseURL$endPoint";
//       showLoader();
//
//       var headers = {
//         'token': '$sToken',
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('Post', Uri.parse('$getEmergencyContactListApi'));
//       request.body = json.encode(
//           {
//             "iWardCode": selectedWardId,
//             "sHouseNo":houseno,
//             "sHouseOwnerName":houseOwnerName
//             // "iWardCode": "03" ,
//             // "sHouseNo":"81(1)-1",
//             // "sHouseOwnerName":""
//           });
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       if(response.statusCode ==401){
//         generalFunction.logout(context);
//       }
//       if (response.statusCode == 200) {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         Map<String, dynamic> parsedJson = jsonDecode(data);
//
//         print("-----55------$parsedJson");
//
//         List<dynamic>? dataList = parsedJson['Data'];
//
//         if (dataList != null) {
//           List<Map<String, dynamic>> notificationList = dataList.cast<Map<String, dynamic>>();
//           print("xxxxx------46----: $notificationList");
//           return notificationList;
//         } else{
//           return null;
//         }
//       } else {
//         hideLoader();
//         return null;
//       }
//     } catch (e) {
//       hideLoader();
//       debugPrint("Exception: $e");
//       throw e;
//     }
//   }
// }
