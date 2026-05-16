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
  /// Obtiene el resumen de datos de un maestro específico
  Future<Map<String, dynamic>?> getResumenMaestro(int idMaestro) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/dashboard/maestro/$idMaestro/resumen'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error al obtener resumen maestro: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de conexión al obtener resumen maestro: $e');
      return null;
    }
  }

  /// Obtiene los últimos movimientos de bitácora de evidencias de un maestro
  Future<List<dynamic>> getBitacoraMaestroEvidencias(int idMaestro) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/bitacora/maestro/$idMaestro/evidencias'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error al obtener bitácora maestro: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error de conexión al obtener bitácora maestro: $e');
      return [];
    }
  }
}
