part of 'recent_card_bloc.dart';

abstract class RecentCardEvent extends Equatable {
  const RecentCardEvent();

  @override
  List<Object?> get props => [];
}

class TransactionLoad extends RecentCardEvent {
  final Transactions? transactions;

  TransactionLoad({this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class LoadParticularUser extends RecentCardEvent {
  final String? receiverID;
  final String? senderID;
  final Transaction? item;

  LoadParticularUser({this.senderID, this.receiverID, this.item});

  @override
  List<Object?> get props => [senderID, receiverID, item];
}

class ClearLoadedUser extends RecentCardEvent {}
