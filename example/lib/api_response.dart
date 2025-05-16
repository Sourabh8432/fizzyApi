enum Status {
  initial,
  loading,
  success,
  empty,
  error,
  timeout,
  unauthorized,
  noInternet,
}

class ApiResponse<T> {
  final Status status;
  final T? data;
  final String? message;

  const ApiResponse._({required this.status, this.data, this.message});

  const ApiResponse.initial() : this._(status: Status.initial);

  const ApiResponse.loading() : this._(status: Status.loading);

  const ApiResponse.success(T data) : this._(status: Status.success, data: data);

  const ApiResponse.empty() : this._(status: Status.empty);

  const ApiResponse.error(String message) : this._(status: Status.error, message: message);

  const ApiResponse.timeout() : this._(status: Status.timeout);

  const ApiResponse.unauthorized() : this._(status: Status.unauthorized);

  const ApiResponse.noInternet() : this._(status: Status.noInternet);

  @override
  String toString() => "Status: $status\nMessage: $message\nData: $data";
}
