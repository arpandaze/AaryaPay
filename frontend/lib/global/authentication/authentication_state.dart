part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final bool loaded;
  final String? token;
  final Map<String, dynamic>? user;
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
    Map<String, dynamic>? user,
    AuthenticationStatus? status,
  }) {
    return AuthenticationState(
        token: token ?? this.token,
        user: user ?? this.user,
        status: status ?? this.status);
  }

  static Future<AuthenticationState> load() async {
    var storedUser = await storage.read(key: "user");
    var token = await storage.read(key: "token");

    var status = AuthenticationStatus.none;
    if (storedUser != null && token != null) {
      var userObject = jsonDecode(storedUser);

      status = AuthenticationStatus.loggedIn;

      return AuthenticationState(
          loaded: true, token: token, status: status, user: userObject);
    }
    return const AuthenticationState(
        loaded: true, status: AuthenticationStatus.logOut);
  }

  @override
  List<Object> get props => [loaded, status];
}
