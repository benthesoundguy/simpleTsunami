import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchTsunamiData() async {
  final response = await http.get(Uri.parse('https://www.ngdc.noaa.gov/hazard/tsu.shtml'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load tsunami data');
  }
}