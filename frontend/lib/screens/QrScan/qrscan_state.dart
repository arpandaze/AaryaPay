part of 'qrscan_bloc.dart';

class QrScannerState extends Equatable {
  final QRViewController? controller;
  final List<int>? code;
  final String? qrData;

  const QrScannerState({
    this.controller,
    this.code,
    this.qrData,
  });

  QrScannerState copyWith({
    QRViewController? controller,
    List<int>? code,
    String? qrData,
  }) {
    return QrScannerState(
      controller: controller ?? this.controller,
      code: code ?? this.code,
      qrData: qrData ?? this.qrData,
    );
  }

  @override
  List<Object?> get props => [
        controller,
        code,
        qrData,
      ];
}
