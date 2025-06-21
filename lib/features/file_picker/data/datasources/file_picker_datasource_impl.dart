import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'file_picker_datasource.dart';

class FilePickerDataSourceImpl implements FilePickerDataSource {
  final ImagePicker imagePicker;
  final FilePicker filePicker;

  FilePickerDataSourceImpl({
    required this.imagePicker,
    required this.filePicker,
  });

  @override
  Future<File?> pickImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  @override
  Future<File?> pickImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  @override
  Future<File?> pickFile() async {
    final result = await filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      compressionQuality: 80,
    );
    final filePath = result?.files.single.path;
    return filePath != null ? File(filePath) : null;
  }
}
