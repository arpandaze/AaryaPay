part of 'send_money_bloc.dart';

enum DisplayState {
  equalsPressed,
  idle,
}

class SendMoneyState extends Equatable {
  final double amount;
  final String displayAmount;
  final DisplayState status;
  final bool submitted;
  final bool isOnline;
  final Map<String, dynamic>? submitResponse;
  final TAMStatus tamStatus;
  final TransactionAuthorizationMessage? tam;
  final bool error;
  final String? errorText;

  const SendMoneyState({
    required this.amount,
    this.submitted = false,
    this.displayAmount = "0.0",
    this.status = DisplayState.idle,
    this.submitResponse,
    this.isOnline = true,
    this.tamStatus = TAMStatus.other,
    this.tam,
    this.error = false,
    this.errorText,
  });

  SendMoneyState copyWith({
    double? amount,
    String? displayAmount,
    DisplayState? status,
    bool? submitted,
    Map<String, dynamic>? submitResponse,
    bool? isOnline,
    TAMStatus? tamStatus,
    TransactionAuthorizationMessage? tam,
    bool? error,
    String? errorText,
  }) {
    return SendMoneyState(
      amount: amount ?? this.amount,
      displayAmount: displayAmount ?? this.displayAmount,
      status: status ?? this.status,
      submitted: submitted ?? this.submitted,
      submitResponse: submitResponse ?? this.submitResponse,
      isOnline: isOnline ?? this.isOnline,
      tamStatus: tamStatus ?? this.tamStatus,
      tam: tam ?? this.tam,
      error: error ?? this.error,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [
        amount,
        displayAmount,
        status,
        submitted,
        submitResponse,
        isOnline,
        tamStatus,
        tam,
        error,
        errorText,
      ];
}
