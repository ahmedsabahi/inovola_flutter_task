import 'package:inovola_flutter_task/features/file_picker/data/models/file_picker_result_model.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/repositories/file_picker_repository.dart';

class PickImageFromGallery {
  final FilePickerRepository repository;

  PickImageFromGallery(this.repository);

  Future<FilePickerResultModel> call() async {
    return await repository.pickImageFromGallery();
  }
}
