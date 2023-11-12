import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
void main() async {
  // Obtén el valor de professorId desde el inicio de sesión
  String professorId = await getProfessorIdFromLogin();

  runApp(MaterialApp(
    home: StudentsListScreen(
      professorId: professorId,
      clasesProfesor: [], // Puedes proporcionar una lista vacía aquí
    ),
  ));
}


Future<String> getProfessorIdFromLogin() async {
  try {
    final response = await http.get(Uri.parse('${AppConfig.apiUrlDev}/login'));

    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final professorId = data['id_profesor'];
      return professorId;
    } else {
      throw Exception('Error al obtener la ID del profesor');
    }
  } catch (e) {
    throw Exception('Error al obtener la ID del profesor: $e');
  }
}

class StudentsListScreen extends StatefulWidget {
  final String professorId;
  final List<dynamic> clasesProfesor; // Declarar clasesProfesor como un parámetro

  StudentsListScreen({
    required this.professorId,
    required this.clasesProfesor, // Agregar clasesProfesor como un parámetro
  });

  @override
  _StudentsListScreenState createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  final DatabaseService databaseService = DatabaseService();
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final loadedStudents = await databaseService.getStudents(widget.professorId); // Usamos widget.professorId
      setState(() {
        students = loadedStudents;
      });
    } catch (e) {
      print('Error al cargar estudiantes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Estudiantes'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text(student.rut),
            // Agrega cualquier otro dato que desees mostrar para cada estudiante.
          );
        },
      ),
    );
  }
}

class Student {
  final String name;
  final String rut;

  Student({required this.name, required this.rut});
}

class DatabaseService {
  final String apiUrl = '${AppConfig.apiUrlDev}/estudiantes-en-sala/';


  Future<List<Student>> getStudents(String professorId) async { // Cambiamos el parámetro a String
    try {
      final response = await http.get(Uri.parse('$apiUrl$professorId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Student> students = data.map((studentData) {
          return Student(
            name: studentData['nombre'],
            rut: studentData['rut'],
            // Agrega otros campos según tu estructura de datos en la base de datos
          );
        }).toList();

        return students;
      } else {
        throw Exception('Error al cargar estudiantes desde la base de datos.');
      }
    } catch (e) {
      throw Exception('Error al cargar estudiantes: $e');
    }
  }
}
