part of 'top_bar_bloc.dart';

class TopBarState extends Equatable {
  final String amount;
  final String? uuid;
  final bool hide;
  const TopBarState({
    this.amount = "0.0",
    this.uuid,
    this.hide = true,
  });

  TopBarState copyWith({
    String? amount,
    String? uuid,
    bool? hide,
    bool? syncing,
  }) {
    return TopBarState(
      amount: amount ?? this.amount,
      uuid: uuid ?? this.uuid,
      hide: hide ?? this.hide,
    );
  }

  @override
  List<Object?> get props => [
        amount,
        uuid,
        hide,
      ];
}
