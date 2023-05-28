import 'dart:math';

import 'package:aaryapay/global/caching/transaction.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recent_card_event.dart';
part 'recent_card_state.dart';

class RecentCardBloc extends Bloc<RecentCardEvent, RecentCardState> {
  RecentCardBloc() : super(const RecentCardState()) {
    on<TransactionLoad>(_onTransactionLoad);
    on<LoadParticularUser>(_onLoadParticularUser);
    on<ClearLoadedUser>(_onClearLoadedUser);
    add(ClearLoadedUser());
  }

  void _onTransactionLoad(
      TransactionLoad event, Emitter<RecentCardState> emit) async {
    try {
      List<Transaction> submittedTransactions =
          event.transactions!.getSubmittedTransactions();
      emit(state.copywith(
          transactionHistory: submittedTransactions, isLoaded: true));
    } catch (e) {
      emit(state.copywith(isLoaded: false));
    }
  }

  void _onLoadParticularUser(
      LoadParticularUser event, Emitter<RecentCardState> emit) {
    emit(
      state.copywith(
        senderName: event.senderID,
        receiverName: event.receiverID,
        item: event.item,
      ),
    );
  }

  void _onClearLoadedUser(
      ClearLoadedUser event, Emitter<RecentCardState> emit) async {
    emit(state.copywith(clear: !state.clear));
  }
}
