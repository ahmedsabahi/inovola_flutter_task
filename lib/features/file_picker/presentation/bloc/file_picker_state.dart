part of 'file_picker_bloc.dart';


abstract class FilePickerState extends Equatable {
  final FilePickerResultModel model;
  const FilePickerState(this.model);
  @override
  List<Object?> get props => [model];
}

class FilePickerInitial extends FilePickerState {
  const FilePickerInitial() : super(const FilePickerResultModel());
}

class FilePickerLoading extends FilePickerState {
  const FilePickerLoading(super.model);
}

class FilePickerSuccess extends FilePickerState {
  const FilePickerSuccess(super.model);
}

class FilePickerFailure extends FilePickerState {
  const FilePickerFailure(super.model);
}
