class Student {
  final String? id;
  final String name;
  final String course;
  final int year;
  final String nickname;
  final DateTime birthDate;
  final String? createdBy;

  Student({
    this.id,
    required this.name,
    required this.course,
    required this.year,
    required this.nickname,
    required this.birthDate,
    this.createdBy,
  });

  Student copyWith({
    String? id,
    String? name,
    String? course,
    int? year,
    String? nickname,
    DateTime? birthDate,
    String? createdBy,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      course: course ?? this.course,
      year: year ?? this.year,
      nickname: nickname ?? this.nickname,
      birthDate: birthDate ?? this.birthDate,
      createdBy: createdBy ?? this.createdBy,
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
      'createdBy': createdBy,
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
      createdBy: map['createdBy'] as String?,
    );
  }
}
