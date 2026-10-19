import '../../core/patterns/command.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/facades/auth_facade.dart';

class AuthViewModel {
  final AuthFacade facade;
  final loginCommand = CommandNotifier<AppUser>();
  final registerCommand = CommandNotifier<AppUser>();
  final googleLoginCommand = CommandNotifier<AppUser>();
  final logoutCommand = CommandNotifier<void>();
  final linkPersonCommand = CommandNotifier<void>();

  AuthViewModel({required this.facade});

  Future<void> login(String email, String password) =>
      loginCommand.call(facade.login(email, password));

  Future<void> register(String email, String password) =>
      registerCommand.call(facade.register(email, password));

  Future<void> loginWithGoogle() =>
      googleLoginCommand.call(facade.loginWithGoogle());

    Future<void> logout() => logoutCommand.call(facade.logout());

    Future<void> linkPerson(String personId) =>
      linkPersonCommand.call(facade.linkPerson(personId));

  bool get isLoading => loginCommand.state.value.isLoading ||
      registerCommand.state.value.isLoading ||
      googleLoginCommand.state.value.isLoading;

  String? get errorMessage {
    final states = [loginCommand.state.value, registerCommand.state.value, googleLoginCommand.state.value];
    for (final state in states) {
      if (state is ErrorCommandState<AppUser>) return state.message;
    }
    return null;
  }
}