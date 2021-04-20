part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class InitialState extends AuthState {}

class LoadingState extends AuthState {}

class LoggedOutState extends AuthState {}

class FailedState extends AuthState {
  final String msg;
  FailedState(this.msg);
}

class LoggedInState extends AuthState {
  final UserModel user;
  LoggedInState(this.user);
}
