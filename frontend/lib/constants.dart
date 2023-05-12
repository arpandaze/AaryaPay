const backendBase = "https://arpandaze.tech/v1";

const fileServerBase = "https://arpandaze.tech/profile";

enum AuthenticationStatus {
  unknown,
  loggedIn,
  logOut,
  none,
  twoFA,
  onLogOutProcess,
  error,
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

enum ForgotStatus {
  initial,
  error,
  success,
  onprocess,
  otpOnProcess,
  otpSuccess,
}
