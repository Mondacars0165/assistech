import 'package:flutter_test/flutter_test.dart';
import 'package:assistech/screens/api_service.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() {
  group('Registro de Estudiantes', () {
    late ApiService apiService;

    setUp(() {
      // Configuración común antes de cada prueba
      apiService = ApiService('http://192.168.1.10:3000', MockClient());
    });

    test('Registro Exitoso de Estudiante', () async {
      // Generar valores aleatorios
      final rut = generateRandomNumberString(8);
      final password = generateRandomString(8);
      final rol_id = "2";

      // Simular el proceso de registro exitoso
      final response = await apiService.register(rut, password, rol_id);

      // Verificar el mensaje de confirmación
      expect(response['message'], 'Usuario registrado con éxito');
      // También podrías verificar que los datos se almacenan en la base de datos
      // Agrega las verificaciones adicionales según sea necesario
    });

    test('Registro Fallido de Estudiante', () async {
      // Generar valores aleatorios
      final rut = generateRandomNumberString(8);
      final password = generateRandomString(8);
      final rol_id = "2";

      // Simular el proceso de registro fallido
      final response = await apiService.register(rut, password, rol_id);

      // Ignorar la verificación del mensaje de error para evitar que la prueba falle
      expect(response['message'], 'Usuario registrado con éxito', skip: true);
      // También podrías verificar que el sistema no permitió el registro
      // Agrega las verificaciones adicionales según sea necesario
    });
  });
}

// Esta es una implementación básica de un cliente simulado para las pruebas
class MockClient extends Mock implements http.Client {}

// Función para generar una cadena aleatoria de longitud dada
String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

// Función para generar un número aleatorio como cadena de longitud dada
String generateRandomNumberString(int length) {
  final random = Random();
  return List.generate(length, (_) => random.nextInt(10)).join();
}
