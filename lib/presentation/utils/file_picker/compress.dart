import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<XFile?> compressAndGetFile(File file, [String? targetPath]) async {
  final temporaryDir = await getTemporaryDirectory();

  final String basename = '${DateTime.now().toIso8601String()}.jpg';

  final finalTargetPath = targetPath ?? path.join(temporaryDir.path, basename);

  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    finalTargetPath,
    quality: 70,
  );

  return result;
}