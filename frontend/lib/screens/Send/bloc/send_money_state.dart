part of 'send_money_bloc.dart';

class SendMoneyState extends Equatable {
  final double amount;
  
  const SendMoneyState({required this.amount});

  SendMoneyState copyWith({required double amount}){
    return SendMoneyState(amount: amount);
  }
  
  @override
  List<Object> get props => [amount];
}


