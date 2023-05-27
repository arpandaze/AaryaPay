part of 'qrscan_bloc.dart';

enum CodeType {
  TAM,
  TVC,
  user,
  other,
  scanned,
}

class QrScannerState extends Equatable {
  final QRViewController? controller;
  final List<int>? code;
  final String? qrData;
  final bool isScanned;
  final CodeType codeType;
  final TransactionAuthorizationMessage? tam;
  final TransactionVerificationCertificate? tvc;
  final bool scannedOnce;
  final bool animationPlaying;

  const QrScannerState({
    this.tvc,
    this.controller,
    this.code,
    this.qrData,
    this.isScanned = false,
    this.tam,
    this.codeType = CodeType.other,
    this.scannedOnce = false,
    this.animationPlaying = false,
  });

  QrScannerState copyWith({
    TransactionVerificationCertificate? tvc,
    QRViewController? controller,
    List<int>? code,
    String? qrData,
    bool? isScanned,
    TransactionAuthorizationMessage? tam,
    CodeType? codeType,
    bool? scannedOnce,
    bool? animationPlaying,
  }) {
    return QrScannerState(
      tam: tam ?? this.tam,
      controller: controller ?? this.controller,
      code: code ?? this.code,
      qrData: qrData ?? this.qrData,
      isScanned: isScanned ?? this.isScanned,
      codeType: codeType ?? this.codeType,
      tvc: tvc ?? this.tvc,
      scannedOnce: scannedOnce ?? this.scannedOnce,
      animationPlaying: animationPlaying ?? this.animationPlaying,
    );
  }

  @override
  List<Object?> get props => [
        controller,
        code,
        qrData,
        isScanned,
        codeType,
        tam,
        tvc,
        scannedOnce,
        animationPlaying,
      ];
}
