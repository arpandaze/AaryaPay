import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

part 'qrscan_event.dart';
part 'qrscan_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;

  QrScannerBloc() : super(const QrScannerState()) {
    on<QrCodeScanned>(_onQrCodeScanned);
  }

  void _onQrCodeScanned(QrCodeScanned event, Emitter<QrScannerState> emit) {
    emit(state.copyWith(code: event.code));
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      add(QrCodeScanned(event.code!));
    });
  }

  @override
  Future<void> close() {
    controller!.dispose();
    return super.close();
  }
}
