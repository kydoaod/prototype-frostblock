import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFetch {
  static Future<http.Response> get(
    String url,
    Map<String, String> headersJson,
    Map<String, String> queryJson,
    String params,
  ) async {
    final query = queryJson.isNotEmpty ? '?${Uri(queryParameters: queryJson).query}' : '';
    final headers = {'Content-Type': 'application/json', ...headersJson};

    return await http.get(
      Uri.parse(url + params + query),
      headers: headers,
    );
  }

  static Future<http.Response> post(
    String url,
    Map<String, String> headersJson,
    Map<String, String> queryJson,
    String params,
    Map<String, dynamic> body,
  ) async {
    final query = queryJson.isNotEmpty ? '?${Uri(queryParameters: queryJson).query}' : '';
    final headers = {'Content-Type': 'application/json', ...headersJson};

    return await http.post(
      Uri.parse(url + params + query),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> postFormData(
    String url,
    Map<String, String> headersJson,
    Map<String, String> queryJson,
    String params,
    http.MultipartRequest body,
  ) async {
    final query = queryJson.isNotEmpty ? '?${Uri(queryParameters: queryJson).query}' : '';
    final headers = {'Content-Type': 'multipart/form-data', ...headersJson};

    body.headers.addAll(headers);

    return await http.Response.fromStream(await body.send());
  }

  static Future<http.Response> patch(
    String url,
    Map<String, String> headersJson,
    Map<String, String> queryJson,
    String params,
    Map<String, dynamic> body,
  ) async {
    final query = queryJson.isNotEmpty ? '?${Uri(queryParameters: queryJson).query}' : '';
    final headers = {'Content-Type': 'application/json', ...headersJson};

    return await http.patch(
      Uri.parse(url + params + query),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String url,
    Map<String, String> headersJson,
    Map<String, String> queryJson,
    String params,
    Map<String, dynamic> body,
  ) async {
    final query = queryJson.isNotEmpty ? '?${Uri(queryParameters: queryJson).query}' : '';
    final headers = {'Content-Type': 'application/json', ...headersJson};

    return await http.put(
      Uri.parse(url + params + query),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
    String url,
    Map<String, String> headersJson,
    Map<String, String> queryJson,
    String params,
    Map<String, dynamic> body,
  ) async {
    final query = queryJson.isNotEmpty ? '?${Uri(queryParameters: queryJson).query}' : '';
    final headers = {'Content-Type': 'application/json', ...headersJson};

    return await http.delete(
      Uri.parse(url + params + query),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
