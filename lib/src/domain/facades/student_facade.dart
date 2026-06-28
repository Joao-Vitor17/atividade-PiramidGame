import '../usecases/student_usecases.dart';
import '../../data/repositories/student_repository.dart';
import '../entities/student.dart';

class StudentFacade {
  final IStudentRepository repository;

  late final CreateStudentUseCase createStudent;
  late final GetAllStudentsUseCase getAllStudents;
  late final GetStudentByIdUseCase getStudentById;
  late final UpdateStudentUseCase updateStudent;
  late final DeleteStudentUseCase deleteStudent;
  late final CalculateRankingUseCase calculateRanking;

  StudentFacade(this.repository) {
    createStudent = CreateStudentUseCase(repository: repository, student: _dummyStudent());
    getAllStudents = GetAllStudentsUseCase(repository);
    getStudentById = GetStudentByIdUseCase(repository: repository, studentId: '');
    updateStudent = UpdateStudentUseCase(repository: repository, student: _dummyStudent());
    deleteStudent = DeleteStudentUseCase(repository: repository, studentId: '');
    calculateRanking = CalculateRankingUseCase(repository);
  }

  // Helper methods
  CreateStudentUseCase createStudentUseCase(
    String name,
    String course,
    int year,
    String nickname,
    DateTime birthDate,
    List<int> ratings,
  ) {
    final student = Student(
      name: name,
      course: course,
      year: year,
      nickname: nickname,
      birthDate: birthDate,
      ratings: ratings,
    );
    return CreateStudentUseCase(repository: repository, student: student);
  }

  GetStudentByIdUseCase getStudentByIdUseCase(String studentId) {
    return GetStudentByIdUseCase(repository: repository, studentId: studentId);
  }

  UpdateStudentUseCase updateStudentUseCase(
    String id,
    String name,
    String course,
    int year,
    String nickname,
    DateTime birthDate,
    List<int> ratings,
  ) {
    final student = Student(
      id: id,
      name: name,
      course: course,
      year: year,
      nickname: nickname,
      birthDate: birthDate,
      ratings: ratings,
    );
    return UpdateStudentUseCase(repository: repository, student: student);
  }

  DeleteStudentUseCase deleteStudentUseCase(String studentId) {
    return DeleteStudentUseCase(repository: repository, studentId: studentId);
  }
}

Student _dummyStudent() {
  return Student(
    name: '',
    course: 'INFO',
    year: 2024,
    nickname: '',
    birthDate: DateTime.now(),
    ratings: List.filled(15, 1),
  );
}
