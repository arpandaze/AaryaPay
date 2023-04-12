part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final bool loaded;
  final String? token;
  final Map<String, dynamic>? user;

  const AuthenticationState({
    this.loaded = false,
    this.token,
    this.user,
  });

  AuthenticationState copyWith({
    String? token,
    Map<String, dynamic>? user,
  }) {
    return AuthenticationState(
        token: token ?? this.token, user: user ?? this.user);
  }

  @override
  List<Object> get props => [];
}
