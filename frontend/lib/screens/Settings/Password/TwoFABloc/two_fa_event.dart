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
