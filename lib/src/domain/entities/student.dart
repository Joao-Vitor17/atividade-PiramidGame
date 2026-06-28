class Student {
  final String? id;
  final String name;
  final String course;
  final int year;
  final String nickname;
  final DateTime birthDate;
  final List<int> ratings; // 15 notas (1-5 stars cada)

  Student({
    this.id,
    required this.name,
    required this.course,
    required this.year,
    required this.nickname,
    required this.birthDate,
    required this.ratings,
  }) : assert(ratings.length == 15, 'Deve haver exatamente 15 notas');

  int get totalPoints {
    return ratings.fold(0, (sum, rating) => sum + rating);
  }

  Student copyWith({
    String? id,
    String? name,
    String? course,
    int? year,
    String? nickname,
    DateTime? birthDate,
    List<int>? ratings,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      course: course ?? this.course,
      year: year ?? this.year,
      nickname: nickname ?? this.nickname,
      birthDate: birthDate ?? this.birthDate,
      ratings: ratings ?? this.ratings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'year': year,
      'nickname': nickname,
      'birthDate': birthDate.toIso8601String(),
      'ratings': ratings,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      course: map['course'],
      year: map['year'],
      nickname: map['nickname'],
      birthDate: DateTime.parse(map['birthDate']),
      ratings: List<int>.from(map['ratings']),
    );
  }
}
