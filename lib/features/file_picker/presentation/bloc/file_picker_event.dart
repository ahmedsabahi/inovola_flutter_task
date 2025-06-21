part of 'file_picker_bloc.dart';

abstract class FilePickerEvent extends Equatable {
  const FilePickerEvent();
  @override
  List<Object?> get props => [];
}

class PickImageFromGalleryRequested extends FilePickerEvent {}

class PickImageFromCameraRequested extends FilePickerEvent {}

class PickFileRequested extends FilePickerEvent {}

class ClearFilePicker extends FilePickerEvent {}
