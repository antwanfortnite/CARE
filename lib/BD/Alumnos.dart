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

  // Función para obtener la lista de padres
  Future<List<dynamic>> getPadres() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/padres'));

      if (response.statusCode == 200) {
        List<dynamic> padres = jsonDecode(response.body);
        return padres;
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocurrió un error de conexión al obtener padres: $e');
      return [];
    }
  }

  // Agregar un padre y retornar su ID
  Future<int?> agregarPadre(
    String nombre,
    String correo,
    String telefono,
    String pin,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/padres'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre_padre": nombre,
          "email": correo,
          "contacto": telefono,
          "pin_acceso": pin,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Padre guardado exitosamente');

        // --- AGREGA ESTE PRINT PARA DEBUGEAR ---
        print('RESPUESTA DEL SERVIDOR: ${response.body}');
        // ---------------------------------------

        final data = jsonDecode(response.body);

        // Dependiendo de lo que imprima el log de arriba, ajusta esta línea.
        // Ejemplo: Si imprime {"success": true, "nuevoPadreId": 5}, cambiarías a data['nuevoPadreId']
        return data['id_nuevo'] ??
            data['id'] ??
            data['id_padre'] ??
            data['insertId'];
      } else {
        print(
          'Error al guardar padre: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Error de conexión al guardar padre: $e');
      return null;
    }
  }

  // Agregar un alumno (ahora incluye fecha_nacimiento y estado)
  Future<bool> agregarAlumno(
    int idPadre,
    String nombre,
    String curp,
    String pin,
    String fechaNacimiento, {
    int estado = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alumnos'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_padre": idPadre,
          "nombre_completo": nombre,
          "curp": curp,
          "pin_acceso": pin,
          "fecha_nacimiento": fechaNacimiento,
          "estado": estado,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Alumno guardado exitosamente en la base de datos');
        return true;
      } else {
        print(
          'Error al guardar alumno: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error de conexión al guardar alumno: $e');
      return false;
    }
  }

  // Actualizar un alumno
  Future<bool> actualizarAlumno(
    int idAlumno,
    String nombre,
    String curp,
    int estado,
    String fechaNacimiento,
    int? idGrupo, {
    int? idPadre,
  }) async {
    try {
      final bodyData = <String, dynamic>{
        "nombre_completo": nombre,
        "curp": curp,
        "estado": estado,
        "fecha_nacimiento": fechaNacimiento,
        "id_grupo": idGrupo,
      };
      if (idPadre != null) {
        bodyData["id_padre"] = idPadre;
      }
      
      final response = await http.put(
        Uri.parse('$baseUrl/alumnos/$idAlumno'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al actualizar alumno: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de conexión al actualizar alumno: $e');
      return false;
    }
  }

  // Actualizar un padre
  Future<bool> actualizarPadre(
    int idPadre,
    String nombre,
    String correo,
    String telefono,
    String pin,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/padres/$idPadre'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre_padre": nombre,
          "email": correo,
          "contacto": telefono,
          "pin_acceso": pin,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error al actualizar padre: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de conexión al actualizar padre: $e');
      return false;
    }
  }
}
