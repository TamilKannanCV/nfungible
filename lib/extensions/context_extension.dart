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
        dismissDirection: DismissDirection.startToEnd,
      ),
    );
  }

  void push<T>(Route<T> route) {
    Navigator.of(this).push(route);
  }

  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void pop() {
    Navigator.of(this).pop();
  }
}
