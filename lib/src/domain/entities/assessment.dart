class Assessment {
  final String id;
  final String evaluatorUid;
  final String personId;
  final List<int> ratings;
  final DateTime assessedAt;

  Assessment({
    required this.id,
    required this.evaluatorUid,
    required this.personId,
    required this.ratings,
    required this.assessedAt,
  }) : assert(ratings.length == 15);

  int get totalPoints => ratings.fold(0, (total, rating) => total + rating);

  Map<String, dynamic> toMap() => {
        'evaluatorUid': evaluatorUid,
        'personId': personId,
        'ratings': ratings,
        'totalPoints': totalPoints,
        'assessedAt': assessedAt.toUtc().toIso8601String(),
      };

  factory Assessment.fromMap(String id, Map<String, dynamic> map) => Assessment(
        id: id,
        evaluatorUid: map['evaluatorUid'] as String,
        personId: map['personId'] as String,
        ratings: List<int>.from(map['ratings'] as List),
        assessedAt: DateTime.parse(map['assessedAt'] as String),
      );
}