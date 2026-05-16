import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardApiService {
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  /// Obtiene el resumen de datos (total alumnos, maestros, grupos activos)
  Future<Map<String, dynamic>?> getResumen() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/resumen'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error al obtener resumen: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de conexión al obtener resumen: $e');
      return null;
    }
  }

  /// Obtiene los últimos 10 movimientos de la bitácora
  Future<List<dynamic>> getBitacoraReciente() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bitacora/reciente'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error al obtener bitácora: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error de conexión al obtener bitácora: $e');
      return [];
    }
  }
}
