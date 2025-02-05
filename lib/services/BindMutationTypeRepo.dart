
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class BindMutationTypeRepo
{
  List bindMutationTypeList = [];
  Future<List> bindMutationTypeRepo() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');
    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "BindMutationType/BindMutationType";
      var bindMutationTypeApi = "$baseURL$endPoint";

      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('GET', Uri.parse('$bindMutationTypeApi'));

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
        bindMutationTypeList = parsedJson['Data'];
        print("Dist list bindMutationTypeList Api ----71------>:$bindMutationTypeList");
        return bindMutationTypeList;
      } else
      {
        hideLoader();
        return bindMutationTypeList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
