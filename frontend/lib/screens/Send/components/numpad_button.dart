import 'package:aaryapay/screens/Send/bloc/send_money_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumPadButton extends StatelessWidget {
  final String text;

  NumPadButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final bloc = BlocProvider.of<SendMoneyBloc>(context);
        switch (text) {
          case '+':
            bloc.add(SendMoneyAddEvent());
            break;
          case '-':
            bloc.add(SendMoneySubtractEvent());
            break;
          case 'X':
            bloc.add(SendMoneyMultiplyEvent());
            break;
          case '/':
            bloc.add(SendMoneyDivideEvent());
            break;
          case 'C':
            bloc.add(SendMoneyClearEvent());
            break;
          case '=':
            bloc.add(SendMoneyEqualsEvent());
            break;
          default:
            bloc.add(SendMoneyDigitEvent(int.parse(text)));
            break;
        }
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 70, minHeight: 60),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .merge(TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
