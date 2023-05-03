const backendBase = "http://192.168.1.71:8080/v1";

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

enum MessageType {
  idle,
  warning,
  error,
  success,
}


