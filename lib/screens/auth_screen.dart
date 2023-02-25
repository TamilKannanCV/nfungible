import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthScreen extends StatefulWidget {
  static String get routeName => "/auth";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final authBaseUrl = dotenv.get('NIFTORY_AUTH_BASE_URL');
    final authUrl = dotenv.get('NIFTORY_AUTH_PATH');
    final niftoryClientId = dotenv.get('NIFTORY_CLIENT_ID');

    return Scaffold(
      body: const Placeholder(),
    );
  }
}
