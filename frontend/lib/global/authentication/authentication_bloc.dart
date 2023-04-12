import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState()) {
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<RefetchUser>(_onRefetchUser);
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) {}

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) {}

  void _onRefetchUser(RefetchUser event, Emitter<AuthenticationState> emit) {}
}
