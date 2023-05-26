import 'dart:convert';
import 'package:aaryapay/helper/utils.dart';
import 'package:http/http.dart' as http;

import 'package:aaryapay/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libaaryapay/libaaryapay.dart';
import 'package:uuid/uuid.dart';

part 'send_money_event.dart';
part 'send_money_state.dart';

class SendMoneyBloc extends Bloc<SendMoneyEvent, SendMoneyState> {
  final storage = const FlutterSecureStorage();
  final httpclient = http.Client();

  SendMoneyBloc() : super(const SendMoneyState(amount: 0.0)) {
    on<SendMoneyDigitEvent>(_onSendMoneyDigit);
    on<SendMoneyAddEvent>(_onSendMoneyAdd);
    on<SendMoneySubtractEvent>(_onSendMoneySubtract);
    on<SendMoneyMultiplyEvent>(_onSendMoneyMultiply);
    on<SendMoneyEqualsEvent>(_onSendMoneyEquals);
    on<SendMoneyClearEvent>(_onSendMoneyClear);
    on<SendMoneyEraseEvent>(_onSendMoneyErase);
    on<SubmitTransfer>(_onSubmitTransfer);
    on<OnlineEvent>(_onOnlineEvent);
    add(OnlineEvent());
  }

  void _onOnlineEvent(OnlineEvent event, Emitter<SendMoneyState> emit) async {
    bool isOnline = await checkInternetConnectivity();
    print("isOnline: $isOnline");
    emit(state.copyWith(isOnline: isOnline));
  }

  final _calculator = Calculator();
  double _operand = 0.0;
  String _operator = "";

  void _onSendMoneyDigit(
      SendMoneyDigitEvent event, Emitter<SendMoneyState> emit) async {
    if (state.status == DisplayState.equalsPressed) {
      emit(state.copyWith(
          amount: 0.0, displayAmount: "0.0", status: DisplayState.idle));
    }
    final digit = event.digit;
    final newAmount = state.amount * 10 + digit;
    if (state.displayAmount == "0.0") {
      emit(state.copyWith(amount: newAmount, displayAmount: "$digit"));
    } else {
      String toDisplay = "${state.displayAmount}$digit";
      emit(state.copyWith(
          amount: newAmount,
          displayAmount: toDisplay,
          status: DisplayState.idle));
    }
  }

  void _onSendMoneyAdd(
      SendMoneyAddEvent event, Emitter<SendMoneyState> emit) async {
    _operand = state.amount;
    _operator = _getOperator(event);
    final newOutput = "${_operand.toInt()}$_operator";
    emit(state.copyWith(
        amount: 0.0, displayAmount: newOutput, status: DisplayState.idle));
  }

  void _onSendMoneySubtract(
      SendMoneySubtractEvent event, Emitter<SendMoneyState> emit) async {
    _operand = state.amount;
    _operator = _getOperator(event);
    final newOutput = "${state.amount.toInt()}$_operator";
    emit(state.copyWith(
        amount: 0.0, displayAmount: newOutput, status: DisplayState.idle));
  }

  void _onSendMoneyMultiply(
      SendMoneyMultiplyEvent event, Emitter<SendMoneyState> emit) async {
    _operand = state.amount;
    _operator = _getOperator(event);
    final newOutput = "${state.amount.toInt()}$_operator";
    emit(state.copyWith(
        amount: 0.0, displayAmount: newOutput, status: DisplayState.idle));
  }

  void _onSendMoneyEquals(
      SendMoneyEqualsEvent event, Emitter<SendMoneyState> emit) async {
    final newAmount = _calculator.calculate(state.amount, _operand, _operator);
    _operand = 0.0;
    _operator = "";
    final newInput = "$newAmount";
    emit(state.copyWith(
        amount: newAmount,
        displayAmount: newInput,
        status: DisplayState.equalsPressed));
  }

  void _onSendMoneyClear(
      SendMoneyClearEvent event, Emitter<SendMoneyState> emit) async {
    emit(state.copyWith(
        amount: 0.0, displayAmount: "0.0", status: DisplayState.idle));
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
      if (newAmount == 0) {
        emit(state.copyWith(
            amount: newAmount.toDouble(),
            displayAmount: "0.0",
            status: DisplayState.idle));
      }
      emit(state.copyWith(
          amount: newAmount.toDouble(),
          displayAmount: "${newAmount.toDouble()}",
          status: DisplayState.idle));
    }
  }

  void _onSubmitTransfer(
      SubmitTransfer event, Emitter<SendMoneyState> emit) async {
    var bkvc = await storage.read(key: "bkvc");
    var privateKey = await storage.read(key: "private_key");
    var token = await storage.read(key: "token");
    if (bkvc != null && privateKey != null && token != null) {
      print("I am Here");

      var bkvcObject = BalanceKeyVerificationCertificate.fromBase64(jsonDecode(bkvc));

      print(bkvcObject.availableBalance);
      print(bkvcObject.messageType);
      print(bkvcObject.publicKey);
      print(bkvcObject.signature);
      print(bkvcObject.timeStamp);
      print(bkvcObject.userID);

      var pubKey = "g+bG/4H87tQaxYiXhibnRDsAKdWVXpG1cFqy5kZc7tY=";

      var newKey = publicKeyFromBase64(pubKey);

      print(await bkvcObject.verify(newKey));
      print(state.amount);
      print(event.to);
      print(DateTime.now());

      var transferTAM = TransactionAuthorizationMessage(
        TAM_MESSAGE_TYPE,
        state.amount,
        event.to,
        bkvcObject,
        DateTime.now(),
      );

      var keyPair = keyPairFromBase64(privateKey);
      await transferTAM.sign(keyPair);

      var encodedTAM = base64Encode(transferTAM.toBytes());

      var decodedTAM = base64Decode(encodedTAM);
      TransactionAuthorizationMessage newTAM =
          TransactionAuthorizationMessage.fromBytes(decodedTAM);
      print("New Verify ${await newTAM.verify()}");
      final body = {"transactions": encodedTAM};

      print(body);

      final url = Uri.parse('$backendBase/sync');
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Cookie": "session=$token",
      };

      var amount = await storage.read(key: "amount");

      var intamount = double.parse(amount!);
      intamount = intamount - state.amount;
      await storage.write(key: "amount", value: "$intamount");
      emit(
        state.copyWith(
          submitted: true,
          submitResponse: {
            "amount": state.amount,
            "date": DateTime.now(),
            "from": bkvcObject.userID,
            "senderName": event.senderName,
            "receiverName": event.receiverName,
            "receiverID": event.to.toString().substring(0, 8),
          },
        ),
      );
      // try {
      //   var response = await httpclient.post(url, headers: headers, body: body);

      //   if (response.statusCode == 202) {
      //     TransactionVerificationCertificate submittedTVC =
      //         TransactionVerificationCertificate.fromBase64(
      //             jsonDecode(response.body)["transaction"]);

      //     print(jsonDecode(response.body)["transaction"]);
      //     emit(state.copyWith(submitted: true));
      //   }
      //   print(response.statusCode);
      //   print(response.body);
      // } catch (e) {
      //   print(e);
      // }
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
