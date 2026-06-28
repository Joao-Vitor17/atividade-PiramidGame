import '../../core/patterns/result.dart';
import '../../core/patterns/command.dart';
import '../entities/student.dart';
import '../../data/repositories/student_repository.dart';

// Create Student Use Case
class CreateStudentUseCase implements Command<Student> {
  final IStudentRepository repository;
  final Student student;

  CreateStudentUseCase({
    required this.repository,
    required this.student,
  });

  @override
  Future<Result<Student>> execute() async {
    try {
      if (student.name.isEmpty) {
        return Failure('Nome do aluno é obrigatório');
      }
      if (student.ratings.any((r) => r < 1 || r > 5)) {
        return Failure('Todas as notas devem estar entre 1 e 5');
      }
      await repository.addStudent(student);
      return Success(student);
    } catch (e) {
      return Failure('Erro ao criar aluno', exception: e as Exception);
    }
  }
}

// Get All Students Use Case
class GetAllStudentsUseCase implements Command<List<Student>> {
  final IStudentRepository repository;

  GetAllStudentsUseCase(this.repository);

  @override
  Future<Result<List<Student>>> execute() async {
    try {
      final students = await repository.getAllStudents();
      return Success(students);
    } catch (e) {
      return Failure('Erro ao buscar alunos', exception: e as Exception);
    }
  }
}

// Get Student By ID Use Case
class GetStudentByIdUseCase implements Command<Student> {
  final IStudentRepository repository;
  final String studentId;

  GetStudentByIdUseCase({
    required this.repository,
    required this.studentId,
  });

  @override
  Future<Result<Student>> execute() async {
    try {
      final student = await repository.getStudentById(studentId);
      if (student == null) {
        return Failure('Aluno não encontrado');
      }
      return Success(student);
    } catch (e) {
      return Failure('Erro ao buscar aluno', exception: e as Exception);
    }
  }
}

// Update Student Use Case
class UpdateStudentUseCase implements Command<Student> {
  final IStudentRepository repository;
  final Student student;

  UpdateStudentUseCase({
    required this.repository,
    required this.student,
  });

  @override
  Future<Result<Student>> execute() async {
    try {
      if (student.name.isEmpty) {
        return Failure('Nome do aluno é obrigatório');
      }
      if (student.ratings.any((r) => r < 1 || r > 5)) {
        return Failure('Todas as notas devem estar entre 1 e 5');
      }
      await repository.updateStudent(student);
      return Success(student);
    } catch (e) {
      return Failure('Erro ao atualizar aluno', exception: e as Exception);
    }
  }
}

// Delete Student Use Case
class DeleteStudentUseCase implements Command<void> {
  final IStudentRepository repository;
  final String studentId;

  DeleteStudentUseCase({
    required this.repository,
    required this.studentId,
  });

  @override
  Future<Result<void>> execute() async {
    try {
      await repository.deleteStudent(studentId);
      return Success(null);
    } catch (e) {
      return Failure('Erro ao deletar aluno', exception: e as Exception);
    }
  }
}

// Calculate Ranking Use Case
class CalculateRankingUseCase implements Command<List<Student>> {
  final IStudentRepository repository;

  CalculateRankingUseCase(this.repository);

  @override
  Future<Result<List<Student>>> execute() async {
    try {
      final students = await repository.getAllStudents();
      students.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
      return Success(students);
    } catch (e) {
      return Failure('Erro ao calcular ranking', exception: e as Exception);
    }
  }
}
