import 'dart:async';

import 'package:authentication_bloc/bloc/bloc.dart';
import 'package:authentication_bloc/models/models.dart';
import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'preference_state.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  final PreferenceRepository _preferenceRepository;
  final AuthBloc _authBloc;
  late StreamSubscription<Preference?> _preferenceSubscription;
  late StreamSubscription<AuthState> _authSubscription;

  PreferenceCubit({
    required AuthBloc authBloc,
    required PreferenceRepository preferenceRepository,
  })  : _authBloc = authBloc,
        _preferenceRepository = preferenceRepository,
        super(PreferenceState.unknown()) {
    _authSubscription = _authBloc.stream.listen((event) {
      if (event.status == EAuthStatus.authenticated) {
        _preferenceSubscription = _preferenceRepository.streamPreference(event.user!.uid).listen((preference) {
          preference != null ? emit(PreferenceState.created(preference)) : emit(PreferenceState.unCreated());
        });
      } else {
        try {
          _preferenceSubscription.cancel();
        } on Exception catch (e) {}

        emit(PreferenceState.unknown());
      }
    });
  }

  createPreference() async {
    String uid = _authBloc.state.user!.uid;
    _preferenceRepository.createPreference(Preference(uid: uid));
  }

  @override
  Future<void> close() {
    _preferenceSubscription.cancel();
    _authSubscription.cancel();
    return super.close();
  }
}
