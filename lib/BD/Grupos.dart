import 'package:http/http.dart' as http;
import 'dart:convert';

class GruposApiService {
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  // Obtener lista de grupos
  Future<List<dynamic>> getGrupos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/grupos'));

      if (response.statusCode == 200) {
        List<dynamic> grupos = jsonDecode(response.body);
        return grupos;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error de conexión (getGrupos): $e');
      return [];
    }
  }

  // Agregar un grupo
  Future<int?> agregarGrupo(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/grupos'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Grupo guardado exitosamente');
        final responseData = jsonDecode(response.body);
        
        // Retornar el ID del nuevo grupo creado
        return responseData['id_nuevo'] ??
            responseData['id'] ??
            responseData['id_grupo'] ??
            responseData['insertId'];
      } else {
        print('Error al guardar grupo: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión (agregarGrupo): $e');
      return null;
    }
  }
}
