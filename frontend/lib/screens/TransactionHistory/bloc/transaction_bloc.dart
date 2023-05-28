import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/repository/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TranscationBloc extends Bloc<TranscationEvent, TranscationState> {
  final transactionRepository = TransactionRepository();

  static const storage = FlutterSecureStorage();

  TranscationBloc() : super(const TranscationState()) {
    on<LoadParticularUser>(_onLoadParticularUser);
    on<LoadTransaction>(_onLoadTransaction);
    on<ClearLoadedUser>(_onClearLoadedUser);
    add(ClearLoadedUser());
  }

  void _onClearLoadedUser(
      ClearLoadedUser event, Emitter<TranscationState> emit) async {
    emit(state.copywith(clear: !state.clear));
  }

  void _onLoadParticularUser(
      LoadParticularUser event, Emitter<TranscationState> emit) async {
    emit(state.copywith(
        senderName: event.senderID,
        receiverName: event.receiverID,
        item: event.item));
  }

  void _onLoadTransaction(
      LoadTransaction event, Emitter<TranscationState> emit) async {
    List<Transaction> transactions;
    if (event.transactions != null) {
      transactions =  event.transactions!;
      emit(state.copywith(transactionHistory: transactions));
    }
    return;
  }
}
