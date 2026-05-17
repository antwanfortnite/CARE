import 'package:http/http.dart' as http;
import 'dart:convert';

class DatosGeneralesApiService {
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  Future<List<dynamic>> getDatos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/datos'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de conexión (getDatos): $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> crearDatos(String direccion, String correo, String telefono, {int? idUsuarioActual}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/datos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'direccion': direccion,
          'correo': correo,
          'telefono': telefono,
          'id_usuario_actual': idUsuarioActual
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Error al crear datos generales: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión (crearDatos): $e');
      return null;
    }
  }

  Future<bool> actualizarDatos(int id, String direccion, String correo, String telefono, {int? idUsuarioActual}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/datos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'direccion': direccion,
          'correo': correo,
          'telefono': telefono,
          'id_usuario_actual': idUsuarioActual
        }),
      );

      if (response.statusCode == 200) return true;
      print('Error al actualizar datos generales: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Error de conexión (actualizarDatos): $e');
      return false;
    }
  }

  Future<bool> eliminarDatos(int id, {int? idUsuarioActual}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/datos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_usuario_actual': idUsuarioActual}),
      );

      if (response.statusCode == 200) return true;
      print('Error al eliminar datos generales: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Error de conexión (eliminarDatos): $e');
      return false;
    }
  }
}
