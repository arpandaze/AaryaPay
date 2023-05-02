part of 'transcation_bloc.dart';

class TranscationState extends Equatable {
  final bool loaded;
  final List<dynamic>? transactionHistory;

  const TranscationState({
    this.loaded = false,
    this.transactionHistory,
  });

  TranscationState copywith({
    bool? loaded,
    List<dynamic>? transactionHistory,
  }) {
    return TranscationState(
      loaded: loaded ?? this.loaded,
      transactionHistory: transactionHistory ?? this.transactionHistory,
    );
  }

  @override
  List<Object?> get props => [
        loaded,
        transactionHistory,
      ];
}
