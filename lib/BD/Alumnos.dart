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

  // Agregar un padre y retornar su ID
  Future<int?> agregarPadre(String nombre, String correo, String telefono) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/padres'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre_padre": nombre,
          "email": correo,
          "contacto": telefono
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Padre guardado exitosamente');
        final data = jsonDecode(response.body);
        // Intentar obtener el ID generado del padre (puede variar según el backend)
        return data['id'] ?? data['id_padre'] ?? data['insertId'];
      } else {
        print('Error al guardar padre: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión al guardar padre: $e');
      return null;
    }
  }

  // Agregar un alumno (ahora incluye fecha_nacimiento)
  Future<bool> agregarAlumno(int idPadre, String nombre, String curp, String pin, String fechaNacimiento) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alumnos'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_padre": idPadre,
          "nombre_completo": nombre,
          "curp": curp,
          "pin_acceso": pin,
          "fecha_nacimiento": fechaNacimiento
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Alumno guardado exitosamente en la base de datos');
        return true;
      } else {
        print('Error al guardar alumno: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión al guardar alumno: $e');
      return false;
    }
  }
}