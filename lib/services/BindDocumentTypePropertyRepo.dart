
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindDocumentTypePropertyRepo
{
  List bindDocumentTypeList = [];
  Future<List> bindDocumentyTypeProperty() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindDocumentType/BindDocumentType";
      var bindCityzenWardApi = "$baseURL$endPoint";

      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('POST', Uri.parse('$bindCityzenWardApi'));

      request.body = json.encode({
        "sInputType": "Property",
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        bindDocumentTypeList = parsedJson['Data'];
        print("Dist list bindDocumentProperty ----71------>:$bindDocumentTypeList");
        return bindDocumentTypeList;
      } else
      {
        hideLoader();
        return bindDocumentTypeList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
