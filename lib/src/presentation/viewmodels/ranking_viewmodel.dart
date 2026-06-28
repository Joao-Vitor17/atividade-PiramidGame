import 'package:signals_flutter/signals_flutter.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../domain/facades/student_facade.dart';
import '../../domain/entities/student.dart';

class RankingViewModel {
  final StudentFacade facade;

  late final CommandNotifier<List<Student>> loadRankingCommand = CommandNotifier();

  RankingViewModel({required this.facade}) {
    _initialize();
  }

  void _initialize() {
    loadRanking();
  }

  Future<void> loadRanking() async {
    await loadRankingCommand.call(facade.calculateRanking);
  }

  List<Student> get ranking {
    if (loadRankingCommand.state.value is SuccessCommandState<List<Student>>) {
      return (loadRankingCommand.state.value as SuccessCommandState<List<Student>>).data;
    }
    return [];
  }

  bool get isLoading => loadRankingCommand.state.value.isLoading;
  bool get isError => loadRankingCommand.state.value.isError;
  String? get errorMessage {
    if (loadRankingCommand.state.value is ErrorCommandState<List<Student>>) {
      return (loadRankingCommand.state.value as ErrorCommandState<List<Student>>).message;
    }
    return null;
  }
}
