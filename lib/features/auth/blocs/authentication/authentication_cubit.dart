import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/auth/data/repository/auth_reponsitory.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final authReponsitory = AuthReponsitory();

  Future<void> signInWithEmail(String email, String password) async {
    try {
      emit(AuthenticationLoadingState());
      final result = await authReponsitory.loginWithEmail(email, password);
      result.fold(
        (failure) => emit(AuthenticationErrortate(failure)),
        (success) => emit(AuthenticationSuccessState()),
      );
    } catch (e) {
      emit(AuthenticationErrortate(e.toString()));
    }
  }

  Future<void> signUp(String email, String password, String userName) async {
    try {
      emit(AuthenticationLoadingState());
      final result = await authReponsitory.register(email, password, userName);
      result.fold(
        (failure) => emit(AuthenticationErrortate(failure)),
        (success) => emit(AuthenticationSuccessState()),
      );
    } catch (e) {
      emit(AuthenticationErrortate(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthenticationLoadingState());
      final result = await authReponsitory.signInWithGoogle();
      result.fold(
        (error) => emit(AuthenticationErrortate(error)),
        (userCredential) => emit(AuthenticationSuccessState()),
      );
    } catch (e) {
      emit(AuthenticationErrortate(e.toString()));
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emit(AuthenticationLoadingState());
      final result = await authReponsitory.signInWithFacebook();
      result.fold(
        (error) => emit(AuthenticationErrortate(error)),
        (user) => emit(AuthenticationSuccessState()),
      );
    } catch (e) {
      emit(AuthenticationErrortate(e.toString()));
    }
  }

  Future<void> signout() async {
    try {
      emit(AuthenticationLoadingState());
      await authReponsitory.signOut();
      emit(AuthenticationSuccessState());
    } catch (e) {
      emit(AuthenticationErrortate(e.toString()));
    }
  }
}
