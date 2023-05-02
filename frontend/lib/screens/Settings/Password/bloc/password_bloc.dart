import 'package:aaryapay/repository/change_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository passwordRepository;

  PasswordBloc({required this.passwordRepository})
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
    ));
  }

  void _onNewChanged(NewChanged event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(
      newPassword: event.newPassword,
    ));
  }

  void _onConfirmChanged(
      ConfirmChanged event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
    ));
  }

  void _onPasswordChangeStatusEvent(
      PasswordChangeStatusEvent event, Emitter<PasswordState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onSubmit(SubmitEvent event, Emitter<PasswordState> emit) async {
    emit(state.copyWith(status: PasswordChangeStatus.submitting));

    if (state.currentPassword != "" && state.newPassword != "") {
      if (state.newPassword != state.confirmPassword) {
        emit(state.copyWith(status: PasswordChangeStatus.mismatch));
        print("mismatch");
        return;
      }
      var body = {
        "current_password": state.currentPassword,
        "new_password": state.newPassword,
      };

      var response = await passwordRepository.changePassword(body: body);

      if (response['status'] != 202) {
      print(response["response"]);
        emit(state.copyWith(status: PasswordChangeStatus.error));
        return;
      }
      print("success");
      emit(state.copyWith(status: PasswordChangeStatus.success));
    } else {
      emit(state.copyWith(status: PasswordChangeStatus.empty));
    }
  }
}
