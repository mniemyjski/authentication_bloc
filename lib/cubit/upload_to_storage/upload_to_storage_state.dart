part of 'upload_to_storage_cubit.dart';

enum EUploadToStorageStatus { initial, inProgress, succeed, failure }

class UploadToStorageState extends Equatable {
  final EUploadToStorageStatus eUploadToStorageStatus;

  UploadToStorageState(this.eUploadToStorageStatus);

  factory UploadToStorageState.initial() {
    return UploadToStorageState(EUploadToStorageStatus.initial);
  }

  factory UploadToStorageState.inProgress() {
    return UploadToStorageState(EUploadToStorageStatus.inProgress);
  }

  factory UploadToStorageState.succeed() {
    return UploadToStorageState(EUploadToStorageStatus.succeed);
  }

  factory UploadToStorageState.failure() {
    return UploadToStorageState(EUploadToStorageStatus.failure);
  }

  @override
  List<Object?> get props => [eUploadToStorageStatus];
}
