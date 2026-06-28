import 'package:signals_flutter/signals_flutter.dart';
import 'result.dart';

abstract class Command<T> {
  Future<Result<T>> execute();
}

class CommandNotifier<T> {
  late final Signal<CommandState<T>> state = signal(
    CommandState<T>.idle(),
  );

  Future<void> call(Command<T> command) async {
    state.value = CommandState<T>.loading();
    final result = await command.execute();
    state.value = result.fold(
      (failure) => CommandState<T>.error(failure.message),
      (success) => CommandState<T>.success(success),
    );
  }
}

sealed class CommandState<T> {
  const CommandState();

  factory CommandState.idle() => IdleCommandState();
  factory CommandState.loading() => LoadingCommandState();
  factory CommandState.success(T data) => SuccessCommandState(data);
  factory CommandState.error(String message) => ErrorCommandState(message);

  bool get isLoading => this is LoadingCommandState;
  bool get isError => this is ErrorCommandState;
  bool get isSuccess => this is SuccessCommandState;
  bool get isIdle => this is IdleCommandState;
}

class IdleCommandState<T> extends CommandState<T> {
  const IdleCommandState();
}

class LoadingCommandState<T> extends CommandState<T> {
  const LoadingCommandState();
}

class SuccessCommandState<T> extends CommandState<T> {
  final T data;
  const SuccessCommandState(this.data);
}

class ErrorCommandState<T> extends CommandState<T> {
  final String message;
  const ErrorCommandState(this.message);
}
