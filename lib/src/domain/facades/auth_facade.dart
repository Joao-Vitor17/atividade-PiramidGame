import '../entities/app_user.dart';
import '../usecases/auth_usecases.dart';
import '../../data/repositories/auth_repository.dart';

class AuthFacade {
  final IAuthRepository repository;

  AuthFacade(this.repository);

  AppUser? get currentUser => repository.currentUser;
  RegisterUseCase register(String email, String password) =>
      RegisterUseCase(repository, email, password);
  LoginUseCase login(String email, String password) =>
      LoginUseCase(repository, email, password);
  GoogleLoginUseCase loginWithGoogle() => GoogleLoginUseCase(repository);
  CheckAuthUseCase checkAuth() => CheckAuthUseCase(repository);
  LogoutUseCase logout() => LogoutUseCase(repository);
  LinkPersonUseCase linkPerson(String personId) =>
      LinkPersonUseCase(repository, personId);
}