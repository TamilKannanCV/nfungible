import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/models/nft_set/nft_set.dart';
import 'package:nfungible/screens/create_set_screen.dart';
import 'package:nfungible/services/graphql_service.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CreateNFTScreen extends StatefulWidget {
  static String get routeName => "/createNFT";
  const CreateNFTScreen({super.key});

  @override
  State<CreateNFTScreen> createState() => _CreateNFTScreenState();
}

class _CreateNFTScreenState extends State<CreateNFTScreen> {
  Map<String, String> selectedSet = {};

  late TextEditingController _nftTitleCtlr;
  late TextEditingController _nftDescCtlr;

  @override
  void initState() {
    super.initState();
    _nftTitleCtlr = TextEditingController();
    _nftDescCtlr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text("Create NFT Model"),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: MultiSliver(
              children: [
                SizedBox(height: 1.0.h),
                FutureBuilder<NftSet>(
                  future: GraphqlService().getNFTSets(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (data != null) {
                        final maps = {};
                        data.sets?.forEach((e) {
                          maps[e.id] = e.title;
                        });
                        maps["0x"] = "Create a new set";
                        return Row(
                          children: [
                            Expanded(
                              child: SetsDropdownWidget(
                                maps: maps,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSet = {value.toString(): maps[value]};
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              tooltip: "Refresh",
                              onPressed: () {
                                context.showSnackbar(content: const Text("Fetching NFT Sets..."));
                                setState(() {});
                              },
                              icon: const Icon(Icons.replay_outlined),
                            )
                          ],
                        );
                      }
                    }
                    return const FetchingNFTSetsWidget();
                  },
                ),
                SizedBox(height: 1.0.h),
                if (selectedSet.containsKey("0x"))
                  FilledButton(
                    onPressed: () {
                      context.pushNamed(CreateSetScreen.routeName);
                    },
                    child: const Text("Create Set"),
                  ).animate().fade(),
                SizedBox(height: 2.0.h),
                Text(
                  "NFT Details",
                  style: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.0.h),
                TextFormField(
                  controller: _nftTitleCtlr,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Set Title",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "*required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 1.5.h),
                TextFormField(
                  controller: _nftDescCtlr,
                  maxLines: 3,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Set Description",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "*required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 1.5.h),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FetchingNFTSetsWidget extends StatelessWidget {
  const FetchingNFTSetsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(
          height: 10.0,
          width: 10.0,
          child: CircularProgressIndicator(),
        ),
        SizedBox(width: 10.0),
        Text("Fetching NFT sets..."),
      ],
    );
  }
}

class SetsDropdownWidget extends StatelessWidget {
  const SetsDropdownWidget({
    super.key,
    required this.maps,
    this.onChanged,
  });

  final Map<dynamic, dynamic> maps;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      isExpanded: true,
      hint: const Text(
        'Select an NFT set',
        style: TextStyle(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: maps.entries
          .map(
            (i) => DropdownMenuItem<String>(
              value: i.key,
              child: Text(
                i.value,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          )
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select set.';
        }
      },
      onChanged: (value) {
        onChanged?.call(value);
      },
      onSaved: (value) {},
    );
  }
}
