import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/features/file_picker/data/models/file_picker_result_model.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/clear_file_picker.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/pick_image_from_gallery.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/pick_image_from_camera.dart';
import 'package:inovola_flutter_task/features/file_picker/domain/usecases/pick_file.dart';

part 'file_picker_event.dart';
part 'file_picker_state.dart';

class FilePickerBloc extends Bloc<FilePickerEvent, FilePickerState> {
  final PickImageFromGallery _pickImageFromGallery;
  final PickImageFromCamera _pickImageFromCamera;
  final PickFile _pickFile;
  final ClearFilePickerUseCase _clearUpload;

  FilePickerBloc({
    required PickImageFromGallery pickImageFromGallery,
    required PickImageFromCamera pickImageFromCamera,
    required PickFile pickFile,
    required ClearFilePickerUseCase clearUpload,
  }) : _pickImageFromGallery = pickImageFromGallery,
       _pickImageFromCamera = pickImageFromCamera,
       _pickFile = pickFile,
       _clearUpload = clearUpload,
       super(const FilePickerInitial()) {
    on<PickImageFromGalleryRequested>(_onPickImageFromGalleryRequested);
    on<PickImageFromCameraRequested>(_onPickImageFromCameraRequested);
    on<PickFileRequested>(_onPickFileRequested);
    on<ClearFilePicker>(_onClearFilePicker);
  }

  Future<void> _onPickImageFromGalleryRequested(
    PickImageFromGalleryRequested event,
    Emitter<FilePickerState> emit,
  ) async {
    emit(FilePickerLoading(state.model.copyWith(isLoading: true)));
    final result = await _pickImageFromGallery.call();
    _handleUploadResult(emit, result);
  }

  Future<void> _onPickImageFromCameraRequested(
    PickImageFromCameraRequested event,
    Emitter<FilePickerState> emit,
  ) async {
    emit(FilePickerLoading(state.model.copyWith(isLoading: true)));
    final result = await _pickImageFromCamera.call();
    _handleUploadResult(emit, result);
  }

  Future<void> _onPickFileRequested(
    PickFileRequested event,
    Emitter<FilePickerState> emit,
  ) async {
    emit(FilePickerLoading(state.model.copyWith(isLoading: true)));
    final result = await _pickFile.call();
    _handleUploadResult(emit, result);
  }

  void _onClearFilePicker(
    ClearFilePicker event,
    Emitter<FilePickerState> emit,
  ) {
    final result = _clearUpload.call();
    _handleUploadResult(emit, result);
  }

  void _handleUploadResult(
    Emitter<FilePickerState> emit,
    FilePickerResultModel result,
  ) {
    if (result.errorMessage != null) {
      emit(
        FilePickerFailure(
          state.model.copyWith(
            errorMessage: result.errorMessage,
            isLoading: false,
          ),
        ),
      );
    } else if (result.file != null) {
      emit(
        FilePickerSuccess(
          state.model.copyWith(
            file: result.file,
            fileName: result.fileName,
            isLoading: false,
            errorMessage: null,
        
          ),
        ),
      );
    } else {
      emit(const FilePickerInitial());
    }
  }
}
