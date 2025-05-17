import 'package:flutter/material.dart';
import 'fizzy_api.dart';
export 'src/api_exception.dart';
export 'src/api_services.dart';
export 'src/api_type.dart';
export 'src/api_loader.dart';

NetworkApiService? _instance;

/// Accessor for the singleton instance
NetworkApiService get fizzyApi {
  assert(_instance != null, 'Fizzy API not initialized. Call initializeFizzyApi() first.');
  return _instance!;
}

/// Call this once during app startup (typically in `main()` or inside your root widget)
void initializeFizzyApi({required GlobalKey<NavigatorState> navigatorKey}) {
  _instance ??= NetworkApiService(navigatorKey: navigatorKey);
}
