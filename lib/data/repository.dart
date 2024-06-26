import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models.dart';

class CounterRepository {
  final String baseUrl =
      'http://10.0.2.2:8000'; 
  Future<Counter> fetchCounter() async {
    final response = await http.get(Uri.parse('$baseUrl/count/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Counter.fromJson(data);
    } else {
      throw Exception('Failed to load counter');
    }
  }

  Future<void> updateCounter(int newValue) async {
    try {
      final Uri url = Uri.parse('$baseUrl/count/');
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final String body = json.encode({'value': newValue});

      print('Sending PUT request to $url with body: $body');

      http.Response response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Counter updated successfully');
      } else {
        print('Failed to update counter. Status code: ${response.statusCode}');
        throw Exception('Failed to update counter: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating counter: $e');
      throw Exception('Failed to update counter');
    }
  }

  Future<void> updateMaxValue(int maxValue) async {
    final response = await http.put(
      Uri.parse('$baseUrl/count'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'max_value': maxValue}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update max value');
    }
  }
}
