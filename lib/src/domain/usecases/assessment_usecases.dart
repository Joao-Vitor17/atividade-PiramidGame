import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../data/repositories/ranking_repository.dart';
import '../entities/assessment.dart';
import '../entities/ranking_entry.dart';

class SaveAssessmentUseCase implements Command<Assessment> {
  final IAssessmentRepository repository;
  final String evaluatorUid;
  final String personId;
  final List<int> ratings;

  SaveAssessmentUseCase(this.repository, this.evaluatorUid, this.personId, this.ratings);

  @override
  Future<Result<Assessment>> execute() async {
    if (evaluatorUid.isEmpty) return const Failure('Entre para registrar uma avaliação.');
    if (ratings.length != 15 || ratings.any((rating) => rating < 1 || rating > 5)) {
      return const Failure('Cada critério deve receber de 1 a 5 estrelas.');
    }
    try {
      final assessment = Assessment(
        id: '${evaluatorUid}_$personId',
        evaluatorUid: evaluatorUid,
        personId: personId,
        ratings: List<int>.from(ratings),
        assessedAt: DateTime.now(),
      );
      await repository.save(assessment);
      return Success(assessment);
    } catch (error) {
      return Failure(error.toString(), exception: error is Exception ? error : null);
    }
  }
}

class GetAssessmentUseCase implements Command<Assessment?> {
  final IAssessmentRepository repository;
  final String evaluatorUid;
  final String personId;

  GetAssessmentUseCase(this.repository, this.evaluatorUid, this.personId);

  @override
  Future<Result<Assessment?>> execute() async {
    try {
      return Success(await repository.getForPerson(evaluatorUid, personId));
    } catch (error) {
      return Failure('Não foi possível carregar sua avaliação.', exception: error is Exception ? error : null);
    }
  }
}

class GetPersonalRankingUseCase implements Command<List<RankingEntry>> {
  final IRankingRepository repository;
  final String evaluatorUid;

  GetPersonalRankingUseCase(this.repository, this.evaluatorUid);

  @override
  Future<Result<List<RankingEntry>>> execute() async {
    try {
      return Success(await repository.getPersonal(evaluatorUid));
    } catch (error) {
      return Failure('Não foi possível carregar o ranking pessoal.', exception: error is Exception ? error : null);
    }
  }
}

class GetGlobalRankingUseCase implements Command<List<RankingEntry>> {
  final IRankingRepository repository;

  GetGlobalRankingUseCase(this.repository);

  @override
  Future<Result<List<RankingEntry>>> execute() async {
    try {
      return Success(await repository.getGlobal());
    } catch (error) {
      return Failure('Não foi possível carregar o ranking global.', exception: error is Exception ? error : null);
    }
  }
}