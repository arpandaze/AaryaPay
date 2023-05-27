part of 'last_syncronized_bloc.dart';

class LastSyncronizedState extends Equatable {
  const LastSyncronizedState({this.syncing = false});
  final bool syncing;

  LastSyncronizedState copyWith({
    bool? syncing,
  }) {
    return LastSyncronizedState(
      syncing: syncing ?? this.syncing,
    );
  }

  @override
  List<Object> get props => [syncing];
}
