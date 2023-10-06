
import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:my_expense_tracker/utils/cubit/firebase_cubit.dart';
import 'package:my_expense_tracker/utils/utils.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required AuthRepo repo, required ServicesRepo sRepo})
      : _repo = repo,
        _sRepo = sRepo,
        super(const RegisterState());
  final AuthRepo _repo;
  final ServicesRepo _sRepo;

  /// register customer
  /// Function to log in the user, to firebase
  FutureOr<void> createUserWithEmailAndPassword(
    String username,
    String password,
  ) async {
    emit(
      state.copyWith(status: CurrentStatus.loading, message: 'loading'),
    );

    final res = await _repo.createUserWithEmailAndPassword(
      username,
      password,
      authInstance,
    );
    if (res.success) {
      final data = res.data as JsonMap;
      final response = data['response'] as auth.UserCredential;
      final user = data['user'] as User;
      _repo.authenticated();
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
    } else {
      emit(
        state.copyWith(
          status: CurrentStatus.error,
          message: res.message,
        ),
      );
    }
  }
}
