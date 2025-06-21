import 'package:inovola_flutter_task/features/file_picker/data/datasources/file_picker_datasource.dart';
import 'package:inovola_flutter_task/features/file_picker/data/models/file_picker_result_model.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/repositories/file_picker_repository.dart';

class FilePickerRepositoryImpl implements FilePickerRepository {
  final FilePickerDataSource filePickerDataSource;
  static const double _maxFileSizeMB = 2.0;

  FilePickerRepositoryImpl({required this.filePickerDataSource});

  @override
  Future<FilePickerResultModel> pickImageFromGallery() async {
    try {
      final file = await filePickerDataSource.pickImageFromGallery();
      if (file == null) {
        return const FilePickerResultModel();
      }
      final fileSizeMB = file.lengthSync() / (1024 * 1024);
      if (fileSizeMB > _maxFileSizeMB) {
        return const FilePickerResultModel(
          errorMessage: 'Image is larger than 2MB.',
        );
      }
      return FilePickerResultModel(
        file: file,
        fileName: file.path.split('/').last,
        errorMessage: null,
      );
    } catch (e) {
      return const FilePickerResultModel(errorMessage: 'Failed to pick image');
    }
  }

  @override
  Future<FilePickerResultModel> pickImageFromCamera() async {
    try {
      final file = await filePickerDataSource.pickImageFromCamera();
      if (file == null) {
        return const FilePickerResultModel();
      }
      final fileSizeMB = file.lengthSync() / (1024 * 1024);
      if (fileSizeMB > _maxFileSizeMB) {
        return const FilePickerResultModel(
          errorMessage: 'Image is larger than 2MB.',
        );
      }
      return FilePickerResultModel(
        file: file,
        fileName: file.path.split('/').last,
        errorMessage: null,
      );
    } catch (e) {
      return const FilePickerResultModel(errorMessage: 'Failed to pick image');
    }
  }

  @override
  Future<FilePickerResultModel> pickFile() async {
    try {
      final file = await filePickerDataSource.pickFile();
      if (file == null) {
        return const FilePickerResultModel();
      }
      final fileSizeMB = file.lengthSync() / (1024 * 1024);
      if (fileSizeMB > _maxFileSizeMB) {
        return const FilePickerResultModel(
          errorMessage: 'File is larger than 2MB.',
        );
      }
      return FilePickerResultModel(
        file: file,
        fileName: file.path.split('/').last,
        errorMessage: null,
      );
    } catch (e) {
      return const FilePickerResultModel(errorMessage: 'Failed to pick file');
    }
  }

  @override
  FilePickerResultModel clearUpload() {
    return const FilePickerResultModel();
  }
}
