const backendBase = "http://192.168.1.72:8080/v1";

enum AuthenticationStatus {
  loggedIn,
  loggedOut,
  none,
}

enum VerificationStatus {
  unknown,
  verified,
  unverified,
}
