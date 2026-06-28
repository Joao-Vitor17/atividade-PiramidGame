import 'dart:convert';
import '../services/storage_service.dart';
import '../../domain/entities/student.dart';
import '../../core/constants/app_constants.dart';

abstract class IStudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<void> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
}

class StudentRepository implements IStudentRepository {
  final IStorageService storageService;

  StudentRepository(this.storageService);

  @override
  Future<List<Student>> getAllStudents() async {
    try {
      final jsonString = await storageService.getString(AppConstants.studentListKey);
      if (jsonString == null) {
        return [];
      }
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Student.fromMap(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Student?> getStudentById(String id) async {
    try {
      final students = await getAllStudents();
      return students.firstWhere(
        (student) => student.id == id,
        orElse: () => throw Exception('Student not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addStudent(Student student) async {
    try {
      final students = await getAllStudents();
      final newStudent = student.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      students.add(newStudent);
      await _saveStudents(students);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    try {
      final students = await getAllStudents();
      final index = students.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        students[index] = student;
        await _saveStudents(students);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    try {
      final students = await getAllStudents();
      students.removeWhere((student) => student.id == id);
      await _saveStudents(students);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveStudents(List<Student> students) async {
    final jsonString = jsonEncode(students.map((s) => s.toMap()).toList());
    await storageService.saveString(AppConstants.studentListKey, jsonString);
  }
}
