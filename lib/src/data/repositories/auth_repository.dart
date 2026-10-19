import '../../domain/entities/app_user.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';

abstract class IAuthRepository {
  AppUser? get currentUser;
  Future<AppUser> register(String email, String password);
  Future<AppUser> login(String email, String password);
  Future<AppUser> loginWithGoogle();
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<void> linkCurrentUserToPerson(String personId);
}

class AuthRepository implements IAuthRepository {
  final AuthService _authService;
  final UserProfileService _profileService;

  AuthRepository(this._authService, this._profileService);

  @override
  AppUser? get currentUser {
    return _authService.currentUser;
  }

  @override
  Future<AppUser> register(String email, String password) async =>
      _saveUser(await _authService.register(email, password));

  @override
  Future<AppUser> login(String email, String password) async =>
      _saveUser(await _authService.login(email, password));

  @override
  Future<AppUser> loginWithGoogle() async =>
      _saveUser(await _authService.loginWithGoogle());

  @override
  Future<void> logout() => _authService.logout();

  @override
  Future<AppUser?> getCurrentUser() async => currentUser;

  @override
  Future<void> linkCurrentUserToPerson(String personId) async {
    final user = currentUser;
    if (user == null) throw StateError('Usuário não autenticado');
    await _profileService.linkPerson(user.uid, personId);
  }

  Future<AppUser> _saveUser(AppUser user) async {
    await _profileService.saveUser(user);
    return user;
  }
}