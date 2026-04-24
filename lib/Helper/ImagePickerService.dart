import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Shows a dialog and returns the picked XFile, or null if canceled
  Future<XFile?> showImageSourceDialog(BuildContext context) async {
    return showDialog<XFile>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select image source"),
          actions: [
            TextButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                Navigator.of(context).pop(pickedFile);
              },
              child: Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.of(context).pop(pickedFile);
              },
              child: Text("Gallery"),
            ),
          ],
        );
      },
    );
  }
}