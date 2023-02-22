import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nfungible/constants.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/models/cubit/auth_cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:sliver_tools/sliver_tools.dart';

import '../gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  static String get routeName => '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          context.pop();
          context.showSnackbar(content: const Text("Unable to login"));
        } else if (state is AuthLoggedOut) {
          context.pop();
          context.showSnackbar(content: const Text("Successfully logged out"));
        } else if (state is AuthLoggedIn) {
          context.pop();
          context.showSnackbar(content: const Text("Successfully logged in"));
        } else if (state is AuthLoggingIn) {
          context.showPreloader();
        } else {
          context.pop();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(kAppName),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) {
                return current is! AuthLoggingIn;
              },
              builder: (context, state) {
                if (state is AuthLoggedIn) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.0.h,
                      horizontal: 5.0.w,
                    ),
                    sliver: MultiSliver(children: [
                      Text(
                        "Drops",
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                    ]),
                  );
                }
                if (state is AuthInitial) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: LoginWidget(),
                  );
                }
                return const SliverToBoxAdapter(child: Placeholder());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});
  void onLoginPressed(BuildContext context) async {
    context.read<AuthCubit>().login();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.lock.svg(
            height: 13.0.h,
            width: 13.0.w,
          ),
          SizedBox(height: 2.5.h),
          Text(
            "Sign into $kAppName",
            style: TextStyle(
              fontSize: 17.0.sp,
            ),
          ),
          SizedBox(height: 2.0.h),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoggingIn) {
                return const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                );
              }
              return FilledButton.icon(
                onPressed: () => onLoginPressed(context),
                icon: const Icon(
                  FontAwesomeIcons.google,
                  size: 17.0,
                ),
                label: const Text("Continue with Google"),
              );
            },
          ),
          SizedBox(height: 1.0.h),
          Container(
            alignment: Alignment.center,
            width: 90.w,
            child: Text(
              "To continue,  needs access to your email and picture.",
              style: TextStyle(fontSize: 12.0.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
