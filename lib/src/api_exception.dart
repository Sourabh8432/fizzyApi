class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => "ApiException: $message";
}

class ApiTimeoutException extends ApiException {
  ApiTimeoutException(super.message);
}

class BadRequestException extends ApiException {
  BadRequestException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class ServerErrorException extends ApiException {
  ServerErrorException(super.message);
}
