import 'package:flutter/services.dart';

class APIKeyReader {
  // Method to read file content from the Flutter project's assets
  Future<String> readProjectAsset(String filePath) async {
    try {
      // Load the file from the Flutter project's assets
      String fileContent = await rootBundle.loadString(filePath);
      return fileContent;
    } catch (e) {
      // Handle the error
      return 'Error: $e';
    }
  }
}
