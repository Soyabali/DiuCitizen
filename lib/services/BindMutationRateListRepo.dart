
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindMutationRateListRepo
{
  List bindMutationRateList = [];
  Future<List> bindMutationRate(dropDownTradeCategoryCode) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindMutationRateList/BindMutationRateList";
      var bindMutationRateListApi = "$baseURL$endPoint";

      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('POST', Uri.parse('$bindMutationRateListApi'));

      request.body = json.encode({
        "iMutationCode": dropDownTradeCategoryCode,
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        bindMutationRateList = parsedJson['Data'];
        print("Dist list bindMutationDocList Api ----71------>:$bindMutationRateList");
        return bindMutationRateList;
      } else
      {
        hideLoader();
        return bindMutationRateList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
