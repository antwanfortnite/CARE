import 'package:http/http.dart' as http;
import 'dart:convert';

class MaestrosApiService {
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  // Obtener lista de maestros
  Future<List<dynamic>> getMaestros() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/maestros'));

      if (response.statusCode == 200) {
        List<dynamic> maestros = jsonDecode(response.body);
        return maestros;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error de conexión (getMaestros): $e');
      return [];
    }
  }

  // Agregar un maestro
  Future<bool> agregarMaestro(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/maestros'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Maestro guardado exitosamente');
        return true;
      } else {
        print('Error al guardar maestro: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (agregarMaestro): $e');
      return false;
    }
  }

  // Actualizar un maestro
  Future<bool> actualizarMaestro(
    int idMaestro,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/maestros/$idMaestro'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Maestro actualizado exitosamente');
        return true;
      } else {
        print('Error al actualizar maestro: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (actualizarMaestro): $e');
      return false;
    }
  }

  // Eliminar un maestro (Eliminado Lógico)
  Future<bool> eliminarMaestro(int idMaestro, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/maestros/$idMaestro'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Maestro eliminado (lógicamente) exitosamente');
        return true;
      } else {
        print('Error al eliminar maestro: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (eliminarMaestro): $e');
      return false;
    }
  }
}
