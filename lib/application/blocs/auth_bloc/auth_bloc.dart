import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/domain/data/login_data.dart';
import 'package:newsapp/domain/data/register_data.dart';
import 'package:newsapp/domain/models/user_model.dart';
import 'package:newsapp/infrastructure/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo repo;
  AuthBloc(this.repo) : super(InitialState());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is InitializeEvent) {
      yield LoadingState();
      yield* _initialize();
    } else if (event is RegisterEvent) {
      final data = event.data;
      yield LoadingState();
      yield* _handleRegister(data);
    } else if (event is LoginEvent) {
      final data = event.data;
      yield LoadingState();
      yield* _handleSignIn(data);
    } else if (event is LogoutEvent) {
      yield LoadingState();
      await repo.auth.signOut();
      yield LoggedOutState();
    }
  }

  Stream<AuthState> _initialize() async* {
    final user = repo.auth.currentUser;
    if (user != null) {
      final umodel = await repo.getUserModel(user.uid);
      if (umodel != null) {
        yield LoggedInState(umodel);
      } else
        yield LoggedOutState();
    } else
      yield LoggedOutState();
  }

  Stream<AuthState> _handleSignIn(LoginData data) async* {
    try {
      final user = await repo.signIn(data);
      if (user != null) {
        yield LoggedInState(user);
      } else {
        yield FailedState("Something went wrong!");
      }
    } on UserNameNotRegistered catch (e) {
      yield FailedState("User not registered!");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          yield FailedState("Invalid email!");
          break;
        case 'wrong-password':
          yield FailedState("Wrong password!");
          break;
        case 'user-disabled':
          yield FailedState("you don't have access please contact admin!");
          break;
        case 'user-not-found':
          yield FailedState("User not found!");
          break;
        default:
          yield FailedState("Something went wrong!");
      }
    }
  }

  Stream<AuthState> _handleRegister(RegisterData data) async* {
    try {
      final logData = await repo.register(data);
      if (logData != null) {
        yield* _handleSignIn(logData);
      } else {
        yield FailedState("Something went wrong!");
      }
    } on UserNameUnavailable catch (e) {
      yield FailedState("Username unavailable!");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          yield FailedState("Invalid email!");
          break;
        case 'email-already-in-use':
          yield FailedState("Email already registered!");
          break;
        case "weak-password":
          yield FailedState("Weak password!");
          break;

        default:
          yield FailedState("Something went wrong!");
      }
    }
  }
}
