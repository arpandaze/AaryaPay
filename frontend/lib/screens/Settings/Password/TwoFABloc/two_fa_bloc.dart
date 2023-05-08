import 'package:aaryapay/constants.dart';
import 'package:aaryapay/repository/enable_two_fa.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'two_fa_event.dart';
part 'two_fa_state.dart';

class TwoFaBloc extends Bloc<TwoFaEvent, TwoFaState> {
  final TwoFARepository twoFARepo;
  TwoFaBloc({
    required this.twoFARepo,
  }) : super(const TwoFaState()) {
    on<GetTwoFA>(_onGetTwoFA);
    on<TokenChanged>(_onTokenChanged);
    on<EnableTwoFA>(_onEnableTwoFA);
  }

  void _onGetTwoFA(GetTwoFA event, Emitter<TwoFaState> emit) async {
    try {
      final response = await twoFARepo.getTwoFA();
      emit(state.copyWith(
          isLoaded: true, uri: response['uri'], secret: response['secret']));
    } catch (e) {
      emit(state.copyWith(
          isLoaded: false,
          msgType: MessageType.error,
          errorText: "Error TwoFA request"));
    }
  }

  void _onEnableTwoFA(EnableTwoFA event, Emitter<TwoFaState> emit) async {
    try {
      final response = await twoFARepo.enableTwoFA(code: state.token!);
      if (response['status'] == 202) {
        emit(state.copyWith(
            success: true,
            msgType: MessageType.success,
            errorText: "Successfully enabled two factor authentication"));
        return;
      } else {
        emit(state.copyWith(
            success: false,
            msgType: MessageType.error,
            errorText: "Invalid token"));
      }
    } catch (e) {
      emit(state.copyWith(
          success: false,
          msgType: MessageType.error,
          errorText: "Unknown Error"));
    }
  }

  void _onTokenChanged(TokenChanged event, Emitter<TwoFaState> emit) {
    emit(state.copyWith(token: event.token));
  }
}
