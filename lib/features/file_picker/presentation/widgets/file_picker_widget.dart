import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_flutter_task/features/file_picker/presentation/bloc/file_picker_bloc.dart';

class UploadReceiptWidget extends StatelessWidget {
  const UploadReceiptWidget({super.key});

  Future<void> _showPickOptions(BuildContext ctx) async {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: ctx.read<FilePickerBloc>(),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    ctx.read<FilePickerBloc>().add(
                      PickImageFromCameraRequested(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Pick from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    ctx.read<FilePickerBloc>().add(
                      PickImageFromGalleryRequested(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file_outlined),
                  title: const Text('Pick File'),
                  onTap: () {
                    Navigator.pop(context);
                    ctx.read<FilePickerBloc>().add(PickFileRequested());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilePickerBloc, FilePickerState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Attach Receipt',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () => _showPickOptions(context),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        state.model.file == null
                            ? 'Upload file or image'
                            : state.model.fileName ?? 'File selected',
                        style: TextStyle(
                          color: state.model.file == null
                              ? Colors.grey
                              : Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    state.model.file == null
                        ? const Icon(Icons.camera_alt_outlined, size: 22)
                        : IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => context.read<FilePickerBloc>().add(
                              ClearFilePicker(),
                            ),
                          ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
            if (state.model.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
            if (state.model.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.model.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
