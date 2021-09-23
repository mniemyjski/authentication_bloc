import 'dart:async';

import 'package:authentication_bloc/bloc/bloc.dart';
import 'package:authentication_bloc/models/models.dart';
import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;
  final AuthBloc _authBloc;
  late StreamSubscription<Account?> _accountSubscription;
  late StreamSubscription<AuthState> _authSubscription;

  AccountCubit({
    required AccountRepository accountRepository,
    required AuthBloc authBloc,
  })  : _accountRepository = accountRepository,
        _authBloc = authBloc,
        super(AccountState.unknown()) {
    _init();
  }

  void _init() {
    if (_authBloc.state.status == EAuthStatus.authenticated) _sub(_authBloc.state);

    _authSubscription = _authBloc.stream.listen((event) {
      _sub(event);
    });
  }

  void _sub(AuthState event) {
    if (event.status == EAuthStatus.authenticated) {
      _accountSubscription = _accountRepository.streamMyAccount(event.user!.uid).listen((account) {
        if (account != null) {
          if (state.account != account || state.status != EAccountStatus.created) emit(AccountState.created(account));
        } else if (state.status != EAccountStatus.uncreated) {
          emit(AccountState.unCreated());
        }
      });
    } else {
      try {
        _accountSubscription.cancel();
      } catch (e) {
        Failure(message: "Not Initialization");
      }
      if (state.status != EAccountStatus.unknown) emit(AccountState.unknown());
    }
  }

  @override
  Future<void> close() {
    try {
      _authSubscription.cancel();
    } catch (e) {}
    try {
      _accountSubscription.cancel();
    } catch (e) {}
    return super.close();
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

  Future<void> updateAvatarUrl(String url) async {
    await _accountRepository.updateAccount(state.account!.copyWith(photoUrl: url));
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
}
