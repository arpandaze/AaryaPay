part of 'transaction_bloc.dart';

abstract class TranscationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransaction extends TranscationEvent {
  final Future<List<Transaction>>? transactions;

  LoadTransaction({this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class LoadParticularUser extends TranscationEvent {
  final String? receiverID;
  final String? senderID;
  final Transaction? item;

  LoadParticularUser({this.senderID, this.receiverID, this.item});

  @override
  List<Object?> get props => [senderID, receiverID, item];
}

class ClearLoadedUser extends TranscationEvent {}
