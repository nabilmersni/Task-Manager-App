part of "auth_cubit.dart";

class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSignUp extends AuthState {}

final class AuthLoggedIn extends AuthState {
  final UserModel user;
  AuthLoggedIn({required this.user});
}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}
