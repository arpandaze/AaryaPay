part of 'transcation_bloc.dart';

abstract class TranscationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransaction extends TranscationEvent {}
