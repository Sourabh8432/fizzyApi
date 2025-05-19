import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

abstract class BaseApiServices {
  /// Performs a GET request
  Future<dynamic> getApi(
      String url, {
        required BuildContext context,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ResponseType? responseType,
        dynamic Function(Response response)? onResponse,
        void Function(DioException e)? onError,
        bool showDebug = true,
      });

  /// Performs a POST request
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
      });

  /// Performs a PUT request
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
      });

  /// Performs a PATCH request
  Future<dynamic> patchApi(
      String url,{
        required BuildContext context,
        Map<String, dynamic>? body,
        bool multipart = false,
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ResponseType? responseType,
        dynamic Function(Response response)? onResponse,
        void Function(DioException e)? onError,
      });

  /// Performs a DELETE request
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
      });

  /// Optionally shows a loader (configurable by the user)
  void showLoader({Color? color, double? size, Widget? customLoader, required BuildContext context});

  /// Hides the loader
  void hideLoader();
}
