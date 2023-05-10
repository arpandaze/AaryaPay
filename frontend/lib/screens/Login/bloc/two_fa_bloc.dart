import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:aaryapay/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libaaryapay/bkvc.dart';

part 'two_fa_event.dart';
part 'two_fa_state.dart';

class TwoFaBloc extends Bloc<TwoFaEvent, TwoFaState> {
  static const storage = FlutterSecureStorage();

  TwoFaBloc() : super(const TwoFaState()) {
    on<Authenticate2FA>(_onAuthenticate2FA);
    on<FATokenChanged>(_onFATokenChanged);
  }
  void _onFATokenChanged(FATokenChanged event, Emitter<TwoFaState> emit) {
    emit(state.copyWith(twoFACode: event.twoFaToken));
  }

  void _onAuthenticate2FA(
      Authenticate2FA event, Emitter<TwoFaState> emit) async {
    emit(state.copyWith(status: FAStatus.initiated));

    final url = Uri.parse('$backendBase/auth/twofa/login/confirm');
    final tempToken = await storage.read(key: "temp_token");

    final headers = {
      "Cookie": "temp_session=$tempToken",
      "Content-Type": "application/json"
    };

    final body = {
      "passcode": state.twoFACode,
    };
    emit(state.copyWith(status: FAStatus.onprocess));
    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 202) {
      var decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      var bkvc = base64Decode(decodedResponse["bkvc"]);

      BalanceKeyVerificationCertificate bkvcObject =
          BalanceKeyVerificationCertificate.fromBytes(bkvc);

      storage.write(
        key: "token",
        value: response.headers["set-cookie"]!.substring(51, 87),
      );

      storage.write(key: "user", value: jsonEncode(decodedResponse["user"]));
      storage.write(key: "user_id", value: bkvcObject.userID.toString());

      storage.write(
          key: "available_balance",
          value: bkvcObject.availableBalance.toString());

      storage.write(key: "public_key", value: bkvcObject.publicKey.toString());

      storage.write(key: "timestamp", value: bkvcObject.timeStamp.toString());

      storage.write(key: "signature", value: bkvcObject.signature.toString());

      emit(state.copyWith(status: FAStatus.success));
    } else {
      emit(state.copyWith(status: FAStatus.faliure));
    }
  }
}
