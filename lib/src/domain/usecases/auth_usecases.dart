import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../entities/auth_failure.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/app_user.dart';

class RegisterUseCase implements Command<AppUser> {
  final IAuthRepository repository;
  final String email;
  final String password;

  RegisterUseCase(this.repository, this.email, this.password);

  @override
  Future<Result<AppUser>> execute() async {
    try {
      if (!email.contains('@') || password.length < 6) {
        return const Failure('Informe um e-mail válido e uma senha com pelo menos 6 caracteres');
      }
      return Success(await repository.register(email.trim(), password));
    } catch (error) {
      return Failure(_authError(error), exception: error is Exception ? error : null);
    }
  }
}

class LoginUseCase implements Command<AppUser> {
  final IAuthRepository repository;
  final String email;
  final String password;

  LoginUseCase(this.repository, this.email, this.password);

  @override
  Future<Result<AppUser>> execute() async {
    try {
      return Success(await repository.login(email.trim(), password));
    } catch (error) {
      return Failure(_authError(error), exception: error is Exception ? error : null);
    }
  }
}

class GoogleLoginUseCase implements Command<AppUser> {
  final IAuthRepository repository;

  GoogleLoginUseCase(this.repository);

  @override
  Future<Result<AppUser>> execute() async {
    try {
      return Success(await repository.loginWithGoogle());
    } catch (error) {
      return Failure(_authError(error), exception: error is Exception ? error : null);
    }
  }
}

class CheckAuthUseCase implements Command<AppUser?> {
  final IAuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<Result<AppUser?>> execute() async {
    try {
      return Success(await repository.getCurrentUser());
    } catch (error) {
      return Failure('Não foi possível verificar a sessão', exception: error is Exception ? error : null);
    }
  }
}

class LogoutUseCase implements Command<void> {
  final IAuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Result<void>> execute() async {
    try {
      await repository.logout();
      return const Success(null);
    } catch (error) {
      return Failure(_authError(error), exception: error is Exception ? error : null);
    }
  }
}

class LinkPersonUseCase implements Command<void> {
  final IAuthRepository repository;
  final String personId;

  LinkPersonUseCase(this.repository, this.personId);

  @override
  Future<Result<void>> execute() async {
    try {
      await repository.linkCurrentUserToPerson(personId);
      return const Success(null);
    } catch (error) {
      return Failure('Não foi possível vincular o perfil', exception: error is Exception ? error : null);
    }
  }
}

String _authError(Object error) =>
    error is AuthFailure ? error.message : error.toString();