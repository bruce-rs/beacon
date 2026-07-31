import 'package:flutter/material.dart';

sealed class Result<T> {
  const Result._();

  const factory Result.success(T value) = DataResult<T>;

  const factory Result.error(Object error, [StackTrace? stackTrace]) = ErrorResult<T>;

  E map<E>({required E Function(DataResult<T> value) onData, required E Function(ErrorResult<T> value) onError}) {
    return switch (this) {
      DataResult<T>() => onData(this as DataResult<T>),
      ErrorResult<T>() => onError(this as ErrorResult<T>),
      InitialResult<T>() => throw Exception('You should not be here'),
    };
  }

  void maybe({void Function(DataResult<T> value)? onData, void Function(ErrorResult<T> value)? onError}) {
    return switch (this) {
      DataResult<T>() => onData?.call(this as DataResult<T>),
      ErrorResult<T>() => onError?.call(this as ErrorResult<T>),
      InitialResult<T>() => throw Exception('You should not be here'),
    };
  }
}

@immutable
class InitialResult<T> extends Result<T> {
  const InitialResult() : super._();
}

@immutable
class DataResult<T> extends Result<T> {
  const DataResult(this.value) : super._();

  final T value;
}

@immutable
class ErrorResult<T> extends Result<T> {
  const ErrorResult(this.error, [this.stackTrace]) : super._();

  final Object error;
  final StackTrace? stackTrace;
}
