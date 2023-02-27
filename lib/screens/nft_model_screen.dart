import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nfungible/models/nft_model/item.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class NFTModelScreen extends StatefulWidget {
  static String get routeName => "/nftModel";
  const NFTModelScreen({super.key, required this.darkVibrantColor, required this.nftItem});
  final Color darkVibrantColor;
  final Item nftItem;

  @override
  State<NFTModelScreen> createState() => _NFTModelScreenState();
}

class _NFTModelScreenState extends State<NFTModelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverPadding(
              padding: const EdgeInsets.all(10.0),
              sliver: MultiSliver(
                children: [
                  const SliverAppBar(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Poster",
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Hero(
                    tag: "${widget.nftItem.id}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: "${widget.nftItem.content?.poster?.url}",
                      ),
                    ),
                  ),
                  SizedBox(height: 1.0.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Contents",
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: "${widget.nftItem.content?.files?.first.url}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ).animate().flip(
                            duration: const Duration(milliseconds: 500),
                          ),
                    ],
                  ),
                  SizedBox(height: 3.0.h),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NFT Model Details",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.0.h),
                          Column(
                            children: [
                              ListTile(
                                title: const Text("ID"),
                                subtitle: Text("${widget.nftItem.id}"),
                              ),
                              ListTile(
                                title: const Text("Title"),
                                subtitle: Text("${widget.nftItem.title}"),
                              ),
                              ListTile(
                                title: const Text("Description"),
                                subtitle: Text("${widget.nftItem.description}"),
                              ),
                              ListTile(
                                title: const Text("Quantity"),
                                subtitle: Text("${widget.nftItem.quantity}"),
                              ),
                              ListTile(
                                title: const Text("Quantity Minted"),
                                subtitle: Text("${widget.nftItem.quantityMinted}"),
                              ),
                              ListTile(
                                title: const Text("Rarity"),
                                subtitle: Text("${widget.nftItem.rarity}"),
                              ),
                              ListTile(
                                title: const Text("Status"),
                                subtitle: Text("${widget.nftItem.status}"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
