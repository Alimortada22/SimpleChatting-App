import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key,required this.onpickedimage});
  final void Function( File pickedimage) onpickedimage;
  @override
  State<UserImagePicker> createState() {
    return _UserImagePicker();
  }
}

class _UserImagePicker extends State<UserImagePicker> {
  final imagepicker = ImagePicker();
  File? selectedimage;
  void pickimag() async {
    final pickedimage =
        await imagepicker.pickImage(source: ImageSource.camera, maxHeight: 150,imageQuality: 50);
    if (pickedimage == null) {
      return;
    }
    setState(() {
      selectedimage = File(pickedimage.path);
    });
    widget.onpickedimage(selectedimage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            foregroundImage:
                selectedimage != null ? FileImage(selectedimage!) : null),
        TextButton.icon(
          onPressed: pickimag,
          icon: const Icon(Icons.image),
          label: Text(
            "Add Image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
