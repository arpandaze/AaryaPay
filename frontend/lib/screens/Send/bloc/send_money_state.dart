part of 'send_money_bloc.dart';

enum DisplayState {
  equalsPressed,
  idle,
}

class SendMoneyState extends Equatable {
  final double amount;
  final String displayAmount;
  final DisplayState status;

  const SendMoneyState(
      {required this.amount,
      this.displayAmount = "0.0",
      this.status = DisplayState.idle});

  SendMoneyState copyWith({required double amount, String? displayAmount, DisplayState? status}) {
    return SendMoneyState(
      amount: amount,
      displayAmount: displayAmount ?? this.displayAmount,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        amount,
        displayAmount,
        status,
      ];
}
