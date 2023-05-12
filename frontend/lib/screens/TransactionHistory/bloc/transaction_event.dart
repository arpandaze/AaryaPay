part of 'transaction_bloc.dart';

abstract class TranscationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransaction extends TranscationEvent {}

class LoadParticularUser extends TranscationEvent {
  final String? recieverID;
  final String? senderID;
  final Map<String, dynamic>? item;

  LoadParticularUser({this.senderID, this.recieverID, this.item});

  @override
  List<Object?> get props => [senderID, recieverID, item];
}

class ClearLoadedUser extends TranscationEvent {}
