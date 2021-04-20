part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class InitializeEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final LoginData data;
  LoginEvent(this.data);
}

class RegisterEvent extends AuthEvent {
  final RegisterData data;
  RegisterEvent(this.data);
}
