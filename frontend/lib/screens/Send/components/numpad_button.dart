import 'package:aaryapay/screens/Send/bloc/send_money_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NumPadButton extends StatelessWidget {
  final String text;
  final SvgPicture? icon;
  final Color? color;
  final double? width;
  final double? height;
  const NumPadButton(
      {super.key,
      required this.text,
      this.icon,
      this.color,
      this.width,
      this.height});

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
          case 'erase':
            bloc.add(SendMoneyEraseEvent());
            break;
          case '=':
            bloc.add(SendMoneyEqualsEvent());
            break;
          case 'AC':
            bloc.add(SendMoneyClearEvent());
            break;
          default:
            bloc.add(SendMoneyDigitEvent(int.parse(text)));
            break;
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        constraints: BoxConstraints(
          minWidth: width ?? 65,
          minHeight: height ?? 65,
        ),
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: icon ??
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .merge(
                    TextStyle(color: Theme.of(context).colorScheme.background)),
              ),
        ),
      ),
    );
  }
}
