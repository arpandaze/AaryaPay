part of 'two_fa_bloc.dart';

abstract class TwoFaEvent extends Equatable {
  const TwoFaEvent();

  @override
  List<Object?> get props => [];
}

class TokenChanged extends TwoFaEvent {
  final String? token;
  const TokenChanged({this.token});

  @override
  List<Object?> get props => [
        token,
      ];
}

class GetTwoFA extends TwoFaEvent {}

class EnableTwoFA extends TwoFaEvent {}

class DisableTwoFA extends TwoFaEvent {}

class ChangeSwitchValue extends TwoFaEvent {
  final bool? currentValue;

  const ChangeSwitchValue({this.currentValue});

  @override
  List<Object?> get props => [
        currentValue,
      ];
}

class LoadSwitch extends TwoFaEvent {}
