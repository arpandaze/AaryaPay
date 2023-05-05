part of 'two_fa_bloc.dart';

class TwoFaState extends Equatable {
  final String? twoFACode;
  final FAStatus status;

  const TwoFaState({
    this.twoFACode,
    this.status = FAStatus.unknown,
  });

  TwoFaState copyWith({String? twoFACode, FAStatus? status}) {
    return TwoFaState(
      twoFACode: twoFACode ?? this.twoFACode,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [twoFACode, status];
}
