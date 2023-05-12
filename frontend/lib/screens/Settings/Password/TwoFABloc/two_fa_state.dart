part of 'two_fa_bloc.dart';

class TwoFaState extends Equatable {
  final String? secret;
  final String? uri;
  final bool? isLoaded;
  final String? token;
  final String? errorText;
  final MessageType msgType;
  final bool success;
  final bool switchValue;
  final bool enableCall;
  final bool disableCall;

  const TwoFaState({
    this.secret,
    this.uri,
    this.isLoaded = false,
    this.token,
    this.errorText,
    this.msgType = MessageType.idle,
    this.success = false,
    this.switchValue = true,
    this.enableCall = false,
    this.disableCall = false,
  });

  TwoFaState copyWith({
    String? secret,
    String? uri,
    bool? isLoaded,
    String? token,
    String? errorText,
    MessageType? msgType,
    bool? success,
    bool? switchValue,
    bool? enableCall,
    bool? disableCall,
  }) {
    return TwoFaState(
      switchValue: switchValue ?? this.switchValue,
      uri: uri ?? this.uri,
      secret: secret ?? this.secret,
      isLoaded: isLoaded ?? this.isLoaded,
      token: token ?? this.token,
      msgType: msgType ?? this.msgType,
      errorText: errorText ?? this.errorText,
      success: success ?? this.success,
      enableCall: enableCall ?? this.enableCall,
      disableCall: disableCall ?? this.disableCall,
    );
  }

  @override
  List<Object?> get props => [
        switchValue,
        secret,
        uri,
        isLoaded,
        token,
        msgType,
        errorText,
        success,
        enableCall,
        disableCall,
      ];
}
