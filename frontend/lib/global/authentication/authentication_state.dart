part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final bool loaded;
  final String? token;
  final String? user;
  final AuthenticationStatus status;

  static const storage = FlutterSecureStorage();

  const AuthenticationState({
    this.loaded = false,
    this.token,
    this.user,
    this.status = AuthenticationStatus.none,
  });

  AuthenticationState copyWith({
    String? token,
    String? user,
    AuthenticationStatus? status,
  }) {
    return AuthenticationState(
        token: token ?? this.token,
        user: user ?? this.user,
        status: status ?? this.status);
  }

  static Future<AuthenticationState> load() async {
    var storedUser = await storage.read(key: "user_id");
    var token = await storage.read(key: "token");

    var status = AuthenticationStatus.none;

    if (storedUser != null && token != null) {
      status = AuthenticationStatus.loggedIn;
    }

    return AuthenticationState(token: token, status: status, user: storedUser);
  }

  @override
  List<Object> get props => [];
}
