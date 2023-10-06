import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:my_expense_tracker/utils/cubit/firebase_cubit.dart';
import 'package:my_expense_tracker/utils/utils.dart';
import 'package:net_source/net_source.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repo) : super(const LoginState());
  final AuthRepo _repo;

  /// Function to log in the user, to firebase
  FutureOr<void> signInWithEmailAndPassword(
    String username,
    String password,
  ) async {
    emit(
      state.copyWith(status: CurrentStatus.loading, message: 'loading'),
    );

    final res = await _repo.signInWithEmailAndPassword(
      username,
      password,
      authInstance,
    );
    if (res.success) {
      final data = res.data as JsonMap;
      final response = data['response'] as auth.UserCredential;
      final user = data['user'] as User;
      _repo.authenticated();
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CurrentStatus.success,
            message: res.message,
            data: <String, dynamic>{
              'response': response,
              'user': user,
              'email': response.user!.email,
            },
          ),
        );
      }
    } else {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: CurrentStatus.error,
            message: res.message,
          ),
        );
      }
    }
  }
}
