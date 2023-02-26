import 'package:flutter/material.dart';

class ThemeHelper {
  static get themeMode => ThemeMode.system;

  static get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      );

  static get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      );
}
