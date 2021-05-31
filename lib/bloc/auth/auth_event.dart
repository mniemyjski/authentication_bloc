part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged({@required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {
  final String email;

  AuthLogoutRequested(this.email);

  @override
  List<Object?> get props => [email];
}
