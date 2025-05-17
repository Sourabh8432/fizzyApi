import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../fizzy_api.dart';

class NetworkApiService implements BaseApiServices {
  final Dio _dio;
  final dynamic Function(Response response)? customResponseHandler;
  final void Function(DioException e)? customErrorHandler;
  final GlobalKey<NavigatorState> navigatorKey;

  NetworkApiService({
    required this.navigatorKey,
    this.customResponseHandler,
    this.customErrorHandler,
  }) : _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  )) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print("➡️ REQUEST:--------------------------------------------------");
            print("URL: ${options.uri}");
            print("Method: ${options.method}");
            print("Headers: ${options.headers}");
            print("Query Params: ${options.queryParameters}");
            print("Body: ${options.data ?? ''}");
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print("✅ RESPONSE:-------------------------------------------------");
            print("Status Code: ${response.statusCode}");
            log("Data: ${response.data ?? ''}");
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print("❌ ERROR:----------------------------------------------------");
            print("Message: ${e.message}");
            print("URL: ${e.requestOptions.uri}");
            print("Headers: ${e.requestOptions.headers}");
            print("Query Params: ${e.requestOptions.queryParameters}");
            print("Body: ${e.requestOptions.data}");
            if (e.response != null) {
              print("Response Code: ${e.response?.statusCode}");
              log("Response Data: ${e.response?.data}");
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> _requestWrapper(
      Future<Response> Function() request,
      BuildContext? context,
      bool showLoaderUI,
      Color loaderColor,
      double loaderSize,
      Widget? customLoader,
      dynamic Function(Response response)? onResponse,
      void Function(DioException e)? onError,
      ) async {
    if (showLoaderUI && context != null) {
      ApiLoaderController().showLoader(
        context: context,
        color: loaderColor,
        size: loaderSize,
        customLoader: customLoader,
      );
    }

    try {
      final response = await request();
      return (onResponse ?? _handleResponse)(response);
    } on DioException catch (e) {
      (onError ?? _handleError)(e);
      rethrow;
    } finally {
      if (showLoaderUI) {
        hideLoader();
      }
    }
  }

  @override
  Future<dynamic> getApi(
      String url, {
        required BuildContext context,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ResponseType? responseType,
        dynamic Function(Response response)? onResponse,
        void Function(DioException e)? onError,

        bool showLoader = false,
        Color loaderColor = Colors.blue,
        double loaderSize = 40,
        Widget? customLoader,
      }) {
    final effectiveShowLoader = customLoader != null ? true : showLoader;

    return _requestWrapper(
          () => _dio.get(
        url,
        queryParameters: queryParameters,
        options: (options ?? Options(headers: headers))
            .copyWith(responseType: responseType ?? ResponseType.json),
      ),
      context,
      effectiveShowLoader,
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
        required BuildContext context,
        Map<String, dynamic>? body,
        bool multipart = false,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ResponseType? responseType,
        dynamic Function(Response response)? onResponse,
        void Function(DioException e)? onError,
        bool showLoader = false,
        Color loaderColor = Colors.blue,
        double loaderSize = 40,
        Widget? customLoader,
      }) async {
    final effectiveShowLoader = customLoader != null ? true : showLoader;
    dynamic requestData;

    try {
      // 1. Prepare body (await might cause async gap)
      if (body == null || body.isEmpty) {
        requestData = null;
      } else if (multipart) {
        final formMap = <String, dynamic>{};
        for (var entry in body.entries) {
          final value = entry.value;
          if (value is String && value.contains('/') && File(value).existsSync()) {
            formMap[entry.key] = await MultipartFile.fromFile(
              value,
              filename: value.split('/').last,
            );
          } else {
            formMap[entry.key] = value;
          }
        }
        requestData = FormData.fromMap(formMap);
      } else {
        requestData = body;
      }

      // 2. Build options
      final finalOptions = (options ?? Options(headers: headers)).copyWith(
        responseType: responseType ?? ResponseType.json,
        contentType: multipart
            ? Headers.multipartFormDataContentType
            : Headers.jsonContentType,
      );

      // 3. Before using context, check if widget is still mounted
      if (!context.mounted) return;

      // 4. Call your request handler (that shows loader with context)
      return _requestWrapper(
            () => _dio.post(
          url,
          data: requestData,
          queryParameters: queryParameters,
          options: finalOptions,
        ),
        context,
        effectiveShowLoader,
        loaderColor,
        loaderSize,
        customLoader,
        onResponse,
        onError,
      );
    } catch (e) {
      if (e is DioException && onError != null) {
        onError(e);
      } else {
        rethrow;
      }
    }
  }


  @override
  Future<dynamic> putApi(
      String url, {
        required BuildContext context,
        Map<String, dynamic>? body,
        bool multipart = false,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ResponseType? responseType,
        dynamic Function(Response response)? onResponse,
        void Function(DioException e)? onError,

        bool showLoader = false,
        Color loaderColor = Colors.blue,
        double loaderSize = 40,
        Widget? customLoader,
      }) {
    final effectiveShowLoader = customLoader != null ? true : showLoader;

    return postApi(
      url,
      body: body,
      multipart: multipart,
      headers: headers,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(method: 'PUT'),
      responseType: responseType,
      onResponse: onResponse,
      onError: onError,
      context: context,
      showLoader: effectiveShowLoader,
      loaderColor: loaderColor,
      loaderSize: loaderSize,
      customLoader: customLoader,
    );
  }

  @override
  Future<dynamic> patchApi(
      String url, {
        required BuildContext context,
        Map<String, dynamic>? body,
        bool multipart = false,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ResponseType? responseType,
        dynamic Function(Response response)? onResponse,
        void Function(DioException e)? onError,

        bool showLoader = false,
        Color loaderColor = Colors.blue,
        double loaderSize = 40,
        Widget? customLoader,
      }) {
    final effectiveShowLoader = customLoader != null ? true : showLoader;

    return postApi(
      url,
      body: body,
      multipart: multipart,
      headers: headers,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(method: 'PATCH'),
      responseType: responseType,
      onResponse: onResponse,
      onError: onError,
      context: context,
      showLoader: effectiveShowLoader,
      loaderColor: loaderColor,
      loaderSize: loaderSize,
      customLoader: customLoader,
    );
  }

  @override
  Future<dynamic> deleteApi(
      String url, {
        required BuildContext context,
        Map<String, dynamic>? body,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ResponseType? responseType,
        dynamic Function(Response response)? onResponse,
        void Function(DioException e)? onError,

        bool showLoader = false,
        Color loaderColor = Colors.blue,
        double loaderSize = 40,
        Widget? customLoader,
      }) {
    final effectiveShowLoader = customLoader != null ? true : showLoader;

    return _requestWrapper(
          () => _dio.delete(
        url,
        data: body,
        queryParameters: queryParameters,
        options: (options ?? Options(headers: headers))
            .copyWith(responseType: responseType ?? ResponseType.json),
      ),
      context,
      effectiveShowLoader,
      loaderColor,
      loaderSize,
      customLoader,
      onResponse,
      onError,
    );
  }

  dynamic _handleResponse(Response response) {
    if (kDebugMode) {
      print("Response [${response.statusCode}]: ${response.data}");
    }
    return response.data;
  }

  Never _handleError(DioException error) {
    if (kDebugMode) {
      print("Request Error: ${error.message}");
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiTimeoutException("Request timed out. Please try again.");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final responseData = error.response?.data;

        if (statusCode == 400) {
          throw BadRequestException(responseData?['message'] ?? "Bad request.");
        } else if (statusCode == 401) {
          throw UnauthorizedException(responseData?['message'] ?? "Unauthorized access.");
        } else if (statusCode == 403) {
          throw ForbiddenException(responseData?['message'] ?? "Forbidden.");
        } else if (statusCode == 404) {
          throw NotFoundException(responseData?['message'] ?? "Resource not found.");
        } else if (statusCode >= 500) {
          throw ServerErrorException(responseData?['message'] ?? "Server error.");
        } else {
          throw ApiException("Received invalid status code: $statusCode");
        }
      case DioExceptionType.cancel:
        throw ApiException("Request was cancelled.");
      case DioExceptionType.unknown:
      default:
        throw ApiException("Unexpected error occurred: ${error.message}");
    }
  }

  @override
  void showLoader({Color? color, double? size, Widget? customLoader, required BuildContext context}) {
    ApiLoaderController().showLoader(
      context: context,
      color: color ?? Colors.blue,
      size: size ?? 40,
      customLoader: customLoader,
    );
    }

  @override
  void hideLoader() {
    ApiLoaderController().hideLoader();
  }
}
