import 'dart:io';

class FilePickerResultModel {
  final File? file;
  final String? fileName;
  final String? errorMessage;
  final bool isLoading;

  const FilePickerResultModel({
    this.file,
    this.fileName,
    this.errorMessage,
    this.isLoading = false,
  });

  FilePickerResultModel copyWith({
    File? file,
    String? fileName,
    String? errorMessage,
    bool? isLoading,
  }) {
    return FilePickerResultModel(
      file: file ?? this.file,
      fileName: fileName ?? this.fileName,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
