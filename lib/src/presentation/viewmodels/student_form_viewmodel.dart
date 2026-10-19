import 'package:signals_flutter/signals_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../domain/facades/student_facade.dart';
import '../../domain/entities/student.dart';

class StudentFormViewModel {
  final StudentFacade facade;
  final Student? editingStudent;

  late final Signal<String> name = signal('');
  late final Signal<String> nickname = signal('');
  late final Signal<String> course = signal(AppConstants.courses.first);
  late final Signal<int> year = signal(AppConstants.maxYear);
  late final Signal<DateTime> birthDate = signal(DateTime.now());

  late final CommandNotifier<Student> submitCommand = CommandNotifier();

  StudentFormViewModel({
    required this.facade,
    this.editingStudent,
  }) {
    if (editingStudent != null) {
      _loadStudentData(editingStudent!);
    }
  }

  void _loadStudentData(Student student) {
    name.value = student.name;
    nickname.value = student.nickname;
    course.value = student.course;
    year.value = student.year;
    birthDate.value = student.birthDate;
  }

  Future<Result<Student>> submit() async {
    if (editingStudent == null) {
      final useCase = facade.createStudentUseCase(
        name.value,
        course.value,
        year.value,
        nickname.value,
        birthDate.value,
      );
      await submitCommand.call(useCase);
      final result = submitCommand.state.value;
      if (result is SuccessCommandState<Student>) {
        facade.lastChangedPerson.value = result.data;
        return Success(result.data);
      }
      return const Failure('Erro ao criar aluno');
    } else {
      final useCase = facade.updateStudentUseCase(
        editingStudent!.id!,
        name.value,
        course.value,
        year.value,
        nickname.value,
        birthDate.value,
      );
      await submitCommand.call(useCase);
      final result = submitCommand.state.value;
      if (result is SuccessCommandState<Student>) {
        facade.lastChangedPerson.value = result.data;
        return Success(result.data);
      }
      return const Failure('Erro ao atualizar aluno');
    }
  }

  bool get isFormValid {
    return name.value.trim().isNotEmpty;
  }

  bool get isLoading => submitCommand.state.value.isLoading;
  bool get isError => submitCommand.state.value.isError;
  String? get errorMessage {
    if (submitCommand.state.value is ErrorCommandState<Student>) {
      return (submitCommand.state.value as ErrorCommandState<Student>).message;
    }
    return null;
  }
}
