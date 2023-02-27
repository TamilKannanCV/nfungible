import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/constants.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/models/cubit/graphql_cubit.dart';
import 'package:nfungible/screens/create_nft_screen.dart';
import 'package:nfungible/services/graphql_service.dart';
import 'package:nfungible/widgets/nftmodel_widget.dart';
import 'package:sizer/sizer.dart';
import '../gen/assets.gen.dart';
import '../models/nft_model/nft_model.dart';

class HomeScreen extends StatefulWidget {
  static String get routeName => '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GraphqlCubit>().getNFTModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatingActionWidget(),
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
          const FutureNFTModelsWidget(),
        ],
      ),
    );
  }
}

class FloatingActionWidget extends StatelessWidget {
  const FloatingActionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: () => context.pushNamed(CreateNFTScreen.routeName),
      child: const Icon(Icons.add),
    );
  }
}

class FutureNFTModelsWidget extends StatefulWidget {
  const FutureNFTModelsWidget({
    super.key,
  });

  @override
  State<FutureNFTModelsWidget> createState() => _FutureNFTModelsWidgetState();
}

class _FutureNFTModelsWidgetState extends State<FutureNFTModelsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NftModel>(
      stream: GraphqlService.nftModelStream,
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
            sliver: SliverToBoxAdapter(
              child: GridView.builder(
                cacheExtent: 200,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return NFTModelWidget(item: item);
                },
              ),
            ),
          );
        }
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        );
      },
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
