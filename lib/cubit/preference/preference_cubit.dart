import 'dart:async';

import 'package:authentication_bloc/bloc/bloc.dart';
import 'package:authentication_bloc/cubit/cubit.dart';
import 'package:authentication_bloc/models/models.dart';
import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'preference_state.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  final PreferenceRepository _preferenceRepository;
  final AccountCubit _accountCubit;
  late StreamSubscription<Preference?> _preferenceSubscription;
  late StreamSubscription<AccountState> _accountSubscription;

  PreferenceCubit({
    required AccountCubit accountCubit,
    required PreferenceRepository preferenceRepository,
  })  : _accountCubit = accountCubit,
        _preferenceRepository = preferenceRepository,
        super(PreferenceState.unknown()) {
    _init();
  }

  void _init() {
    if (_accountCubit.state.status == EAccountStatus.created) _sub();

    _accountSubscription = _accountCubit.stream.listen((event) {
      if (event.status == EAccountStatus.created) {
        _sub();
      } else {
        try {
          _preferenceSubscription.cancel();
        } catch (e) {}
        if (state.status != EPreferenceStatus.unknown) emit(PreferenceState.unknown());
      }
    });
  }

  void _sub() {
    try {
      _preferenceSubscription.cancel();
    } catch (e) {}
    _preferenceSubscription = _preferenceRepository.streamPreference(_accountCubit.state.account!.uid).listen((preference) {
      preference != null ? emit(PreferenceState.created(preference)) : emit(PreferenceState.unCreated());
    });
  }

  @override
  Future<void> close() {
    _preferenceSubscription.cancel();
    _accountSubscription.cancel();
    return super.close();
  }

  createPreference() async {
    String uid = _accountCubit.state.account!.uid;
    _preferenceRepository.createPreference(Preference(uid: uid));
  }
}
