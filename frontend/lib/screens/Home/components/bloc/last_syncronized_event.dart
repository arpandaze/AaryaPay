part of 'last_syncronized_bloc.dart';

abstract class LastSyncronizedEvent extends Equatable {
  const LastSyncronizedEvent();

  @override
  List<Object?> get props => [];
}

class SyncingEvent extends LastSyncronizedEvent {
  final bool syncing;

  SyncingEvent({this.syncing = false});

  @override
  List<Object?> get props => [syncing];
}
