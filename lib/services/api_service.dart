import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rest_api_practice/models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/users"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if(response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception("API Hatası: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Bağlantı hatası: $e");
    }
  }
}