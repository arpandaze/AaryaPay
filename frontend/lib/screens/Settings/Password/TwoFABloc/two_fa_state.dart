part of 'two_fa_bloc.dart';

class TwoFaState extends Equatable {
  final String? secret;
  final String? uri;
  final bool? isLoaded;
  final String? token;
  final String? errorText;
  final MessageType msgType;
  final bool success;

  const TwoFaState({
    this.secret,
    this.uri,
    this.isLoaded = false,
    this.token,
    this.errorText,
    this.msgType = MessageType.idle,
    this.success = false,
  });

  TwoFaState copyWith({
    String? secret,
    String? uri,
    bool? isLoaded,
    String? token,
    String? errorText,
    MessageType? msgType,
    bool? success,
  }) {
    return TwoFaState(
      uri: uri ?? this.uri,
      secret: secret ?? this.secret,
      isLoaded: isLoaded ?? this.isLoaded,
      token: token ?? this.token,
      msgType: msgType ?? this.msgType,
      errorText: errorText ?? this.errorText,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
        secret,
        uri,
        isLoaded,
        token,
        msgType,
        errorText,
        success,
      ];
}
