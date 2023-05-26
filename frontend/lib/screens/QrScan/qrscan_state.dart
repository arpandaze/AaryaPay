part of 'qrscan_bloc.dart';

enum CodeType {
  TAM,
  TVC,
  user,
  other,
}

class QrScannerState extends Equatable {
  final QRViewController? controller;
  final List<int>? code;
  final String? qrData;
  final bool isScanned;
  final CodeType codeType;

  const QrScannerState({
    this.controller,
    this.code,
    this.qrData,
    this.isScanned = false,
    this.codeType = CodeType.other,
  });

  QrScannerState copyWith({
    QRViewController? controller,
    List<int>? code,
    String? qrData,
    bool? isScanned,
    CodeType? codeType,
  }) {
    return QrScannerState(
      controller: controller ?? this.controller,
      code: code ?? this.code,
      qrData: qrData ?? this.qrData,
      isScanned: isScanned ?? this.isScanned,
      codeType: codeType ?? this.codeType,
    );
  }

  @override
  List<Object?> get props => [
        controller,
        code,
        qrData,
        isScanned,
        codeType,
      ];
}
