import 'package:signals_flutter/signals_flutter.dart';
import '../usecases/student_usecases.dart';
import '../../data/repositories/student_repository.dart';
import '../entities/student.dart';
import 'auth_facade.dart';

class StudentFacade {
  final IStudentRepository repository;
  final AuthFacade authFacade;
  late final Signal<Student?> lastChangedPerson = signal(null);

  StudentFacade({required this.repository, required this.authFacade});

  CreateStudentUseCase createStudentUseCase(
    String name,
    String course,
    int year,
    String nickname,
    DateTime birthDate,
  ) => CreateStudentUseCase(
        repository: repository,
        student: Student(
          name: name,
          course: course,
          year: year,
          nickname: nickname,
          birthDate: birthDate,
          createdBy: authFacade.currentUser?.uid,
        ),
      );

  GetAllStudentsUseCase get getAllStudents => GetAllStudentsUseCase(repository);

  GetStudentByIdUseCase getStudentByIdUseCase(String id) =>
      GetStudentByIdUseCase(repository: repository, studentId: id);

  UpdateStudentUseCase updateStudentUseCase(
    String id,
    String name,
    String course,
    int year,
    String nickname,
    DateTime birthDate,
  ) => UpdateStudentUseCase(
        repository: repository,
        student: Student(
          id: id,
          name: name,
          course: course,
          year: year,
          nickname: nickname,
          birthDate: birthDate,
          createdBy: authFacade.currentUser?.uid,
        ),
      );

  DeleteStudentUseCase deleteStudentUseCase(String id) =>
      DeleteStudentUseCase(repository: repository, studentId: id);
}
