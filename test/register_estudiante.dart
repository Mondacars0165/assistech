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
      apiService = ApiService('http://192.168.1.10:3000', MockClient());
    });

    test('Registro Exitoso de Estudiante', () async {
    
      final rut = generateRandomNumberString(8);
      final password = generateRandomString(8);
      final rol_id = "2";

      final response = await apiService.register(rut, password, rol_id);
      expect(response['message'], 'Usuario registrado con éxito');
    });
  });
}
class MockClient extends Mock implements http.Client {}
String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

String generateRandomNumberString(int length) {
  final random = Random();
  return List.generate(length, (_) => random.nextInt(10)).join();
}
