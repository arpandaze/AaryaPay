part of 'recent_card_bloc.dart';

class RecentCardState extends Equatable {
  final List<Transaction>? transactionHistory;
  final bool isLoaded;
  final String? senderName;
  final String? receiverName;
  final Transaction? item;
  final bool clear;

  const RecentCardState({
    this.transactionHistory,
    this.isLoaded = false,
    this.senderName,
    this.receiverName,
    this.item,
    this.clear = false,
  });

  RecentCardState copywith({
    List<Transaction>? transactionHistory,
    bool? isLoaded,
    String? senderName,
    String? receiverName,
    Transaction? item,
    bool? clear,
  }) {
    return RecentCardState(
      transactionHistory: transactionHistory ?? this.transactionHistory,
      isLoaded: isLoaded ?? this.isLoaded,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      item: item ?? this.item,
      clear: clear ?? this.clear,
    );
  }

  @override
  List<Object?> get props => [
        transactionHistory,
        isLoaded,
        senderName,
        receiverName,
        item,
        clear,
      ];
}
