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

  const SendMoneyState({
    required this.amount,
    this.submitted = false,
    this.displayAmount = "0.0",
    this.status = DisplayState.idle,
    this.submitResponse,
    this.isOnline = true,
  });

  SendMoneyState copyWith({
    double? amount,
    String? displayAmount,
    DisplayState? status,
    bool? submitted,
    Map<String, dynamic>? submitResponse,
    bool? isOnline,
  }) {
    return SendMoneyState(
      amount: amount ?? this.amount,
      displayAmount: displayAmount ?? this.displayAmount,
      status: status ?? this.status,
      submitted: submitted ?? this.submitted,
      submitResponse: submitResponse ?? this.submitResponse,
      isOnline: isOnline ?? this.isOnline,
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
      ];
}
