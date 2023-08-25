import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> selectPickImageSource(BuildContext context) async {
  return await showModalActionSheet<ImageSource>(
    context: context,
    actions: [
      const SheetAction(
        label: 'Gallerie',
        key: ImageSource.gallery,
      ),
      const SheetAction(
        label: 'Camera',
        key: ImageSource.camera,
      ),
    ],
  );
}
