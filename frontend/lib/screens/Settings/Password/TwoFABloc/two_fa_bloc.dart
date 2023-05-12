import 'dart:convert';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/repository/enable_two_fa.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'two_fa_event.dart';
part 'two_fa_state.dart';

class TwoFaBloc extends Bloc<TwoFaEvent, TwoFaState> {
  final TwoFARepository twoFARepo;
  static const storage = FlutterSecureStorage();

  TwoFaBloc({
    required this.twoFARepo,
  }) : super(const TwoFaState()) {
    on<GetTwoFA>(_onGetTwoFA);
    on<TokenChanged>(_onTokenChanged);
    on<EnableTwoFA>(_onEnableTwoFA);
    on<ChangeSwitchValue>(_onChangeSwitchValue);
    on<LoadSwitch>(_onLoadSwitch);
    on<DisableTwoFA>(_onDisableTwoFA);

    add(LoadSwitch());
  }

  void _onChangeSwitchValue(ChangeSwitchValue event, Emitter<TwoFaState> emit) {
    if (state.switchValue == false) {
      emit(state.copyWith(enableCall: true));
    }

    if (state.switchValue == true) {
      emit(state.copyWith(disableCall: true));
    }

    emit(
      state.copyWith(
        enableCall: false,
        disableCall: false,
      ),
    );
  }

  void _onLoadSwitch(LoadSwitch event, Emitter<TwoFaState> emit) async {
    var twoFAValue = (await storage.read(key: "two_FA")) == "true";
    print("Current Two FA Status on Load: $twoFAValue");
    emit(state.copyWith(switchValue: twoFAValue));
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
            switchValue: true,
            msgType: MessageType.success,
            errorText: "Successfully enabled two factor authentication"));

        await storage.write(key: "two_FA", value: "true");
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

  void _onDisableTwoFA(DisableTwoFA event, Emitter<TwoFaState> emit) async {
    print("Disable");
    try {
      final response = await twoFARepo.disableTwoFA();
      if (response['status'] == 202) {
        emit(
          state.copyWith(
            switchValue: false,
            msgType: MessageType.success,
            errorText: "Two Factor Authentication Disabled.",
          ),
        );
        await storage.write(key: "two_FA", value: "false");
      } else {
        emit(state.copyWith(
          msgType: MessageType.error,
          errorText: "Could not Disable Two FA.",
        ));
      }
    } catch (e) {
      emit(
        state.copyWith(
          msgType: MessageType.error,
          errorText: "Could not Disable Two FA.",
        ),
      );
    }

    emit(state.copyWith(
      msgType: MessageType.idle,
      errorText: null,
    ));
  }

  void _onTokenChanged(TokenChanged event, Emitter<TwoFaState> emit) {
    emit(state.copyWith(token: event.token));
  }
}
