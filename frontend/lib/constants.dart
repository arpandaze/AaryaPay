const backendBase = "https://arpandaze.tech/v1";

enum AuthenticationStatus {
  loggedIn,
  loggedOut,
  none,
}

enum VerificationStatus {
  unknown,
  initial,
  verified,
  unverified,
  twofa,
  error,
}

enum MessageType {
  idle,
  neutral,
  warning,
  error,
  success,
}
