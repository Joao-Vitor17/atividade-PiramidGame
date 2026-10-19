import '../../domain/entities/assessment.dart';
import '../../domain/entities/ranking_entry.dart';
import 'assessment_repository.dart';
import 'student_repository.dart';

abstract class IRankingRepository {
  Future<List<RankingEntry>> getPersonal(String evaluatorUid);
  Future<List<RankingEntry>> getGlobal();
}

class RankingRepository implements IRankingRepository {
  final IStudentRepository people;
  final IAssessmentRepository assessments;

  RankingRepository({required this.people, required this.assessments});

  @override
  Future<List<RankingEntry>> getPersonal(String evaluatorUid) async =>
      _build(await assessments.getByEvaluator(evaluatorUid));

  @override
  Future<List<RankingEntry>> getGlobal() async =>
      _build(await assessments.getAll());

  Future<List<RankingEntry>> _build(List<Assessment> allAssessments) async {
    final students = await people.getAllStudents();
    final peopleById = {for (final student in students) student.id!: student};
    final grouped = <String, List<Assessment>>{};
    for (final assessment in allAssessments) {
      grouped.putIfAbsent(assessment.personId, () => []).add(assessment);
    }

    final entries = <RankingEntry>[];
    for (final item in grouped.entries) {
      final person = peopleById[item.key];
      if (person == null || item.value.isEmpty) continue;
      final points = item.value.fold<int>(0, (sum, assessment) => sum + assessment.totalPoints);
      entries.add(RankingEntry(
        person: person,
        averageScore: points / item.value.length,
        assessmentCount: item.value.length,
      ));
    }
    entries.sort((a, b) => b.averageScore.compareTo(a.averageScore));
    return entries;
  }
}