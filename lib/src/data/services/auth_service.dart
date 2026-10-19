import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_failure.dart';

const _googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  AppUser? get currentUser => _auth.currentUser == null
      ? null
      : _fromFirebaseUser(_auth.currentUser!);

  Future<AppUser> register(String email, String password) => _authenticate(
        () => _auth.createUserWithEmailAndPassword(email: email, password: password),
      );

  Future<AppUser> login(String email, String password) => _authenticate(
        () => _auth.signInWithEmailAndPassword(email: email, password: password),
      );

  Future<AppUser> loginWithGoogle() async {
    if (kIsWeb) {
      return _authenticate(() => _auth.signInWithPopup(GoogleAuthProvider()));
    }

    try {
      await _googleSignIn.initialize(
        serverClientId:
            _googleServerClientId.isEmpty ? null : _googleServerClientId,
      );
      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthFailure(
          'Google Sign-In não está configurado. Informe GOOGLE_SERVER_CLIENT_ID.',
        );
      }
      return _authenticate(() => _auth.signInWithCredential(
            GoogleAuthProvider.credential(idToken: idToken),
          ));
    } on GoogleSignInException catch (error) {
      throw AuthFailure(error.toString());
    }
  }

  Future<void> logout() async {
    if (!kIsWeb) await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<AppUser> _authenticate(Future<UserCredential> Function() action) async {
    try {
      final credential = await action();
      final user = credential.user;
      if (user == null) throw const AuthFailure('Usuário não autenticado.');
      return _fromFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  AppUser _fromFirebaseUser(User user) => AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        provider: user.providerData.isEmpty
            ? 'password'
            : user.providerData.first.providerId,
      );

  String _messageFor(FirebaseAuthException error) => switch (error.code) {
        'email-already-in-use' => 'Este e-mail já está cadastrado.',
        'invalid-email' => 'O e-mail informado é inválido.',
        'weak-password' => 'A senha deve ter pelo menos 6 caracteres.',
        'user-not-found' || 'wrong-password' || 'invalid-credential' =>
          'E-mail ou senha incorretos.',
        'network-request-failed' => 'Falha de conexão. Verifique sua internet.',
        _ => error.message ?? 'Não foi possível autenticar.',
      };
}