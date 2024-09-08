import 'dart:convert';
import 'package:http/http.dart' as http;

class TsunamiDataService {
  Future<List<Map<String, dynamic>>> fetchTsunamiData() async {
    final response = await http.get(Uri.parse('https://www.ngdc.noaa.gov/hazel/hazard-service/api/v1/tsunamis/events'));

    if (response.statusCode == 200) {
      // Parse the response and return the list of tsunami events
      final data = json.decode(response.body);
      print('Fetched data: $data'); // Add this line for debugging

      final List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(data['items']);
      final DateTime hundredYearsAgo = DateTime.now().subtract(Duration(days: 365 * 100));

      // Filter events to only include those from the past 100 years
      final recentEvents = events.where((event) {
        final eventDate = DateTime.parse(event['date']);
        return eventDate.isAfter(hundredYearsAgo);
      }).toList();

      return recentEvents;
    } else {
      throw Exception('Failed to load tsunami data');
    }
  }
}