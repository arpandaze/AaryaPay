part of 'send_money_bloc.dart';

abstract class SendMoneyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMoneyDigitEvent extends SendMoneyEvent {
  final int digit;
  SendMoneyDigitEvent(this.digit);

  @override
  List<Object> get props => [digit];
}

class StateChanged extends SendMoneyEvent {
  final DisplayState status;
  StateChanged(this.status);

  @override
  List<Object> get props => [status];
}


class SendMoneyAddEvent extends SendMoneyEvent {}

class SendMoneySubtractEvent extends SendMoneyEvent {}

class SendMoneyMultiplyEvent extends SendMoneyEvent {}

class SendMoneyDivideEvent extends SendMoneyEvent {}

class SendMoneyClearEvent extends SendMoneyEvent {}

class SendMoneyEqualsEvent extends SendMoneyEvent {}

class SendMoneyEraseEvent extends SendMoneyEvent {}

