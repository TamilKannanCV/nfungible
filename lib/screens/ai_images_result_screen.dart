import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/models/cubit/openai_cubit.dart';
import 'package:sizer/sizer.dart';

class AIImagesResultScreen extends StatefulWidget {
  const AIImagesResultScreen({
    super.key,
    required this.query,
  });

  final String query;

  @override
  State<AIImagesResultScreen> createState() => _AIImagesResultScreenState();
}

class _AIImagesResultScreenState extends State<AIImagesResultScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OpenAICubit>().generateAIImages(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(widget.query),
          ),
          BlocBuilder<OpenAICubit, OpenAIState>(
            builder: (context, state) {
              if (state is OpenAILoading) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AutoUdatingLinearProgressbar(),
                        SizedBox(height: 2.0.h),
                        const Text("Generating, Please wait..."),
                      ],
                    ),
                  ),
                );
              }
              if (state is OpenAILoaded) {
                final urls = state.urls;
                return SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: urls
                          .map(
                            (e) => GestureDetector(
                              onTap: () => context.pop(e),
                              child: AIImage(url: e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter();
            },
          )
        ],
      ),
    );
  }
}

class AIImage extends StatelessWidget {
  const AIImage({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        height: 150.0,
        width: 150.0,
        progressIndicatorBuilder: (_, __, ___) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class AutoUdatingLinearProgressbar extends StatefulWidget {
  const AutoUdatingLinearProgressbar({super.key});

  @override
  State<AutoUdatingLinearProgressbar> createState() => _AutoUdatingLinearProgressbarState();
}

class _AutoUdatingLinearProgressbarState extends State<AutoUdatingLinearProgressbar> {
  double value = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (value >= 1) {
          value = 0;
        } else {
          value += 0.01;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: LinearProgressIndicator(value: value),
      ),
    );
  }
}
