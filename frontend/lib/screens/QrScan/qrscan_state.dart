part of 'qrscan_bloc.dart';

class QrScannerState extends Equatable {
  final String? code;

  const QrScannerState({this.code});

  QrScannerState copyWith({
    String? code,
  }) {
    return QrScannerState(code: code ?? this.code);
  }

  @override
  List<Object?> get props => [code];
}
