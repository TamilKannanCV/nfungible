import 'package:flutter/material.dart';
import 'package:nfungible/dialogs/image_source_picker.dart';
import 'package:nfungible/enums/image_source.dart';

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

  void showProgressDialog() {
    showDialog(
      context: this,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const AlertDialog(
          title: Text("Preparing image"),
          content: LinearProgressIndicator(),
        ),
      ),
    );
  }

  void showImageSourceOptionDialog(
    void Function(ImageSource source) onSourcePicked,
  ) {
    showDialog(
      context: this,
      builder: (context) => ImageSourcePicker(
        onImageSourcePicked: onSourcePicked,
      ),
    );
  }

  Future<T?> push<T>(Route<T> route) {
    return Navigator.of(this).push(route);
  }

  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
