import 'student.dart';

class RankingEntry {
  final Student person;
  final double averageScore;
  final int assessmentCount;

  const RankingEntry({
    required this.person,
    required this.averageScore,
    required this.assessmentCount,
  });
}