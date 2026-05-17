import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CarruselApiService {
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  // Obtener todas las pestañas del carrusel
  Future<List<dynamic>> getCarrusel() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/carrusel'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error de conexión (getCarrusel): $e');
      return [];
    }
  }

  // Eliminar una pestaña del carrusel
  Future<bool> eliminarPestanaCarrusel(int idPestanaCarrusel, {int? idUsuarioActual}) async {
    try {
      final uri = Uri.parse('$baseUrl/carrusel/$idPestanaCarrusel');
      final response = await http.delete(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_usuario_actual": idUsuarioActual}),
      );

      if (response.statusCode == 200) {
        print('Pestaña Carrusel eliminada exitosamente');
        return true;
      } else {
        print('Error al eliminar pestaña carrusel: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (eliminarPestanaCarrusel): $e');
      return false;
    }
  }

  // Agregar una pestaña al carrusel (subiendo una imagen)
  // `imageFile` es el archivo local de la imagen
  Future<Map<String, dynamic>?> agregarPestanaCarrusel(File imageFile, String descripcion, {int? idUsuarioActual}) async {
    try {
      final uri = Uri.parse('$baseUrl/carrusel/carrusel_images');
      final request = http.MultipartRequest('POST', uri);
      request.fields['descripcion'] = descripcion;
      if (idUsuarioActual != null) request.fields['id_usuario_actual'] = idUsuarioActual.toString();
      request.files.add(await http.MultipartFile.fromPath('foto', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Error al agregar pestaña carrusel: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión (agregarPestanaCarrusel): $e');
      return null;
    }
  }

  // Actualizar pestaña del carrusel (url o descripción)
  Future<bool> actualizarPestanaCarrusel(int idPestanaCarrusel, String urlFoto, String descripcion, {int? idUsuarioActual}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/carrusel/$idPestanaCarrusel'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'url_foto': urlFoto,
          'descripcion': descripcion,
          'id_usuario_actual': idUsuarioActual
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al actualizar pestaña carrusel: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión (actualizarPestanaCarrusel): $e');
      return false;
    }
  }
}
