import 'dart:convert';

import 'package:pengaduan/helper/constant.dart';
import 'package:http/http.dart' as http;

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = apiUrl + route;
    try {
      return await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: _header(),
      );
    } catch (e) {
      print(e.toString());
      return jsonEncode(e);
    }
  }

  Future<http.Response> getRequest({
    required String route,
  }) async {
    String url = apiUrl + route;
    try {
      return await http.get(
        Uri.parse(url),
        headers: _header(),
      );
    } catch (e) {
      print(e.toString());
      return http.Response(jsonEncode(e), 500);
    }
  }

  _header() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
