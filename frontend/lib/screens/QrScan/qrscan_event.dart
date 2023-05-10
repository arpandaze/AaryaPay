part of 'qrscan_bloc.dart';

abstract class QrScannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class QrCodeScanned extends QrScannerEvent {
  final List<int> code;
  QrCodeScanned(this.code);

  @override
  List<Object> get props => [code];
}

class QrScanStarted extends QrScannerEvent {}

class QrScanStopped extends QrScannerEvent {}
