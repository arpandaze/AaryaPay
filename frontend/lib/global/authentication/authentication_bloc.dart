import 'dart:convert';
import 'dart:math';

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
    on<TwoFA>(_onTwoFA);
    add(LoadAuthStatus());
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    var nauthState = await AuthenticationState.load();
    emit(nauthState);
  }

  void _onLoadAuthStatus(
      LoadAuthStatus event, Emitter<AuthenticationState> emit) async {
    emit(await AuthenticationState.load());
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(status: AuthenticationStatus.onLogOutProcess));
    var response = await authRepo.logout() as Map<String, dynamic>;
    emit(await AuthenticationState.load());

    if (!response["logoutSuccess"]) {
      emit(state.copyWith(
          status: AuthenticationStatus.error, errorText: response["msg"]));
    }
  }

  void _onTwoFA(TwoFA event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(status: AuthenticationStatus.twoFA));
    emit(state.copyWith(status: AuthenticationStatus.none));
  }
}
