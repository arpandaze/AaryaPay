import 'dart:io';

import 'package:aaryapay/constants.dart';
import 'package:aaryapay/repository/edit_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_information_event.dart';
part 'account_information_state.dart';

class AccountInformationBloc
    extends Bloc<AccountInformationEvent, AccountInformationState> {
  final EditProfileRepository repository;
  AccountInformationBloc({required this.repository})
      : super(const AccountInformationState()) {
    on<GetPersonal>(_onGetPersonal);
    on<EditPersonal>(_onEditPersonal);
    on<FirstNameChanged>(_onFirstNameChanged);
    on<MiddleNameChanged>(_onMiddleNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<DateChanged>(_onDateChanged);
    on<ImagePicked>(_onImagePicked);
    on<UploadPhoto>(_onUploadPhoto);
    add(GetPersonal());
  }

  void _onGetPersonal(
      GetPersonal event, Emitter<AccountInformationState> emit) async {
    try {
      final response = await repository.getProfile();
      emit(state.copyWith(
        tempFirstName: response['first_name'],
        tempMiddleName: response['middle_name'],
        tempLastName: response['last_name'],
        photoUrl: response['id'],
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  void _onFirstNameChanged(
      FirstNameChanged event, Emitter<AccountInformationState> emit) {
    emit(state.copyWith(
      firstname: event.firstname,
      msgType: MessageType.idle,
    ));
  }

  void _onMiddleNameChanged(
      MiddleNameChanged event, Emitter<AccountInformationState> emit) {
    emit(state.copyWith(
      middlename: event.middlename,
      msgType: MessageType.idle,
    ));
  }

  void _onLastNameChanged(
      LastNameChanged event, Emitter<AccountInformationState> emit) {
    emit(state.copyWith(
      lastname: event.lastname,
      msgType: MessageType.idle,
    ));
  }

  void _onImagePicked(
      ImagePicked event, Emitter<AccountInformationState> emit) async {
    emit(state.copyWith(image: event.image, paths: event.paths));
  }

  void _onDateChanged(
      DateChanged event, Emitter<AccountInformationState> emit) {
    emit(state.copyWith(
      dob: event.dob,
      msgType: MessageType.idle,
    ));
  }

  void _onUploadPhoto(
      UploadPhoto event, Emitter<AccountInformationState> emit) async {
    emit(state.copyWith(msgType: MessageType.idle));
    try {
      if (state.paths != "") {
        var response = await repository.uploadProfile(imagePath: state.paths!);
        emit(state.copyWith(
            imageSuccess: true,
            msgType: MessageType.success,
            errorText: "Uploaded Successfully",
            paths: "",
            image: null));
      } else {
        emit(state.copyWith(
            imageSuccess: false,
            msgType: MessageType.error,
            errorText: "Please select an image first"));
      }
    } catch (e) {
      emit(state.copyWith(
          imageSuccess: false,
          msgType: MessageType.error,
          errorText: "Upload failed"));
    }
  }

  void _onEditPersonal(
      EditPersonal event, Emitter<AccountInformationState> emit) async {
    emit(state.copyWith(msgType: MessageType.idle));
    try {
      if (state.firstname != "" && state.lastname != "" && state.dob != null) {
        var body = {
          "first_name": state.firstname,
          "middle_name": state.middlename,
          "last_name": state.lastname,
          "dob": (state.dob!.millisecondsSinceEpoch ~/ 1000).toString(),
        };
        print(body);
        var response = await repository.editPersonal(body: body);
        emit(state.copyWith(
            msgType: MessageType.success,
            errorText: "Edited Successfully",
            success: true));
      } else {
        emit(state.copyWith(
            msgType: MessageType.error, errorText: "Fields cannot be empty"));
      }
    } catch (e) {
      emit(state.copyWith(
          msgType: MessageType.error, errorText: "Error updating profile"));
    }
  }
}
