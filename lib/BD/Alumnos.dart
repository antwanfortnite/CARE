import 'package:http/http.dart' as http;
import 'dart:convert'; // Para decodificar el JSON

class ApiService {
  // Cambia esto por la IP real de nuestro servidor
  static const String baseUrl = 'http://157.137.190.243:3000/api';

  // Función para obtener la lista de alumnos
  Future<List<dynamic>> getAlumnos() async {
    try {
      // 1. Hacemos la llamada al servidor
      final response = await http.get(Uri.parse('$baseUrl/alumnos'));

      // 2. Revisamos si el servidor respondió con "Éxito" (Código 200)
      if (response.statusCode == 200) {
        // 3. Convertimos el texto JSON a una lista que Flutter entienda
        List<dynamic> alumnos = jsonDecode(response.body);
        return alumnos;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error de conexión: $e');
      return [];
    }
  }

  Future<void> agregarAlumno(int idPadre, String nombre, String curp, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alumnos'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_padre": idPadre,
          "nombre_completo": nombre,
          "curp": curp,
          "pin_acceso": pin
        }),
      );

      if (response.statusCode == 200) {
        print('Alumno guardado exitosamente en la base de datos');
      } else {
        print('Error al guardar: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }
}