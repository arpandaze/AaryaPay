import 'package:aaryapay/repository/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'transcation_event.dart';
part 'transcation_state.dart';

class TranscationBloc extends Bloc<TranscationEvent, TranscationState> {
  final transactionRepository = TransactionRepository();
  TranscationBloc() : super(const TranscationState()) {
    on<LoadTransaction>(_onLoadTransaction);
    add(LoadTransaction());
  }

  void _onLoadTransaction(
      LoadTransaction event, Emitter<TranscationState> emit) async {
    var decodedData = await transactionRepository.getTransactions();
    emit(state.copywith(loaded: true, transactionHistory: decodedData['data']));
  }
}
