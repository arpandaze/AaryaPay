import 'package:aaryapay/global/caching/transaction.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc() : super(PaymentsState()) {
    on<PaymentsLoad>(_onPaymentsLoad);
    add(PaymentsLoad());
  }

  void _onPaymentsLoad(
    PaymentsLoad event,
    Emitter<PaymentsState> emit,
  ) async {
    List<Transaction> transactions;
    if (event.transactions != null) {
      transactions = await event.transactions!;
      emit(state.copyWith(transactions: transactions));
    }
    return;
    // emit(state.copyWith(transactions: event.transactions));
  }
}
