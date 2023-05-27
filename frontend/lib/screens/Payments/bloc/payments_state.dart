part of 'payments_bloc.dart';

class PaymentsState extends Equatable {
  final List<Transaction>? transactions;
  const PaymentsState({
    this.transactions,
  });

  PaymentsState copyWith ({
    List<Transaction>? transactions,
  }) {
    return PaymentsState(
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [transactions];
}
