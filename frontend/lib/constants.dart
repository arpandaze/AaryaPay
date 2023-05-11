const backendBase = "https://arpandaze.tech/v1";

enum AuthenticationStatus {
  unknown,
  loggedIn,
  logOut,
  none,
  twoFA,
}

enum VerificationStatus {
  unknown,
  initial,
  verified,
  unverified,
  twofa,
  error,
}

enum FAStatus {
  initiated,
  onprocess,
  success,
  faliure,
  unknown,
}

enum MessageType {
  idle,
  neutral,
  warning,
  error,
  success,
}

enum LoginStatus {
  initial,
  onprocess,
  success,
  faliure,
}
