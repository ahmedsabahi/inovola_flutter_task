import 'dart:io';

abstract class FilePickerDataSource {
  Future<File?> pickImageFromGallery();
  Future<File?> pickImageFromCamera();
  Future<File?> pickFile();
}
