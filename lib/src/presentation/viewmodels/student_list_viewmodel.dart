import 'package:signals_flutter/signals_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../domain/facades/student_facade.dart';
import '../../domain/entities/student.dart';

class StudentListViewModel {
  final StudentFacade facade;

  late final CommandNotifier<List<Student>> loadStudentsCommand = CommandNotifier();

  StudentListViewModel({required this.facade}) {
    _initialize();
  }

  void _initialize() {
    loadStudents();
  }

  Future<void> loadStudents() async {
    await loadStudentsCommand.call(facade.getAllStudents);
  }

  Future<void> deleteStudent(String studentId) async {
    final useCase = facade.deleteStudentUseCase(studentId);
    final result = await useCase.execute();
    result.fold(
        (failure) => debugPrint('Error: ${failure.message}'),
      (success) => loadStudents(),
    );
  }

  List<Student> get students {
    if (loadStudentsCommand.state.value is SuccessCommandState<List<Student>>) {
      return (loadStudentsCommand.state.value as SuccessCommandState<List<Student>>).data;
    }
    return [];
  }

  bool get isLoading => loadStudentsCommand.state.value.isLoading;
  bool get isError => loadStudentsCommand.state.value.isError;
  String? get errorMessage {
    if (loadStudentsCommand.state.value is ErrorCommandState<List<Student>>) {
      return (loadStudentsCommand.state.value as ErrorCommandState<List<Student>>).message;
    }
    return null;
  }
}
