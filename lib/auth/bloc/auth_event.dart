part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}

class AuthenticationLogoutRequested extends AuthEvent {}

class AppExited extends AuthEvent {}

class AppResumed extends AuthEvent {}

class AppLockPaused extends AuthEvent {}

class Expired extends AuthEvent {}
