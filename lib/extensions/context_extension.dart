import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showPreloader({bool canPop = true}) {
    showDialog(
      context: this,
      builder: (context) => WillPopScope(
        onWillPop: () async => canPop,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void showSnackbar({
    required Widget content,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: content,
        action: action,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
