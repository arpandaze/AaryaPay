part of 'qrscan_bloc.dart';

abstract class QrScannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class QrCodeScanned extends QrScannerEvent {
  final Uint8List code;
  QrCodeScanned(this.code);

  @override
  List<Object> get props => [code];
}

class QrScanStarted extends QrScannerEvent {}

class QrScanStopped extends QrScannerEvent {}

class QrScanDataCreate extends QrScannerEvent {}


class InitializeScanner extends QrScannerEvent {
  final QRViewController controller;

  InitializeScanner({required this.controller});

  @override
  List<Object> get props => [controller];
}

class CloseScanner extends QrScannerEvent {}

class PlatformInitializer extends QrScannerEvent {}
