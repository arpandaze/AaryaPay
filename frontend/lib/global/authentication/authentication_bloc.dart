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
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(await AuthenticationState.load());
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    await authRepo.logout();
  }
}
