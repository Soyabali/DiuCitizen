
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindTradeCategoryRepo
{
  List bindTradeCategoryList = [];
  Future<List> bindTradeCategory() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindTradeCategory/BindTradeCategory";
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
        bindTradeCategoryList = parsedJson['Data'];
        print("Dist list bindFinalYearList Api ----71------>:$bindTradeCategoryList");
        return bindTradeCategoryList;
      } else
      {
        hideLoader();
        return bindTradeCategoryList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
