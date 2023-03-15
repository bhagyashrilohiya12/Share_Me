import 'dart:io';
import 'package:path/path.dart' as path;

class FileHelper {
  static String getExtension(File file) {
    return path.extension(file.path);
  }
  static String getExtensionFromAddress(String fileAddress) {
    return path.extension(fileAddress);
  }
}
