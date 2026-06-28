sealed class Result<T> {
  const Result();

  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T success) onSuccess,
  ) {
    if (this is Failure) {
      return onFailure(this as Failure);
    }
    return onSuccess((this as Success<T>).value);
  }

  T? get valueOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return null;
  }

  Failure? get failureOrNull {
    if (this is Failure) {
      return this as Failure;
    }
    return null;
  }
}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  String toString() => 'Success(value: $value)';
}

final class Failure extends Result<Never> {
  final String message;
  final Exception? exception;

  const Failure(this.message, {this.exception});

  @override
  String toString() => 'Failure(message: $message, exception: $exception)';
}
