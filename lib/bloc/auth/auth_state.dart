part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final User? user;
  final AuthStatus status;

  AuthState({this.user, this.status = AuthStatus.unknown});

  factory AuthState.unknown() => AuthState();

  factory AuthState.unauthenticated() => AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.authenticated({@required User? user}) => AuthState(user: user, status: AuthStatus.authenticated);

  @override
  List<Object?> get props => [user, status];
}
