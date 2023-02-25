import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nfungible/models/cubit/api_cubit.dart';
import 'package:nfungible/models/cubit/auth_cubit.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';
import 'route_helper.dart';
import 'theme_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");

  runApp(
    Sizer(
      builder: (context, _, __) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(),
            lazy: false,
          ),
          BlocProvider(create: (context) => ApiCubit()),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: RouteHelper.routerConfig,
          theme: ThemeHelper.lightTheme,
          darkTheme: ThemeHelper.darkTheme,
          themeMode: ThemeHelper.themeMode,
        ),
      ),
    ),
  );
}
