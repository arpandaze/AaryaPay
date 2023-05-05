part of 'two_fa_bloc.dart';

abstract class TwoFaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Authenticate2FA extends TwoFaEvent {}

class FATokenChanged extends TwoFaEvent {
  final String twoFaToken;
  final bool completed;

  FATokenChanged(this.twoFaToken, this.completed);

  @override
  List<Object?> get props => [twoFaToken, completed];
}
