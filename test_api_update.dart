import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'http://157.137.190.243:3000/api';
  
  try {
    print('Testing PUT /maestros/1 ...');
    final responsePut = await http.put(
      Uri.parse('$baseUrl/maestros/1'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"estado": 0}),
    );
    print('PUT Status: ${responsePut.statusCode}');
    print('PUT Body: ${responsePut.body}');
  } catch(e) {
    print('Exception: $e');
  }
}
