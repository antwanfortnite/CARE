import 'package:http/http.dart' as http;
import 'dart:convert';

class AdministradoresApiService {
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  // Obtener lista de administradores
  Future<List<dynamic>> getAdministradores() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usuarios'));

      if (response.statusCode == 200) {
        List<dynamic> administradores = jsonDecode(response.body);
        return administradores;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error de conexión (getAdministradores): $e');
      return [];
    }
  }

  // Agregar un administrador
  Future<bool> agregarAdministrador(Map<String, dynamic> data, {int? idUsuarioActual}) async {
    try {
      if (idUsuarioActual != null) {
        data['id_usuario_actual'] = idUsuarioActual;
      }
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Administrador agregado exitosamente');
        return true;
      } else {
        print('Error al guardar administrador: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (agregarAdministrador): $e');
      return false;
    }
  }

  // Actualizar un administrador
  Future<bool> actualizarAdministrador(int idUsuario, Map<String, dynamic> data, {int? idUsuarioActual}) async {
    try {
      if (idUsuarioActual != null) {
        data['id_usuario_actual'] = idUsuarioActual;
      }
      final response = await http.put(
        Uri.parse('$baseUrl/usuarios/$idUsuario'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Administrador actualizado exitosamente');
        return true;
      } else {
        print('Error al actualizar administrador: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (actualizarAdministrador): $e');
      return false;
    }
  }

  // Eliminar un administrador
  Future<bool> eliminarAdministrador(int idUsuario, {int? idUsuarioActual}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/usuarios/$idUsuario'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_usuario_actual": idUsuarioActual ?? 0}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Administrador eliminado exitosamente');
        return true;
      } else {
        print('Error al eliminar administrador: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (eliminarAdministrador): $e');
      return false;
    }
  }
}
