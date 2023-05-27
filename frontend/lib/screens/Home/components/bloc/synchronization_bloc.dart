import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'synchronization_event.dart';
part 'synchronization_state.dart';

class SynchronizationBloc
    extends Bloc<SynchronizationEvent, SynchronizationState> {
  SynchronizationBloc() : super(const SynchronizationState()) {
    on<EyeTapped>(_onEyeTapped);
    on<SyncingEvent>(_onSyncingEvent);
  }

  void _onEyeTapped(EyeTapped event, Emitter<SynchronizationState> emit) async {
    emit(state.copyWith(hide: event.tapped));
  }

  void _onSyncingEvent(SyncingEvent event, Emitter<SynchronizationState> emit) {
    emit(state.copyWith(syncing: event.syncing));
  }
}
