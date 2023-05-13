part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final bool loaded;
  final String? token;
  final Map<String, dynamic>? user;
  final AuthenticationStatus status;
  final String? errorText;

  static const storage = FlutterSecureStorage();

  const AuthenticationState({
    this.errorText,
    this.loaded = false,
    this.token,
    this.user,
    this.status = AuthenticationStatus.none,
  });

  AuthenticationState copyWith({
    bool? loaded,
    String? token,
    Map<String, dynamic>? user,
    AuthenticationStatus? status,
    String? errorText,
  }) {
    return AuthenticationState(
        loaded: loaded ?? this.loaded,
        errorText: errorText ?? this.errorText,
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
  List<Object?> get props => [
        loaded,
        status,
        token,
        user,
        errorText,
      ];
}
