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
  late final Signal<List<int>> ratings = signal(List<int>.filled(15, 3));

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
    ratings.value = List<int>.from(student.ratings);
  }

  void updateRating(int index, int value) {
    final newRatings = List<int>.from(ratings.value);
    newRatings[index] = value;
    ratings.value = newRatings;
  }

  Future<Result<Student>> submit() async {
    if (editingStudent == null) {
      final useCase = facade.createStudentUseCase(
        name.value,
        course.value,
        year.value,
        nickname.value,
        birthDate.value,
        ratings.value,
      );
      final result = await useCase.execute();
      await submitCommand.call(useCase);
      return result;
    } else {
      final useCase = facade.updateStudentUseCase(
        editingStudent!.id!,
        name.value,
        course.value,
        year.value,
        nickname.value,
        birthDate.value,
        ratings.value,
      );
      final result = await useCase.execute();
      await submitCommand.call(useCase);
      return result;
    }
  }

  bool get isFormValid {
    return name.value.isNotEmpty && ratings.value.every((r) => r >= 1 && r <= 5);
  }

  int get totalPoints {
    return ratings.value.fold(0, (sum, rating) => sum + rating);
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
