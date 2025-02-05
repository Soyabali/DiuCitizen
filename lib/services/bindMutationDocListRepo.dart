
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindMutationDocListRepo
{
  List bindMutationDocList = [];
  Future<List> bindMutationDoc(dropDownTradeCategoryCode) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindMutationDocsList/BindMutationDocsList";
      var bindMutationDocListApi = "$baseURL$endPoint";

      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('POST', Uri.parse('$bindMutationDocListApi'));

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
        bindMutationDocList = parsedJson['Data'];
        print("Dist list bindMutationDocList Api ----71------>:$bindMutationDocList");
        return bindMutationDocList;
      } else
      {
        hideLoader();
        return bindMutationDocList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
