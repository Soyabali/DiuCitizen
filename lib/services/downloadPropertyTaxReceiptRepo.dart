import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import '../model/downloadReceiptModel.dart';
import 'baseurl.dart';

class GetPendingforApprovalReimRepo {

  var getPendingForApprovalList = [];

  GeneralFunction generalFunction = GeneralFunction();

  Future<List<DownloadReceiptModel>> getPendingApprovalReim(
      BuildContext context, String firstOfMonthDay, String lastDayOfCurrentMonth, pageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    String? contactNo = prefs.getString('sContactNo');
    print("------23--$firstOfMonthDay");
    print("------24--$lastDayOfCurrentMonth");
    print("----24----contactNo----$contactNo");
    print("----25-----pageCode---$pageCode");
    print("----25-----token ---$sToken");


    showLoader();

    var baseURL = BaseRepo().baseurl;
    var endPoint = "DownloadPropertyTaxReceipt/DownloadPropertyTaxReceipt";
    var downlodeReceipt = "$baseURL$endPoint";

    try {
      var headers = {
        'token': "$sToken",
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse(downlodeReceipt));
      request.body = json.encode({
        "dFromDate": firstOfMonthDay,      //"dFromDate": "01/Aug/2024",     //"dFromDate": firstOfMonthDay,
        "dToDate": lastDayOfCurrentMonth,          //"dToDate": "01/Aug/2025",    //"dToDate": lastDayOfCurrentMonth,
        "sReceiptTypeCode": pageCode,                //"sReceiptTypeCode": pageCode,
        "sUserId": contactNo,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        hideLoader();

        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        List<dynamic> dataList = jsonResponse['Data'];  // ✅ FIXED LINE

        print('------58--response---$dataList');
        return dataList
            .map((data) => DownloadReceiptModel.fromJson(data))
            .toList();
      } else if (response.statusCode == 401) {
        hideLoader();
        generalFunction.logout(context);
        throw Exception('Unauthorized access');
      } else {
        print('------67--response---');
        hideLoader();
        throw Exception('Failed to load pending approvals');
      }
    } catch (e) {
      hideLoader();
      throw Exception('An error occurred: $e');
    } finally {
      hideLoader();
    }
  }

}