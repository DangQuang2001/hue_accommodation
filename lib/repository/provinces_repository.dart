import 'dart:convert';
import 'package:http/http.dart' as http;

class ProvincesRepository {
  static Future getCity() async {
    final response = await http.get(
        Uri.parse('https://provinces.open-api.vn/api/p/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    return null;
  }

  static Future getDistrict(int code) async {
    final response = await http
        .get(Uri.parse('https://provinces.open-api.vn/api/p/$code?depth=2'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    return null;
  }

  static Future getWards(int code) async {
    final response = await http
        .get(Uri.parse('https://provinces.open-api.vn/api/d/$code?depth=2'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    return null;
  }
}
