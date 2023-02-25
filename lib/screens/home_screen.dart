import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nfungible/constants.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/models/cubit/auth_cubit.dart';
import 'package:nfungible/services/graphql_service.dart';
import 'package:nfungible/widgets/nftmodel_widget.dart';
import 'package:sizer/sizer.dart';
import '../gen/assets.gen.dart';
import '../models/cubit/api_cubit.dart';
import '../models/nft_model/nft_model.dart';

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
          context.read<ApiCubit>().fetchDrops(state.accessToken);
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
            const SliverPadding(
              padding: EdgeInsets.all(10.0),
              sliver: SliverToBoxAdapter(
                child: Text("Available NFT Models"),
              ),
            ),
            FutureBuilder<NftModel>(
              future: GraphqlService().getNFTModels(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final nftModel = snapshot.data;
                  if (nftModel == null) {
                    return const ErrorWidget();
                  }
                  final items = nftModel.items;
                  if (items == null || items.isEmpty == true) {
                    return const NoNFTWidget();
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    sliver: SliverGrid.builder(
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return NFTModelWidget(item: item);
                      },
                    ),
                  );
                }
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NoNFTWidget extends StatelessWidget {
  const NoNFTWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text("No NFTs found"),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.internet.svg(
              height: 15.0.h,
              width: 15.0.w,
            ),
            SizedBox(height: 2.5.h),
            Container(
              alignment: Alignment.center,
              width: 90.0.w,
              child: Text(
                "Unable to fetch NFT data",
                style: TextStyle(
                  fontSize: 17.0.sp,
                ),
                textAlign: TextAlign.center,
              ),
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
    // context.read<AuthCubit>().login();
    GraphqlService().getNFTModels();
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
