part of 'synchronization_bloc.dart';

class SynchronizationState extends Equatable {
  final String amount;
  final String? uuid;
  final bool hide;
  final bool syncing;
  const SynchronizationState({
    this.amount = "0.0",
    this.uuid,
    this.hide = true,
    this.syncing = false,
  });

  SynchronizationState copyWith({
    String? amount,
    String? uuid,
    bool? hide,
    bool? syncing,
  }) {
    return SynchronizationState(
      amount: amount ?? this.amount,
      uuid: uuid ?? this.uuid,
      hide: hide ?? this.hide,
      syncing: syncing ?? this.syncing,
    );
  }

  @override
  List<Object?> get props => [
        amount,
        uuid,
        hide,
        syncing,
      ];
}
