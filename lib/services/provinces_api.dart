import 'dart:convert';
import 'package:http/http.dart' as http;

class ProvincesApi{
  static Future getCity()async{
    final response =  await http.get(Uri.parse('https://provinces.open-api.vn/api/p?lang=vi'),
    headers:  <String, String>{
      'Content-Type':
      'application/json; charset=UTF-8',
    }
    );
    if(response.statusCode == 200){

      return jsonDecode(response.body);
    }
    return null;
  }

  static Future getDistrict(int code)async{
    final response =  await http.get(Uri.parse('https://provinces.open-api.vn/api/p/$code?depth=2'));
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future getTown(int code)async{
    final response =  await http.get(Uri.parse('https://provinces.open-api.vn/api/d/$code?depth=2'));
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    return null;
  }

}