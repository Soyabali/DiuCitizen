

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindWaterTaxtTypeRepo
{
  List bindWaterTextTypeList = [];
  Future<List> bindWaterText() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindWaterTaxType/BindWaterTaxType";
      var bindCityzenWardApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('GET', Uri.parse('$bindCityzenWardApi'));

      // request.body = json.encode({
      //   "iCategoryCode": "1",
      // });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        bindWaterTextTypeList = parsedJson['Data'];
        print("Dist list bindCitizenWardList Api ----71------>:$bindWaterTextTypeList");
        return bindWaterTextTypeList;
      } else
      {
        hideLoader();
        return bindWaterTextTypeList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
