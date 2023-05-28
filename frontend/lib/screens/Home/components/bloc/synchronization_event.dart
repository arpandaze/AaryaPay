part of 'synchronization_bloc.dart';

abstract class SynchronizationEvent extends Equatable {
  const SynchronizationEvent();

  @override
  List<Object?> get props => [];
}

class EyeTapped extends SynchronizationEvent {
  final bool tapped;

  EyeTapped({this.tapped = false});

  @override
  List<Object> get props => [tapped];
}

class SyncingEvent extends SynchronizationEvent {
  final bool syncing;
  final bool rotating;

  SyncingEvent({this.syncing = false, this.rotating = false});

  @override
  List<Object?> get props => [syncing];
}

class RotatingEvent extends SynchronizationEvent {
  final bool rotating;

  RotatingEvent({this.rotating = false});

  @override
  List<Object?> get props => [rotating];
}
