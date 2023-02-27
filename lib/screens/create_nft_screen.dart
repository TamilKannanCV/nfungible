import 'dart:developer';
import 'dart:io';

import 'package:customizable_counter/customizable_counter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfungible/extensions/context_extension.dart';
import 'package:nfungible/models/nft_set/nft_set.dart';
import 'package:nfungible/screens/create_set_screen.dart';
import 'package:nfungible/services/graphql_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../models/cubit/graphql_cubit.dart';

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
  late GlobalKey<FormState> _formKey;

  File? posterFile, contentFile;

  late int quantity;

  @override
  void initState() {
    super.initState();
    context.read<GraphqlCubit>().getNFTSets();
    _formKey = GlobalKey<FormState>();
    quantity = 0;
    _nftTitleCtlr = TextEditingController();
    _nftDescCtlr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GraphqlCubit, GraphqlState>(
      listener: (context, state) {
        if (state is GraphqlLoading) {
          context.showPreloader(canPop: false);
        }
        if (state is GraphqlLoaded) {
          context.pop();
          context.pop();
          context.showSnackbar(content: const Text("Congrats💐, Your NFT model created"));
        }
        if (state is GraphqlError) {
          context.pop();
          context.showSnackbar(content: const Text("Unable to create NFT Model"));
        }
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverAppBar.medium(title: const Text("Create NFT Model")),
              SliverPadding(
                padding: const EdgeInsets.all(10.0),
                sliver: MultiSliver(
                  children: [
                    const Text("A blueprint for an NFT, containing everything needed to mint one -- file content, blockchain metadata, etc."),
                    SizedBox(height: 3.0.h),
                    StreamBuilder<NftSet>(
                      stream: GraphqlService.setsStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (data != null) {
                            final maps = {};
                            data.sets?.forEach((e) {
                              maps[e.id] = e.title;
                            });
                            maps["0x"] = "Create a new set...";
                            return SetsDropdownWidget(
                              maps: maps,
                              onChanged: (value) {
                                setState(() {
                                  selectedSet = {value.toString(): maps[value]};
                                });
                              },
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
                    QuantityWidget(onCountChanged: (count) {
                      quantity = count;
                    }),
                    SizedBox(height: 3.0.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImagesWidget(
                        onContentSelected: (file) {
                          contentFile = file;
                        },
                        onPosterSelected: (file) {
                          posterFile = file;
                        },
                      ),
                    ),
                    SizedBox(height: 2.0.h),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    width: double.maxFinite,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == false) {
                          context.showSnackbar(content: const Text("Fill all the necessary details"));
                        }
                        if (posterFile == null || contentFile == null) {
                          context.showSnackbar(content: const Text("Please select images"));
                        }

                        createNFT();
                      },
                      child: const Text("Create NFT Model"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void createNFT() {
    context.read<GraphqlCubit>().createNFTModel(
          title: _nftTitleCtlr.text,
          description: _nftDescCtlr.text,
          quantity: quantity,
          posterImage: posterFile!,
          contentImage: contentFile!,
          setId: selectedSet.keys.first,
        );
  }
}

class QuantityWidget extends StatelessWidget {
  const QuantityWidget({
    super.key,
    required this.onCountChanged,
  });
  final void Function(int count) onCountChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            "Quantity",
            style: TextStyle(
              fontSize: 14.0.sp,
            ),
          )),
          CustomizableCounter(
            borderColor: Colors.transparent,
            showButtonText: false,
            onCountChange: (c) => onCountChanged.call(c.round()),
          ),
        ],
      ),
    );
  }
}

class ImagesWidget extends StatefulWidget {
  const ImagesWidget({
    super.key,
    required this.onPosterSelected,
    required this.onContentSelected,
  });
  final void Function(File file) onPosterSelected;
  final void Function(File file) onContentSelected;

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  File? posterImage;
  File? contentImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Poster",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                final file = await selectImageFile();
                if (file != null) {
                  widget.onPosterSelected.call(file);
                  setState(() {
                    posterImage = file;
                  });
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: posterImage == null
                      ? const Center(
                          child: Icon(Icons.add),
                        )
                      : Image.file(
                          posterImage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Content",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                final file = await selectImageFile();
                if (file != null) {
                  widget.onContentSelected.call(file);
                  setState(() {
                    contentImage = file;
                  });
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: contentImage == null
                      ? const Center(
                          child: Icon(Icons.add),
                        )
                      : Image.file(
                          contentImage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<File?> selectImageFile() async {
    if (await Permission.storage.request() != PermissionStatus.granted) {
      return null;
    }
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg'],
    );
    if (res == null) return null;
    final file = res.files.single;
    if (file.path?.contains('.jpeg') == true || file.path?.contains('.jpg') == true) {
      return File(file.path!);
    }
    return null;
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
        if (value == '0x') {
          return 'Create a set';
        }
        return null;
      },
      onChanged: (value) {
        onChanged?.call(value);
      },
      onSaved: (value) {},
    );
  }
}
