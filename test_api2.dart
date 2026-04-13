import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final stamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  final data = {
    'nombre_completo': 'Mtro. Prueba $stamp',
    'correo_electronico': 'prueba$stamp@ejemplo.com',
    'telefono': '555$stamp',
    'curp': 'XXYY9$stamp',
    'fecha_nacimiento': '1980-05-15',
    'fecha_contratacion': '2023-01-10',
    'edad': 40,
    'pin_acceso': '1234'
  };
  
  final baseUrl = 'http://157.137.190.243:3000/api';
  
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/maestros'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    print('WO ESTADO Status: ${response.statusCode}');
    print('WO ESTADO Body: ${response.body}');
    
    data['estado'] = true;
    final r2 = await http.post(
      Uri.parse('$baseUrl/maestros'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    print('WITH ESTADO TRUE Status: ${r2.statusCode}');
    print('WITH ESTADO TRUE Body: ${r2.body}');

  } catch(e) {
    print('Exception: $e');
  }
}
