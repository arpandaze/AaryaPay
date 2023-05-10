part of 'qrscan_bloc.dart';

class QrScannerState extends Equatable {
  final List<int>? code;

  const QrScannerState({this.code});

  QrScannerState copyWith({
    List<int>? code,
  }) {
    return QrScannerState(code: code ?? this.code);
  }

  @override
  List<Object?> get props => [code];
}
