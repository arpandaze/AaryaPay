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
    on<LoadTransaction>(_onLoadTransaction);
    on<LoadParticularUser>(_onLoadParticularUser);
    on<ClearLoadedUser>(_onClearLoadedUser);
    add(LoadTransaction());
    add(ClearLoadedUser());
  }

  void _onLoadTransaction(
      LoadTransaction event, Emitter<TranscationState> emit) async {
    try {
      emit(
          state.copywith(transactionHistory: event.transactions, loaded: true));
    } catch (e) {
      emit(state.copywith(loaded: false));
      print("Error: $e");
    }
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
}
