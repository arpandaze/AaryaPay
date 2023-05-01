import 'dart:convert';

import 'package:aaryapay/constants.dart';
import 'package:aaryapay/repository/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepository authRepo = AuthenticationRepository();

  AuthenticationBloc() : super(const AuthenticationState()) {
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<LoadAuthStatus>(_onLoadAuthStatus);
    add(LoadAuthStatus());
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    // print("On Logged in Event Triggered!");
    var nauthState = await AuthenticationState.load();
    emit(nauthState);
  }

  void _onLoadAuthStatus(
      LoadAuthStatus event, Emitter<AuthenticationState> emit) async {
    // print("On Authentication State Event Triggered!");
    emit(await AuthenticationState.load());
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    await authRepo.logout();
  }
}
