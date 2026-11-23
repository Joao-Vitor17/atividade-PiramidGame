import 'package:signals_flutter/signals_flutter.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../data/services/student_photo_storage_service.dart';
import '../../domain/facades/student_facade.dart';
import '../../domain/entities/student.dart';

class StudentDetailViewModel {
  final StudentFacade facade;
  final StudentPhotoStorageService photoStorageService;

  late final CommandNotifier<Student> loadStudentCommand = CommandNotifier();
  late final Signal<Student?> _student = signal(null);
  late final Signal<bool> _isUploadingPhoto = signal(false);

  StudentDetailViewModel({
    required this.facade,
    required this.photoStorageService,
    required String studentId,
  }) {
    _initialize(studentId);
  }

  Future<void> _initialize(String studentId) async {
    final useCase = facade.getStudentByIdUseCase(studentId);
    await loadStudentCommand.call(useCase);
    final result = loadStudentCommand.state.value;
    if (result is SuccessCommandState<Student>) {
      _student.value = result.data;
    }
  }

  Student? get student => _student.value;

  bool get isLoading => loadStudentCommand.state.value.isLoading;
  bool get isError => loadStudentCommand.state.value.isError;
  bool get isUploadingPhoto => _isUploadingPhoto.value;

  Future<Result<void>> changePhoto() async {
    final person = student;
    if (person == null || person.id == null) {
      return const Failure('Pessoa não encontrada para atualizar a foto.');
    }

    final image = await photoStorageService.pickPhoto();
    if (image == null) return const Success(null);

    _isUploadingPhoto.value = true;
    try {
      final photoUrl = await photoStorageService.uploadPhoto(
        studentId: person.id!,
        image: image,
      );
      final result = await facade
          .updateStudentPhotoUseCase(person, photoUrl)
          .execute();
      final failure = result.failureOrNull;
      if (failure != null) return failure;

      final updatedPerson = result.valueOrNull!;
      _student.value = updatedPerson;
      facade.lastChangedPerson.value = updatedPerson;
      return const Success(null);
    } finally {
      _isUploadingPhoto.value = false;
    }
  }

  String? get errorMessage {
    if (loadStudentCommand.state.value is ErrorCommandState<Student>) {
      return (loadStudentCommand.state.value as ErrorCommandState<Student>)
          .message;
    }
    return null;
  }
}
