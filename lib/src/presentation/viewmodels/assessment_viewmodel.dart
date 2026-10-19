import 'package:signals_flutter/signals_flutter.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/facades/assessment_facade.dart';

class AssessmentViewModel {
  final AssessmentFacade facade;
  final String personId;
  late final Signal<List<int>> ratings = signal(List<int>.filled(15, 3));
  late final CommandNotifier<Assessment?> loadCommand = CommandNotifier();
  late final CommandNotifier<Assessment> saveCommand = CommandNotifier();

  AssessmentViewModel({required this.facade, required this.personId}) {
    _load();
  }

  Future<void> _load() async {
    await loadCommand.call(facade.getForPerson(personId));
    final state = loadCommand.state.value;
    if (state is SuccessCommandState<Assessment?> && state.data != null) {
      ratings.value = List<int>.from(state.data!.ratings);
    }
  }

  void updateRating(int index, int rating) {
    final updated = List<int>.from(ratings.value);
    updated[index] = rating;
    ratings.value = updated;
  }

  Future<Result<Assessment>> save() async {
    await saveCommand.call(facade.save(personId, ratings.value));
    final result = saveCommand.state.value;
    if (result is SuccessCommandState<Assessment>) {
      facade.notifyAssessmentSaved(result.data);
      return Success(result.data);
    }
    if (result is ErrorCommandState<Assessment>) return Failure(result.message);
    return const Failure('Não foi possível salvar a avaliação.');
  }

  int get totalPoints => ratings.value.fold(0, (sum, rating) => sum + rating);
  bool get isLoading => loadCommand.state.value.isLoading || saveCommand.state.value.isLoading;
  bool get hasExistingAssessment =>
      loadCommand.state.value is SuccessCommandState<Assessment?> &&
      (loadCommand.state.value as SuccessCommandState<Assessment?>).data != null;
  String? get errorMessage {
    final state = saveCommand.state.value;
    if (state is ErrorCommandState<Assessment>) return state.message;
    final loadState = loadCommand.state.value;
    if (loadState is ErrorCommandState<Assessment?>) return loadState.message;
    return null;
  }
}