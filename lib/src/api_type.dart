import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../fizzy_api.dart';

class NetworkApiService implements BaseApiServices {
  // Dio client to perform API requests.
  final Dio _dio;

  // Navigator key used to access context globally (e.g., for showing dialogs).
  final GlobalKey<NavigatorState> navigatorKey;

  // Optional custom response handler provided by the user.
  final dynamic Function(Response response)? customResponseHandler;

  // Optional custom error handler provided by the user.
  final void Function(DioException e)? customErrorHandler;

  // Constructor to initialize Dio and set up interceptors.
  NetworkApiService({
    required this.navigatorKey,
    this.customResponseHandler,
    this.customErrorHandler,
  }) : _dio = Dio(
          BaseOptions(
            connectTimeout:
                const Duration(seconds: 20), // Max time to establish connection
            receiveTimeout:
                const Duration(seconds: 20), // Max time to receive response
            contentType: Headers.jsonContentType, // Default content type
            responseType: ResponseType.json, // Expect JSON response
          ),
        ) {
    // Adding interceptors for logging and global request/response/error handling.
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Step 1: Log request details if debugging is enabled.
        if (_shouldDebug(options)) {
          _logRequest(options);
        }
        handler.next(options); // Pass to next interceptor or execute request
      },
      onResponse: (response, handler) {
        // Step 2: Log response if debugging is enabled.
        if (_shouldDebug(response.requestOptions)) {
          _logResponse(response);
        }
        handler.next(response); // Pass to next interceptor or return response
      },
      onError: (e, handler) {
        // Step 3: Log error details if debugging is enabled.
        if (_shouldDebug(e.requestOptions)) {
          _logError(e);
        }
        handler.next(e); // Pass to error handler
      },
    ));
  }
  // MARK: - Public Methods

  @override
  Future<dynamic> getApi(
    String url, {
    required BuildContext
        context, // Required context for showing loader or error dialogs
    Map<String, dynamic>? headers, // Optional headers to include in the request
    Map<String, dynamic>?
        queryParameters, // Optional query parameters for GET request
    Options? options, // Additional Dio request options (optional)
    ResponseType? responseType, // Custom response type (overrides default JSON)
    dynamic Function(Response response)?
        onResponse, // Optional custom response handler
    void Function(DioException e)? onError, // Optional custom error handler
    bool showLoader =
        false, // Whether to show a loader while the request is active
    Color loaderColor = Colors.blue, // Loader spinner color (default blue)
    double loaderSize = 40, // Loader spinner size
    Widget? customLoader, // Optional custom widget to use as loader
    bool showDebug = true, // Enables or disables debug logging for this request
  }) {
    // Wrapping the actual GET call inside a private method (_requestWrapper)
    // to handle loading UI, error catching, and response parsing uniformly
    return _requestWrapper(
      () => _dio.get(
        url,
        queryParameters:
            queryParameters, // Attach query parameters to GET request
        options: _buildOptions(headers, options, responseType,
            showDebug), // Build options including headers, type, etc.
      ),
      context,
      showLoader || customLoader != null, // Show loader if flag is true or a custom loader is provided
      loaderColor,
      loaderSize,
      customLoader,
      onResponse,
      onError,
    );
  }

  @override
  Future<dynamic> postApi(
    String url, {
    required BuildContext context, // Required for showing loader or UI messages
    Map<String, dynamic>? body, // The request body to send in the POST call
    bool multipart =
        false, // Flag to indicate if the request includes files (multipart/form-data)
    Map<String, dynamic>? headers, // Optional request headers
    Map<String, dynamic>? queryParameters, // Optional query parameters
    Options? options, // Dio options like custom timeouts, etc.
    ResponseType?
        responseType, // Specify response format (e.g. JSON, plain, etc.)
    dynamic Function(Response response)?
        onResponse, // Optional callback for handling successful responses
    void Function(DioException e)?
        onError, // Optional callback for handling errors
    bool showLoader = false, // Whether to show a loader overlay during request
    Color loaderColor = Colors.blue, // Color of the loader spinner
    double loaderSize = 40, // Size of the loader spinner
    Widget? customLoader, // Custom widget to use as a loader instead of default
    bool showDebug = true, // Flag to enable/disable debug logging
  }) {
    // Delegates the request handling to _sendDataRequest,
    // which is a unified method for POST, PUT, PATCH, DELETE.
    return _sendDataRequest(
      method: 'POST', // Sets HTTP method to POST
      url: url,
      context: context,
      body: body,
      multipart: multipart,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      responseType: responseType,
      onResponse: onResponse,
      onError: onError,
      showLoader: showLoader,
      loaderColor: loaderColor,
      loaderSize: loaderSize,
      customLoader: customLoader,
      showDebug: showDebug,
    );
  }

  @override
  Future<dynamic> putApi(
    String url, {
    required BuildContext context, // Required for loader and UI interaction
    Map<String, dynamic>? body, // Request body to send in PUT request
    bool multipart =
        false, // Indicates if request should be multipart/form-data
    Map<String, dynamic>? headers, // Optional headers for the request
    Map<String, dynamic>? queryParameters, // Optional query parameters
    Options? options, // Dio request options, can override default ones
    ResponseType? responseType, // Expected response type (json, plain, etc.)
    dynamic Function(Response response)?
        onResponse, // Optional custom response handler
    void Function(DioException e)? onError, // Optional custom error handler
    bool showLoader = false, // Whether to show a loader during the request
    Color loaderColor = Colors.blue, // Loader color (default blue)
    double loaderSize = 40, // Loader size (default 40)
    Widget? customLoader, // Custom loader widget, overrides default spinner
    bool showDebug = true, // Enable/disable debug logs for this request
  }) {
    // This method internally calls postApi but overrides the HTTP method to 'PUT'
    // by copying the options and setting method = 'PUT'.
    // This reuses postApi's implementation for sending data requests.
    return postApi(
      url,
      context: context,
      body: body,
      multipart: multipart,
      headers: headers,
      queryParameters: queryParameters,
      options: (options ?? Options())
          .copyWith(method: 'PUT'), // Override method to PUT
      responseType: responseType,
      onResponse: onResponse,
      onError: onError,
      showLoader: showLoader,
      loaderColor: loaderColor,
      loaderSize: loaderSize,
      customLoader: customLoader,
      showDebug: showDebug,
    );
  }

  @override
  Future<dynamic> patchApi(
    String url, {
    required BuildContext context, // Context for showing loader or dialogs
    Map<String, dynamic>? body, // Request payload for PATCH
    bool multipart = false, // Flag for multipart/form-data support
    Map<String, dynamic>? headers, // Optional headers
    Map<String, dynamic>? queryParameters, // Optional query parameters
    Options? options, // Dio options (timeout, etc.)
    ResponseType? responseType, // Expected response type (JSON, plain, etc.)
    dynamic Function(Response response)?
        onResponse, // Custom response handler callback
    void Function(DioException e)? onError, // Custom error handler callback
    bool showLoader = false, // Show loader overlay during request
    Color loaderColor = Colors.blue, // Loader color
    double loaderSize = 40, // Loader size
    Widget? customLoader, // Custom loader widget if any
    bool showDebug = true, // Enable debug logging for this request
  }) {
    // Reuse postApi with the HTTP method overridden to 'PATCH'.
    // This ensures all shared features (loader, multipart, error handling) are used.
    return postApi(
      url,
      context: context,
      body: body,
      multipart: multipart,
      headers: headers,
      queryParameters: queryParameters,
      options: (options ?? Options())
          .copyWith(method: 'PATCH'), // Override HTTP method to PATCH
      responseType: responseType,
      onResponse: onResponse,
      onError: onError,
      showLoader: showLoader,
      loaderColor: loaderColor,
      loaderSize: loaderSize,
      customLoader: customLoader,
      showDebug: showDebug,
    );
  }

  @override
  Future<dynamic> deleteApi(
    String url, {
    required BuildContext context, // Context used for loader, dialogs, etc.
    Map<String, dynamic>?
        body, // Optional request body (some APIs support body in DELETE)
    Map<String, dynamic>? headers, // Optional headers for this request
    Map<String, dynamic>? queryParameters, // Optional query parameters
    Options? options, // Additional Dio request options
    ResponseType? responseType, // Expected response format (e.g., JSON)
    dynamic Function(Response response)?
        onResponse, // Optional callback for successful response
    void Function(DioException e)?
        onError, // Optional callback for error handling
    bool showLoader = false, // Flag to show loading spinner during request
    Color loaderColor = Colors.blue, // Color of loader spinner
    double loaderSize = 40, // Size of loader spinner
    Widget? customLoader, // Optional custom loader widget
    bool showDebug = true, // Enable or disable debug logs for this request
  }) {
    // Wrap the Dio DELETE request with the _requestWrapper method
    // that handles loaders, error handling, and response processing.
    return _requestWrapper(
      () => _dio.delete(
        url,
        data: body, // Send request body if provided
        queryParameters: queryParameters, // Attach query parameters
        options: _buildOptions(headers, options, responseType,
            showDebug), // Build request options including headers and debug flag
      ),
      context,
      showLoader ||
          customLoader !=
              null, // Show loader if enabled or custom loader is provided
      loaderColor,
      loaderSize,
      customLoader,
      onResponse,
      onError,
    );
  }

  // MARK: - Helpers

  Future<dynamic> _sendDataRequest({
    required String method, // HTTP method: POST, PUT, PATCH, etc.
    required String url, // Endpoint URL
    required BuildContext context, // Context for showing loaders/UI feedback
    Map<String, dynamic>? body, // Request body data
    bool multipart = false, // Whether to send as multipart/form-data
    Map<String, dynamic>? headers, // Optional headers map
    Map<String, dynamic>? queryParameters, // Optional query parameters
    Options? options, // Dio Options to override default behavior
    ResponseType? responseType, // Expected response type (JSON, plain, etc.)
    dynamic Function(Response response)?
        onResponse, // Optional custom response handler
    void Function(DioException e)? onError, // Optional custom error handler
    bool showLoader = false, // Whether to show a loading indicator
    Color loaderColor = Colors.blue, // Loader color (default blue)
    double loaderSize = 40, // Loader size
    Widget? customLoader, // Custom loader widget (overrides default spinner)
    bool showDebug = true, // Show debug logs for this request
  }) async {
    // Prepare the request body, converting it to FormData if multipart
    final requestData = await _prepareRequestBody(body, multipart);

    // Check if context is still mounted (widget alive)
    if (!context.mounted) return;

    // Wrap the actual Dio request in a helper to handle loader, errors, and response
    return _requestWrapper(
      () => _dio.request(
        url,
        data: requestData, // Set prepared request body data
        queryParameters: queryParameters, // Set query params
        options:
            _buildOptions(headers, options, responseType, showDebug).copyWith(
          method: method, // Override HTTP method
          contentType: multipart
              ? Headers
                  .multipartFormDataContentType // Set content type for multipart/form-data
              : Headers.jsonContentType, // Otherwise, JSON content type
        ),
      ),
      context,
      showLoader ||
          customLoader !=
              null, // Show loader if enabled or custom loader provided
      loaderColor,
      loaderSize,
      customLoader,
      onResponse,
      onError,
    );
  }

