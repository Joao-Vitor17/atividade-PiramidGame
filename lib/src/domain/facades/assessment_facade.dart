import 'package:signals_flutter/signals_flutter.dart';
import '../entities/assessment.dart';
import '../usecases/assessment_usecases.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../data/repositories/ranking_repository.dart';
import 'auth_facade.dart';

class AssessmentFacade {
  final IAssessmentRepository assessmentRepository;
  final IRankingRepository rankingRepository;
  final AuthFacade authFacade;
  late final Signal<Assessment?> lastChangedAssessment = signal(null);

  AssessmentFacade({
    required this.assessmentRepository,
    required this.rankingRepository,
    required this.authFacade,
  });

  SaveAssessmentUseCase save(String personId, List<int> ratings) =>
      SaveAssessmentUseCase(
        assessmentRepository,
        authFacade.currentUser?.uid ?? '',
        personId,
        ratings,
      );

  GetAssessmentUseCase getForPerson(String personId) =>
      GetAssessmentUseCase(
        assessmentRepository,
        authFacade.currentUser?.uid ?? '',
        personId,
      );

  GetPersonalRankingUseCase get personalRanking =>
      GetPersonalRankingUseCase(
        rankingRepository,
        authFacade.currentUser?.uid ?? '',
      );

  GetGlobalRankingUseCase get globalRanking =>
      GetGlobalRankingUseCase(rankingRepository);

  void notifyAssessmentSaved(Assessment assessment) {
    lastChangedAssessment.value = assessment;
  }
}