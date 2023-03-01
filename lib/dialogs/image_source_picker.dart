import 'package:flutter/material.dart';
import 'package:nfungible/enums/image_source.dart';

class ImageSourcePicker extends StatefulWidget {
  const ImageSourcePicker({super.key, required this.onImageSourcePicked});

  final void Function(ImageSource source) onImageSourcePicked;

  @override
  State<ImageSourcePicker> createState() => _ImageSourcePickerState();
}

class _ImageSourcePickerState extends State<ImageSourcePicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose NFT picture source"),
      content: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            title: const Text("Pick from device"),
            onTap: () {
              widget.onImageSourcePicked.call(ImageSource.pick);
            },
          ),
          ListTile(
            title: const Text("Create own NFT picture"),
            subtitle: const Text("You can create your own NFT picture using AI"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            onTap: () {
              widget.onImageSourcePicked.call(ImageSource.create);
            },
          )
        ],
      ),
    );
  }
}
