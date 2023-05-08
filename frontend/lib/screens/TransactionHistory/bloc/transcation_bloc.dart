import 'package:aaryapay/repository/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'transcation_event.dart';
part 'transcation_state.dart';

class TranscationBloc extends Bloc<TranscationEvent, TranscationState> {
  final transactionRepository = TransactionRepository();
  TranscationBloc() : super(const TranscationState()) {
    on<LoadTransaction>(_onLoadTransaction);
    on<LoadParticularUser>(_onLoadParticularUser);
    on<ClearLoadedUser>(_onClearLoadedUser);
    add(LoadTransaction());
  }

  void _onLoadTransaction(
      LoadTransaction event, Emitter<TranscationState> emit) async {
    var decodedData = await transactionRepository.getTransactions();
    emit(state.copywith(loaded: true, transactionHistory: decodedData['data']));
  }

  void _onClearLoadedUser(
      ClearLoadedUser event, Emitter<TranscationState> emit) async {
    emit(state.copywith(senderName: null, recieverName: null, item: null));
  }

  void _onLoadParticularUser(
      LoadParticularUser event, Emitter<TranscationState> emit) async {
    var decodedData = await transactionRepository.getUserName(
        event.senderID, event.recieverID);

    if (decodedData?["success"]) {
      emit(
        state.copywith(
          senderName:
              "${decodedData?["sender"]["first_name"]} ${decodedData?["sender"]["middle_name"]} ${decodedData?["sender"]["last_name"]}",
          recieverName:
              "${decodedData?["reciever"]["first_name"]} ${decodedData?["reciever"]["middle_name"]} ${decodedData?["reciever"]["last_name"]}",
          item: event.item,
        ),
      );
    }
  }
}
