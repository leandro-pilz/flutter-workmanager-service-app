abstract final class CustomException implements Exception {
  final String message;

  CustomException({required this.message});
}

final class DuplicateColumnError extends CustomException {
  DuplicateColumnError({required super.message});
}

final class SyntaxError extends CustomException {
  SyntaxError({required super.message});
}

final class DatabaseClosedError extends CustomException {
  DatabaseClosedError({required super.message});
}

final class UniqueConstraintError extends CustomException {
  UniqueConstraintError({required super.message});
}

final class NotNullConstraintError extends CustomException {
  NotNullConstraintError({required super.message});
}

final class ParametersRequiredError extends CustomException {
  ParametersRequiredError({required super.message});
}

final class GenericError extends CustomException {
  GenericError({required super.message});
}
