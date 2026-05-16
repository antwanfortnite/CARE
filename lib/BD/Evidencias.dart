import 'package:http/http.dart' as http;
import 'dart:convert';

class EvidenciasApiService {
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  // Obtener todas las evidencias
  Future<List<dynamic>> getEvidencias() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/evidencias'));

      if (response.statusCode == 200) {
        List<dynamic> evidencias = jsonDecode(response.body);
        return evidencias;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error de conexión (getEvidencias): $e');
      return [];
    }
  }

  // Eliminar una evidencia
  Future<bool> eliminarEvidencia(int idEvidencia, int idUsuarioActual) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/evidencias/$idEvidencia'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_usuario_actual": idUsuarioActual}),
      );

      if (response.statusCode == 200) {
        print('Evidencia eliminada exitosamente');
        return true;
      } else {
        print('Error al eliminar evidencia: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (eliminarEvidencia): $e');
      return false;
    }
  }

  // Agregar una evidencia
  Future<bool> agregarEvidencia(Map<String, dynamic> data, int idUsuarioActual) async {
    try {
      data['id_usuario_actual'] = idUsuarioActual;
      final response = await http.post(
        Uri.parse('$baseUrl/evidencias'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error al agregar evidencia: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (agregarEvidencia): $e');
      return false;
    }
  }
}
