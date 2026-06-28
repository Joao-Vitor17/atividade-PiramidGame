import 'package:signals_flutter/signals_flutter.dart';
import '../../core/patterns/command.dart';
import '../../domain/facades/student_facade.dart';
import '../../domain/entities/student.dart';

class StudentDetailViewModel {
  final StudentFacade facade;

  late final CommandNotifier<Student> loadStudentCommand = CommandNotifier();

  StudentDetailViewModel({
    required this.facade,
    required String studentId,
  }) {
    _initialize(studentId);
  }

  void _initialize(String studentId) async {
    final useCase = facade.getStudentByIdUseCase(studentId);
    await loadStudentCommand.call(useCase);
  }

  Student? get student {
    if (loadStudentCommand.state.value is SuccessCommandState<Student>) {
      return (loadStudentCommand.state.value as SuccessCommandState<Student>).data;
    }
    return null;
  }

  bool get isLoading => loadStudentCommand.state.value.isLoading;
  bool get isError => loadStudentCommand.state.value.isError;
  String? get errorMessage {
    if (loadStudentCommand.state.value is ErrorCommandState<Student>) {
      return (loadStudentCommand.state.value as ErrorCommandState<Student>).message;
    }
    return null;
  }
}