// Core wrapper that handles loader, error catching, and response handling
  Future<dynamic> _requestWrapper(
    Future<Response> Function() request, // Actual request function to execute
    BuildContext context, // Context for loader
    bool showLoader, // Whether to show loader
    Color loaderColor,
    double loaderSize,
    Widget? customLoader,
    dynamic Function(Response response)? onResponse, // Custom response handler
    void Function(DioException e)? onError, // Custom error handler
  ) async {
    if (showLoader) {
      // Show loader UI via controller
      ApiLoaderController().showLoader(
        context: context,
        color: loaderColor,
        size: loaderSize,
        customLoader: customLoader,
      );
    }

    try {
      final response = await request(); // Execute the request
      return (onResponse ??
          _handleResponse)(response); // Use custom or default response handler
    } on DioException catch (e) {
      (onError ?? _handleError)(e); // Use custom or default error handler
      rethrow;
    } finally {
      if (showLoader) {
        hideLoader(); // Hide loader after request completes or errors
      }
    }
  }

// Prepares request body: converts map to FormData if multipart, else returns body as is
  Future<dynamic> _prepareRequestBody(
      Map<String, dynamic>? body, bool multipart) async {
    if (body == null || body.isEmpty) return null; // No body to send
    if (!multipart) return body; // Not multipart, return as is

    final formMap = <String, dynamic>{};
    for (final entry in body.entries) {
      final value = entry.value;
      if (value is String && value.contains('/') && File(value).existsSync()) {
        // If value is a file path string, create MultipartFile
        formMap[entry.key] = await MultipartFile.fromFile(value,
            filename: value.split('/').last);
      } else {
        formMap[entry.key] = value; // Otherwise, add normally
      }
    }
    return FormData.fromMap(formMap); // Return FormData for multipart
  }

