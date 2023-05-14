part of 'transaction_bloc.dart';

class TranscationState extends Equatable {
  final bool loaded;
  final List<dynamic>? transactionHistory;
  final String? senderName;
  final String? recieverName;
  final Map<String, dynamic>? item;
  final List<Map<String,dynamic>>? transactionDecoded;

  const TranscationState({
    this.loaded = false,
    this.transactionHistory,
    this.senderName,
    this.recieverName,
    this.item,
    this.transactionDecoded,
  });

  TranscationState copywith({
    bool? loaded,
    List<dynamic>? transactionHistory,
    String? senderName,
    String? recieverName,
    Map<String, dynamic>? item,
    List<Map<String,dynamic>>? transactionDecoded,
  }) {
    return TranscationState(
      loaded: loaded ?? this.loaded,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      senderName: senderName ?? this.senderName,
      recieverName: recieverName ?? this.recieverName,
      item: item ?? this.item,
      transactionDecoded: transactionDecoded ?? this.transactionDecoded,
    );
  }

  @override
  List<Object?> get props => [
        loaded,
        transactionHistory,
        senderName,
        recieverName,
        item,
        transactionDecoded,
      ];
}
