import 'package:flutter/material.dart';

/// Helper class to show a snack-bar using the passed context.
class ScaffoldSnackBar {
  // ignore: public_member_api_docs
  ScaffoldSnackBar(this._context);

  /// The scaffold of current context.
  factory ScaffoldSnackBar.of(BuildContext context) {
    return ScaffoldSnackBar(context);
  }

  final BuildContext _context;

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