// Builds Dio Options by merging headers, base options, responseType, and debug flags
  Options _buildOptions(
    Map<String, dynamic>? headers,
    Options? baseOptions,
    ResponseType? responseType,
    bool showDebug,
  ) {
    return (baseOptions ?? Options(headers: headers)).copyWith(
      responseType:
          responseType ?? ResponseType.json, // Default to JSON response type
      extra: {'showDebug': showDebug}, // Store debug flag in extra
    );
  }

// Checks if debugging should be done based on request options and debug mode
  bool _shouldDebug(RequestOptions options) =>
      options.extra['showDebug'] == true && kDebugMode;

// Logs request details for debugging
  void _logRequest(RequestOptions options) {
    if (kDebugMode) {
      print("➡️ REQUEST to ${options.uri}");
      print("Method: ${options.method}, Headers: ${options.headers}");
      print("Query: ${options.queryParameters}, Body: ${options.data ?? ''}");
    }
  }

// Logs response details for debugging
  void _logResponse(Response response) {
    if (kDebugMode) {
      print(
          "✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}");
      print("Data: ${response.data}");
    }
  }

// Logs error details for debugging
  void _logError(DioException e) {
    if (kDebugMode) {
      print("❌ ERROR: ${e.message} | URL: ${e.requestOptions.uri}");
      print("Headers: ${e.requestOptions.headers}");
      print("Query Params: ${e.requestOptions.queryParameters}");
      print("Body: ${e.requestOptions.data}");
      if (e.response != null) {
        print("Status: ${e.response?.statusCode}");
        log("Response Data: ${e.response?.data}");
      }
    }
  }

// Default response handler that returns response data
  dynamic _handleResponse(Response response) => response.data;

// Default error handler that throws custom exceptions based on DioException type
  Never _handleError(DioException error) {
    final data = error.response?.data;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiTimeoutException("Request timed out.");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = data?['message'] ?? "Error occurred.";
        switch (statusCode) {
          case 400:
            throw BadRequestException(message);
          case 401:
            throw UnauthorizedException(message);
          case 403:
            throw ForbiddenException(message);
          case 404:
            throw NotFoundException(message);
          default:
            if (statusCode >= 500) throw ServerErrorException(message);
            throw ApiException("Status: $statusCode");
        }
      case DioExceptionType.cancel:
        throw ApiException("Request cancelled.");
      default:
        throw ApiException("Unexpected error: ${error.message}");
    }
  }

// Show loader using ApiLoaderController (example method, depends on your implementation)
  @override
  void showLoader({
    Color? color,
    double? size,
    Widget? customLoader,
    required BuildContext context,
  }) {
    ApiLoaderController().showLoader(
      context: context,
      color: color ?? Colors.blue,
      size: size ?? 40,
      customLoader: customLoader,
    );
  }

  @override
  void hideLoader() => ApiLoaderController().hideLoader();
}
