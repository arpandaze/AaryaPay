import 'dart:convert';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libaaryapay/transaction/tam.dart';
import 'package:libaaryapay/transaction/tvc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

part 'qrscan_event.dart';
part 'qrscan_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");

  QrScannerBloc() : super(const QrScannerState()) {
    on<QrCodeScanned>(_onQrCodeScanned);
    on<QrScanDataCreate>(_onQrScanDataCreate);
    on<CloseScanner>(_onCloseScanner);
    add(QrScanDataCreate());
  }

  void _onCloseScanner(CloseScanner event, Emitter<QrScannerState> emit) {
    state.controller?.dispose();
  }

  void _onQrScanDataCreate(
      QrScanDataCreate event, Emitter<QrScannerState> emit) async {
    var qrData = await generateQRData();
    emit(state.copyWith(qrData: jsonEncode(qrData)));
  }

  void _onQrCodeScanned(
      QrCodeScanned event, Emitter<QrScannerState> emit) async {

    try {
      TransactionAuthorizationMessage.fromBytes(event.code);
      emit(state.copyWith(codeType: CodeType.TAM));
    } on Exception {
      try {
        TransactionVerificationCertificate.fromBytes(event.code);
        emit(state.copyWith(codeType: CodeType.TVC));
      } on Exception {
        var decodedCode = jsonDecode(utf8.decode(event.code));
        if (decodedCode.containsKey('id') &&
            decodedCode.containsKey('firstName') &&
            decodedCode.containsKey('lastName')) {
          emit(state.copyWith(codeType: CodeType.user));
        } else {
          emit(state.copyWith(codeType: CodeType.other));
        }
      }
    }

    emit(state.copyWith(code: event.code));
    if (state.code != null) {
      emit(state.copyWith(isScanned: true));
    }
  }

  Future<Map> generateQRData() async {
    var storage = const FlutterSecureStorage();

    var profileStorage = await storage.read(key: 'profile');

    var profileDecoded = jsonDecode(profileStorage!);

    var id = profileDecoded['id'];
    var firstName = profileDecoded['first_name'];
    var lastName = profileDecoded['last_name'];

    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
