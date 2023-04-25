import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'send_money_event.dart';
part 'send_money_state.dart';

class SendMoneyBloc extends Bloc<SendMoneyEvent, SendMoneyState> {
  SendMoneyBloc() : super(const SendMoneyState(amount: 0.0)) {
    on<SendMoneyDigitEvent>(_onSendMoneyDigit);
    on<SendMoneyAddEvent>(_onSendMoneyAdd);
    on<SendMoneySubtractEvent>(_onSendMoneySubtract);
    on<SendMoneyMultiplyEvent>(_onSendMoneyMultiply);
    on<SendMoneyEqualsEvent>(_onSendMoneyEquals);
    on<SendMoneyClearEvent>(_onSendMoneyClear);
    on<SendMoneyEraseEvent>(_onSendMoneyErase);
  }

  final _calculator = Calculator();
  double _operand = 0.0;
  String _operator = "";

  void _onSendMoneyDigit(
      SendMoneyDigitEvent event, Emitter<SendMoneyState> emit) async {
    final digit = event.digit;
    final newAmount = state.amount * 10 + digit;
    if (state.displayAmount == "0.0") {
      emit(state.copyWith(amount: newAmount, displayAmount: "$digit"));
    } else {
      String toDisplay = "${state.displayAmount}$digit";
      emit(state.copyWith(amount: newAmount, displayAmount: toDisplay));
    }
  }

  void _onSendMoneyAdd(
      SendMoneyAddEvent event, Emitter<SendMoneyState> emit) async {
    _operand = state.amount;
    _operator = _getOperator(event);
    final newOutput = "${_operand.toInt()}$_operator";
    emit(state.copyWith(amount: 0.0, displayAmount: newOutput));
  }

  void _onSendMoneySubtract(
      SendMoneySubtractEvent event, Emitter<SendMoneyState> emit) async {
    _operand = state.amount;
    _operator = _getOperator(event);
    final newOutput = "${state.amount.toInt()}$_operator";
    emit(state.copyWith(amount: 0.0, displayAmount: newOutput));
  }

  void _onSendMoneyMultiply(
      SendMoneyMultiplyEvent event, Emitter<SendMoneyState> emit) async {
    _operand = state.amount;
    _operator = _getOperator(event);
    final newOutput = "${state.amount.toInt()}$_operator";
    emit(state.copyWith(amount: 0.0, displayAmount: newOutput));
  }

  void _onSendMoneyEquals(
      SendMoneyEqualsEvent event, Emitter<SendMoneyState> emit) async {
    final newAmount = _calculator.calculate(state.amount, _operand, _operator);
    _operand = 0.0;
    _operator = "";
    final newInput = "$newAmount";
    emit(state.copyWith(amount: newAmount, displayAmount: newInput));
  }

  void _onSendMoneyClear(
      SendMoneyClearEvent event, Emitter<SendMoneyState> emit) async {
    emit(state.copyWith(amount: 0.0, displayAmount: "0.0"));
  }

  void _onSendMoneyErase(
      SendMoneyEraseEvent event, Emitter<SendMoneyState> emit) async {
    if (state.displayAmount.contains("+") |
        state.displayAmount.contains("-") |
        state.displayAmount.contains("*")) {
      final tempAmount = state.displayAmount;
      final newDisplayAmount =
          state.displayAmount.substring(0, tempAmount.length - 1);
      emit(state.copyWith(amount: _operand, displayAmount: newDisplayAmount));
    } else {
      final newAmount = (state.amount / 10).floor();
      emit(state.copyWith(
          amount: newAmount.toDouble(), displayAmount: "$newAmount"));
    }
  }

  String _getOperator(SendMoneyEvent event) {
    if (event is SendMoneyAddEvent) {
      return '+';
    } else if (event is SendMoneySubtractEvent) {
      return '-';
    } else if (event is SendMoneyMultiplyEvent) {
      return '*';
    } else if (event is SendMoneyDivideEvent) {
      return '/';
    } else {
      return '';
    }
  }
}

class Calculator {
  double calculate(double currentValue, double operand, String operator) {
    switch (operator) {
      case '+':
        return operand + currentValue;
      case '-':
        return operand - currentValue;
      case '*':
        return operand * currentValue;
      case '/':
        return operand / currentValue;
      default:
        return currentValue;
    }
  }
}
