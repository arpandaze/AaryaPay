part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {

  const PaymentsEvent();


  @override
  List<Object?> get props => [];
}

class PaymentsLoad extends PaymentsEvent{
  final Future<List<Transaction>>? transactions;

  PaymentsLoad({this.transactions});

  @override
  List<Object?> get props => [transactions];
}
