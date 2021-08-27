import 'dart:async';
import 'dart:typed_data';

import 'package:authentication_bloc/bloc/bloc.dart';
import 'package:authentication_bloc/cubit/upload_to_storage/upload_to_storage_cubit.dart';
import 'package:authentication_bloc/models/models.dart';
import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;
  final AuthBloc _authBloc;
  final UploadToStorageCubit _uploadToStorageCubit;
  late StreamSubscription<Account?> _accountSubscription;
  late StreamSubscription<AuthState> _authSubscription;

  AccountCubit({
    required AccountRepository accountRepository,
    required AuthBloc authBloc,
    required UploadToStorageCubit uploadToStorageCubit,
  })  : _accountRepository = accountRepository,
        _authBloc = authBloc,
        _uploadToStorageCubit = uploadToStorageCubit,
        super(AccountState.unknown()) {
    _authSubscription = _authBloc.stream.listen((event) {
      if (event.status == EAuthStatus.authenticated) {
        _accountSubscription = _accountRepository.streamMyAccount(event.user!.uid).listen((account) {
          account != null ? emit(AccountState.created(account)) : emit(AccountState.unCreated());
        });
      } else {
        try {
          _accountSubscription.cancel();
        } on Exception catch (e) {}

        emit(AccountState.unknown());
      }
    });
  }

  Future<bool> updateName(String name) async {
    bool available = await _accountRepository.nameAvailable(name);

    if (available) {
      _accountRepository.updateAccount(state.account!.copyWith(name: name));
      return true;
    } else {
      return false;
    }
  }

  void updateAvatar(Uint8List uint8list) async {
    String uid = _authBloc.state.user!.uid;
    String path = 'accounts/$uid/avatar/$uid';
    String url = await _uploadToStorageCubit.uploadToStorage(uint8list, path);
    _accountRepository.updateAccount(state.account!.copyWith(photoUrl: url));
  }

  Future<bool> createAccount(String name) async {
    String uid = _authBloc.state.user!.uid;
    String url = _authBloc.state.user!.photoURL ?? '';
    bool available = await _accountRepository.nameAvailable(name);
    if (available) {
      _accountRepository.createAccount(Account(uid: uid, name: name, photoUrl: url));
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> close() {
    _accountSubscription.cancel();
    _authSubscription.cancel();
    return super.close();
  }
}
