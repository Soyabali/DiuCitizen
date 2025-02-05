

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetWaterSupTaxtTypeListRepo {

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<Map<String, dynamic>>?> getWaterTypeList(BuildContext context, licenseRequestId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? iUserId = prefs.getString('iUserId');
    String? contactNo = prefs.getString('sContactNo');

    print("---22---$licenseRequestId");

    print('---contact no---$contactNo');

    try {
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetWaterSupTaxTypeList/GetWaterSupTaxTypeList";
      var citiZenPoatComplaintApi = "$baseURL$endPoint";

      showLoader();
      var headers = {
        'token': '$sToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$citiZenPoatComplaintApi'));
      request.body = json.encode({
        "sWaterTaxReq":licenseRequestId,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        hideLoader();
        var data = await response.stream.bytesToString();
        print("-----46---Response---$data");
        Map<String, dynamic> parsedJson = jsonDecode(data);
        List<dynamic>? dataList = parsedJson['Data'];

        if (dataList != null) {
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