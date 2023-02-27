import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/screens/nft_model_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sizer/sizer.dart';

import '../models/nft_model/item.dart';

class NFTModelWidget extends StatefulWidget {
  const NFTModelWidget({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  State<NFTModelWidget> createState() => _NFTModelWidgetState();
}

class _NFTModelWidgetState extends State<NFTModelWidget> with AutomaticKeepAliveClientMixin {
  Color darkVibrantColor = Colors.transparent;
  Color lightMutedColor = Colors.black;

  @override
  void initState() {
    PaletteGenerator.fromImageProvider(CachedNetworkImageProvider("${widget.item.content?.poster?.url}")).then((value) {
      setState(() {
        darkVibrantColor = value.darkMutedColor?.color ?? Colors.transparent;
        lightMutedColor = value.lightMutedColor?.color ?? Colors.black;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "${widget.item.id}",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: GestureDetector(
          onTap: () {
            context.push(
              MaterialPageRoute(
                builder: (context) => NFTModelScreen(
                  darkVibrantColor: darkVibrantColor,
                  nftItem: widget.item,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: "${widget.item.content?.poster?.url}",
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        value: progress.progress,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        darkVibrantColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${widget.item.title}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: lightMutedColor,
                            fontSize: 16.0.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${widget.item.description}",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: lightMutedColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
