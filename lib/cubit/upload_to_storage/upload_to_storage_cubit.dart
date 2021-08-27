import 'dart:typed_data';

import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'upload_to_storage_state.dart';

class UploadToStorageCubit extends Cubit<UploadToStorageState> {
  final StorageRepository storageRepository;

  UploadToStorageCubit(this.storageRepository) : super(UploadToStorageState.initial());

  Future<String> uploadToStorage(Uint8List uint8List, String path) async {
    String url = '';
    emit(UploadToStorageState.inProgress());
    url = await storageRepository.uploadToFirebaseStorage(uint8List: uint8List, path: path);
    emit(UploadToStorageState.succeed());
    return url;
  }
}
