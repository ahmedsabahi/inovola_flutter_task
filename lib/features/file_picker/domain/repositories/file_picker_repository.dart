import 'package:inovola_flutter_task/features/file_picker/data/models/file_picker_result_model.dart';

abstract class FilePickerRepository {
  Future<FilePickerResultModel> pickImageFromGallery();
  Future<FilePickerResultModel> pickImageFromCamera();
  Future<FilePickerResultModel> pickFile();
  FilePickerResultModel clearUpload();
}
