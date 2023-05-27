part of 'transaction_bloc.dart';

class TranscationState extends Equatable {
  final bool loaded;
  final List<Transaction>? transactionHistory;
  final String? senderName;
  final String? receiverName;
  final Transaction? item;
  final bool clear;

  const TranscationState({
    this.loaded = false,
    this.transactionHistory,
    this.senderName,
    this.receiverName,
    this.item,
    this.clear = false,
  });

  TranscationState copywith({
    bool? loaded,
    List<Transaction>? transactionHistory,
    String? senderName,
    String? receiverName,
    Transaction? item,
    bool? clear,
  }) {
    return TranscationState(
      loaded: loaded ?? this.loaded,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      item: item ?? this.item,
      clear: clear ?? this.clear,
    );
  }

  @override
  List<Object?> get props => [
        loaded,
        transactionHistory,
        senderName,
        receiverName,
        item,
        clear,
      ];
}
