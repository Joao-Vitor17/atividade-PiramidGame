import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/student.dart';

abstract class IStudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<Student> addStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
}

class StudentRepository implements IStudentRepository {
  final FirebaseFirestore firestore;

  StudentRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _people =>
      firestore.collection('people');

  @override
  Future<List<Student>> getAllStudents() async {
    final snapshot = await _people.orderBy('name').get();
    return snapshot.docs
        .map((doc) => Student.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<Student?> getStudentById(String id) async {
    try {
      final doc = await _people.doc(id).get();
      return doc.exists ? Student.fromMap({...doc.data()!, 'id': doc.id}) : null;
    } catch (_) { rethrow; }
  }

  @override
  Future<Student> addStudent(Student student) async {
    final doc = _people.doc();
    final created = student.copyWith(id: doc.id);
    await doc.set(created.toMap());
    return created;
  }

  @override
  Future<void> updateStudent(Student student) async {
    final id = student.id;
    if (id == null) throw ArgumentError('Pessoa sem identificador');
    await _people.doc(id).update(student.toMap()..remove('id'));
  }

  @override
  Future<void> deleteStudent(String id) async {
    await _people.doc(id).delete();
    final assessments = await firestore
        .collectionGroup('assessments')
        .where('personId', isEqualTo: id)
        .get();
    for (var start = 0; start < assessments.docs.length; start += 450) {
      final batch = firestore.batch();
      final end = (start + 450).clamp(0, assessments.docs.length);
      for (final assessment in assessments.docs.sublist(start, end)) {
        batch.delete(assessment.reference);
      }
      await batch.commit();
    }
  }
}
