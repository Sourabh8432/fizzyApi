import 'package:flutter/material.dart';

class ApiLoaderController {
  static final ApiLoaderController _instance = ApiLoaderController._internal();
  factory ApiLoaderController() => _instance;

  ApiLoaderController._internal();

  OverlayEntry? _loaderEntry;

  void showLoader({
    required BuildContext context,
    Color color = Colors.blue,
    double size = 40,
    Widget? customLoader,
  }) {

    if (_loaderEntry != null) return; // already shown

    _loaderEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          ModalBarrier(color: Colors.black.withValues(alpha: 0.3)),
          Center(
            child: customLoader ??
                SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(color: color),
                ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_loaderEntry!);
  }

  void hideLoader() {
    _loaderEntry?.remove();
    _loaderEntry = null;
  }
}
