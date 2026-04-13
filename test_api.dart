import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final stamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  final data = {
    'nombre_completo': 'Mtro. Prueba $stamp',
    'correo_electronico': 'prueba$stamp@ejemplo.com',
    'telefono': '555$stamp',
    'curp': 'XXXYY9$stamp',
    'fecha_nacimiento': '1980-05-15',
    'fecha_contratacion': '2023-01-10',
    'edad': 40,
    'pin_acceso': '1234',
    'estado': 1,
  };
  
  final baseUrl = 'http://157.137.190.243:3000/api';
  print('Sending POST to $baseUrl/maestros');
  print('Payload: ${jsonEncode(data)}');
  
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/maestros'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch(e) {
    print('Exception: $e');
  }
}
