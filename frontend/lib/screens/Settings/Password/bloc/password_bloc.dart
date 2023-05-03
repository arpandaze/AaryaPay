import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/repository/change_password.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository passwordRepository;
  BuildContext context;

  PasswordBloc({required this.context, required this.passwordRepository})
      : super(const PasswordState()) {
    on<CurrentChanged>(_onCurrentChanged);
    on<NewChanged>(_onNewChanged);
    on<ConfirmChanged>(_onConfirmChanged);
    on<SubmitEvent>(_onSubmit);
    on<PasswordChangeStatusEvent>(_onPasswordChangeStatusEvent);
  }

  void _onCurrentChanged(
      CurrentChanged event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(
        currentPassword: event.currentPassword,
        status: PasswordChangeStatus.idle));
  }

  void _onNewChanged(NewChanged event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(
      newPassword: event.newPassword, status: PasswordChangeStatus.idle
    ));
  }

  void _onConfirmChanged(
      ConfirmChanged event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword, status: PasswordChangeStatus.idle
    ));
  }

  void _onPasswordChangeStatusEvent(
      PasswordChangeStatusEvent event, Emitter<PasswordState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onSubmit(SubmitEvent event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(status: PasswordChangeStatus.submitting));

    if (state.currentPassword != "" &&
        state.newPassword != "" &&
        state.confirmPassword != "") {
      if (state.newPassword != state.confirmPassword) {
        emit(state.copyWith(status: PasswordChangeStatus.mismatch));
        return;
      }
      var body = {
        "current_password": state.currentPassword,
        "new_password": state.newPassword,
      };

      var response = await passwordRepository.changePassword(body: body);
      if (response['status'] != 202) {
        if (response['status'] == 409) {
          emit(state.copyWith(
              status: PasswordChangeStatus.sameError,
              errorText:
                  "The new password cannot be the same as the old password"));
        }
        if (response['status'] == 401) {
          emit(state.copyWith(
              status: PasswordChangeStatus.errorPassword,
              errorText: "The password is incorrect"));
        }
        emit(state.copyWith(
            status: PasswordChangeStatus.error, errorText: "Unknown Error"));
        return;
      }
      if (response['status'] == 202) {
        emit(state.copyWith(
            status: PasswordChangeStatus.success,
            errorText: "Password Changed Successfully",
            msgType: MessageType.success));
        return;
      }
    } else {
      emit(state.copyWith(
          status: PasswordChangeStatus.idle,
          errorText: "Fields cannot be empty"));
    }
  }
}
