import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libaaryapay/libaaryapay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

part 'qrscan_event.dart';
part 'qrscan_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");

  QrScannerBloc() : super(const QrScannerState()) {
    on<QrCodeScanned>(_onQrCodeScanned);
    on<QrScanDataCreate>(_onQrScanDataCreate);
    on<InitializeScanner>(_onInitializeScanner);
    on<CloseScanner>(_onCloseScanner);
    on<PlatformInitializer>(_onPlatformInitializer);
    add(QrScanDataCreate());
  }

  void _onPlatformInitializer(
      PlatformInitializer event, Emitter<QrScannerState> emit) {
    QRViewController? newController = state.controller;

    if (Platform.isAndroid) {
      newController!.pauseCamera();
    }

    if (Platform.isIOS) {
      newController!.resumeCamera();
    }

    emit(state.copyWith(controller: newController));
  }

  void _onInitializeScanner(
      InitializeScanner event, Emitter<QrScannerState> emit) {
    emit(QrScannerState(controller: event.controller));
  }

  void _onCloseScanner(CloseScanner event, Emitter<QrScannerState> emit) {
    state.controller?.dispose();
  }

  void _onQrScanDataCreate(
      QrScanDataCreate event, Emitter<QrScannerState> emit) async {
    var qrData = await generateQRData();
    emit(state.copyWith(qrData: qrData));
  }

  void _onQrCodeScanned(
      QrCodeScanned event, Emitter<QrScannerState> emit) async {
    print("This is Scanned ${event.code}");
    print("This is Scanned ${utf8.decode(event.code)}");

    emit(state.copyWith(code: event.code));
  }

  Future<String> generateQRData() async {
    final serverKeyPair = keyPairFromBase64(
      "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
    );

    return "Hello";
  }
}
