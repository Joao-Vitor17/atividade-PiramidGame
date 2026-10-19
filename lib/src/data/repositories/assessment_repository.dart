import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/assessment.dart';

abstract class IAssessmentRepository {
  Future<Assessment?> getForPerson(String evaluatorUid, String personId);
  Future<void> save(Assessment assessment);
  Future<List<Assessment>> getByEvaluator(String evaluatorUid);
  Future<List<Assessment>> getAll();
}

class AssessmentRepository implements IAssessmentRepository {
  final FirebaseFirestore firestore;

  AssessmentRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

    CollectionReference<Map<String, dynamic>> _assessmentsFor(String uid) =>
      firestore.collection('users').doc(uid).collection('assessments');

  @override
  Future<Assessment?> getForPerson(String evaluatorUid, String personId) async {
    final doc = await _assessmentsFor(evaluatorUid).doc(personId).get();
    return doc.exists ? Assessment.fromMap(doc.id, doc.data()!) : null;
  }

  @override
  Future<void> save(Assessment assessment) async {
    final user = await firestore.collection('users').doc(assessment.evaluatorUid).get();
    final linkedPersonId = user.data()?['personId'] as String?;
    if (linkedPersonId == null) {
      throw StateError('Vincule seu perfil antes de avaliar pessoas.');
    }
    if (linkedPersonId == assessment.personId) {
      throw StateError('Você não pode avaliar o próprio perfil.');
    }
    await _assessmentsFor(assessment.evaluatorUid)
        .doc(assessment.personId)
        .set(assessment.toMap());
  }

  @override
  Future<List<Assessment>> getByEvaluator(String evaluatorUid) async {
    final snapshot = await _assessmentsFor(evaluatorUid).get();
    return snapshot.docs.map((doc) => Assessment.fromMap(doc.id, doc.data())).toList();
  }

  @override
  Future<List<Assessment>> getAll() async {
    final snapshot = await firestore.collectionGroup('assessments').get();
    return snapshot.docs.map((doc) => Assessment.fromMap(doc.id, doc.data())).toList();
  }
}