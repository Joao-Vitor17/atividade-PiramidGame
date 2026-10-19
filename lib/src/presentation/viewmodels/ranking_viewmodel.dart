import 'package:signals_flutter/signals_flutter.dart';
import '../../core/patterns/command.dart';
import '../../domain/entities/ranking_entry.dart';
import '../../domain/facades/assessment_facade.dart';

class RankingViewModel {
  final AssessmentFacade facade;
  final personalCommand = CommandNotifier<List<RankingEntry>>();
  final globalCommand = CommandNotifier<List<RankingEntry>>();

  RankingViewModel({required this.facade}) {
    effect(() {
      if (facade.lastChangedAssessment.value != null) {
        loadPersonal();
        loadGlobal();
      }
    });
  }

  Future<void> loadPersonal() => personalCommand.call(facade.personalRanking);
  Future<void> loadGlobal() => globalCommand.call(facade.globalRanking);
}