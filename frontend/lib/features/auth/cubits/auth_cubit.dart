import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/services/sp_service.dart';
import 'package:task_app/features/auth/repositories/auth_local_repository.dart';
import 'package:task_app/features/auth/repositories/auth_remote_repository.dart';
import 'package:task_app/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteRepository authRemoteRepository = AuthRemoteRepository();
  final AuthLocalRepository authLocalRepository = AuthLocalRepository();
  final SpService spService = SpService();
  AuthCubit() : super(AuthInitial());

  void signUp({
    required final String name,
    required final String email,
    required final String password,
  }) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.signup(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required final String email,
    required final String password,
  }) async {
    try {
      emit(AuthLoading());
      final user = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      if (user.token.isNotEmpty) {
        await spService.setToken(user.token);
      }

      await authLocalRepository.insertUser(user);
      emit(AuthLoggedIn(user: user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void getUserData() async {
    try {
      emit(AuthLoading());
      final user = await authRemoteRepository.getUserData();
      if (user != null) {
        await authLocalRepository.insertUser(user);
        emit(AuthLoggedIn(user: user));
      } else {
        final user = await authLocalRepository.getUser();
        if (user == null) {
          emit(AuthInitial());
          return;
        }
        emit(AuthLoggedIn(user: user));
      }
    } catch (e) {
      final user = await authLocalRepository.getUser();
      if (user == null) {
        emit(AuthError(e.toString()));
        return;
      }
      emit(AuthLoggedIn(user: user));
    }
  }
}
