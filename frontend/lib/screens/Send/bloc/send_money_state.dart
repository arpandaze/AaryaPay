part of 'send_money_bloc.dart';

class SendMoneyState extends Equatable {
  final double amount;
  final String displayAmount;
  
  const SendMoneyState({required this.amount, this.displayAmount="0.0"});

  SendMoneyState copyWith({required double amount, String? displayAmount}){
    return SendMoneyState(amount: amount, displayAmount: displayAmount ?? this.displayAmount);
  }
  
  @override
  List<Object> get props => [amount, displayAmount];
}


