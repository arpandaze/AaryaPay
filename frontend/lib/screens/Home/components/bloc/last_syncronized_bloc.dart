import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'last_syncronized_event.dart';
part 'last_syncronized_state.dart';

class LastSyncronizedBloc
    extends Bloc<LastSyncronizedEvent, LastSyncronizedState> {
  LastSyncronizedBloc() : super(const LastSyncronizedState()) {
    on<SyncingEvent>(_onSyncingEvent);
  }
  void _onSyncingEvent(SyncingEvent event, Emitter<LastSyncronizedState> emit) {
    emit(state.copyWith(syncing: event.syncing));
  }
}
