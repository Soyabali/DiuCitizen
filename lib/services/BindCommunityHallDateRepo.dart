import 'dart:convert';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;

class BindCommunityHallDateRepo {
  // Change bindcityWardList to be of type List<Map<String, dynamic>>
  List<Map<String, dynamic>> bindcityWardList = [];

  Future<List<Map<String, dynamic>>> bindCommunityHallDate(BuildContext context, var hallId, selectedMonthCode) async {
    print("--------15----$hallId");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---19-  TOKEN---$sToken');

    try {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindCommunityHall/BindCommunityHall";
      var bindCityzenWardApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('POST', Uri.parse('$bindCityzenWardApi'));

      request.body = json.encode({
        "iCommunityHallID": hallId,
        "iMonthCode":selectedMonthCode
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);

        // Ensure 'Data' is a List<Map<String, dynamic>> before assigning to bindcityWardList
        var rawData = parsedJson['Data'];

        // Check if rawData is a List and if it is, convert each item to Map<String, dynamic>
        if (rawData is List) {
          bindcityWardList = List<Map<String, dynamic>>.from(rawData.map((item) {
            return Map<String, dynamic>.from(item); // Ensure each item is a Map
          }));
        }

        print("Dist list Marklocation Api ----71------>:$bindcityWardList");
        return bindcityWardList;
      } else {
        hideLoader();
        return []; // Return an empty list if the response is not successful
      }
    } catch (e) {
      hideLoader();
      throw (e); // If any error occurs, throw it
    }
  }
}

// import 'dart:convert';
//
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../app/loader_helper.dart';
// import 'baseurl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
//
// class BindCommunityHallDateRepo
// {
//   List bindcityWardList = [];
//   Future<List> bindCommunityHallDate(BuildContext context, var hallId) async
//   {
//     print("--------15----$hallId");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? sToken = prefs.getString('sToken');
//     print('---19-  TOKEN---$sToken');
//
//     try
//     {
//       showLoader();
//       var baseURL = BaseRepo().baseurl;
//       var endPoint = "BindCommunityHall/BindCommunityHall";
//       var bindCityzenWardApi = "$baseURL$endPoint";
//       var headers = {
//         'token': '$sToken'
//       };
//       var request = http.Request('POST', Uri.parse('$bindCityzenWardApi'));
//
//       request.body = json.encode({
//         "iCommunityHallID": hallId,
//       });
//
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200)
//       {
//         hideLoader();
//         var data = await response.stream.bytesToString();
//         Map<String, dynamic> parsedJson = jsonDecode(data);
//         bindcityWardList = parsedJson['Data'];
//         print("Dist list Marklocation Api ----71------>:$bindcityWardList");
//         return bindcityWardList;
//       } else
//       {
//         hideLoader();
//         return bindcityWardList;
//       }
//     } catch (e)
//     {
//       hideLoader();
//       throw (e);
//     }
//   }
// }
