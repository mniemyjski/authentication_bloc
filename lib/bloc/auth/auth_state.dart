part of 'auth_bloc.dart';

enum EAuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final User? user;
  final EAuthStatus status;

  const AuthState({
    this.user,
    this.status = EAuthStatus.unknown,
  });

  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated({required User user}) {
    return AuthState(user: user, status: EAuthStatus.authenticated);
  }

  factory AuthState.unauthenticated() => const AuthState(status: EAuthStatus.unauthenticated);

  @override
  bool get stringify => false;

  @override
  List<Object?> get props => [user, status];
}

// abstract class AuthState extends Equatable {
//   const AuthState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class AuthStateUnknown extends AuthState {}
//
// class AuthStateUnauthenticated extends AuthState {}
//
// class AuthStateAuthenticated extends AuthState {
//   final User user;
//
//   AuthStateAuthenticated(this.user);
//
//   @override
//   List<Object?> get props => [user];
// }
