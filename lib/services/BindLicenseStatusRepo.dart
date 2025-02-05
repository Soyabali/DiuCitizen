

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BindLicenseStatusRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<Map<String, dynamic>>?> bindLicenseStatus(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? iUserId = prefs.getString('iUserId');
    String? contactNo = prefs.getString('sContactNo');

    print('---contact no---$contactNo');

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindLicenseStatus/BindLicenseStatus";
      var citiZenPoatComplaintApi = "$baseURL$endPoint";

      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$citiZenPoatComplaintApi'));
      // BIND BODY IN THE REQUEST
      request.body = json.encode(
          {
        "sContactNo": contactNo,
         });
      // bind header in  the request.
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        // decode the stream and put the map
        Map<String, dynamic> parsedJson = jsonDecode(data);
        // to fetch particular data from a response
        List<dynamic>? dataList = parsedJson['Data']; // to store parse data into the list

        if (dataList != null) {
          // cast the list data to map
          List<Map<String, dynamic>> pendingInternalComplaintList = dataList.cast<Map<String, dynamic>>();
          print("Dist list: $pendingInternalComplaintList");
          return pendingInternalComplaintList;
        } else if(response.statusCode==401) {
          generalFunction.logout(context);
        }
      } else {
        hideLoader();
        return null;
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception: $e");
      throw e;
    }
  }
}