import 'dart:async';
import 'dart:convert';
import 'package:aaryapay/helper/utils.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class BiometricAuthSuccess extends SplashEvent {}

class CheckBiometricAvailable extends SplashEvent {}

class InitiateBiometricAuth extends SplashEvent {}

class SplashState extends Equatable {
  final String? goToScreen;
  final bool? isBiometricAvailable;
  final bool? isBiometricAuthSuccess;

  const SplashState({
    this.goToScreen,
    this.isBiometricAvailable,
    this.isBiometricAuthSuccess,
  });

  SplashState copyWith({
    String? goToScreen,
    bool? isBiometricAvailable,
    bool? isBiometricAuthSuccess,
  }) {
    return SplashState(
      goToScreen: goToScreen ?? this.goToScreen,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isBiometricAuthSuccess:
          isBiometricAuthSuccess ?? this.isBiometricAuthSuccess,
    );
  }

  @override
  List<Object?> get props =>
      [goToScreen, isBiometricAvailable, isBiometricAuthSuccess];
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  SplashBloc() : super(const SplashState()) {
    on<BiometricAuthSuccess>(_onBiometricAuthSuccess);
    on<CheckBiometricAvailable>(_onCheckBiometricAvailable);
    // on<CheckBiometricAvailable>(_onCheckBiometricAvailable);
    on<InitiateBiometricAuth>(_onInitiateBiometricAuth);
    add(CheckBiometricAvailable());
  }

  Future<void> _onInitiateBiometricAuth(
    InitiateBiometricAuth event,
    Emitter<SplashState> emit,
  ) async {
    if (state.isBiometricAvailable == true) {
      final LocalAuthentication auth = LocalAuthentication();
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Touch your finger on the sensor to login',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          sensitiveTransaction: true,
          useErrorDialogs: true,
        ),
      );
      if (didAuthenticate) {
        add(BiometricAuthSuccess());
      } else {
      }
    } else {
      add(BiometricAuthSuccess());
    }
  }

  Future<void> _onBiometricAuthSuccess(
    BiometricAuthSuccess event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(goToScreen: "/app", isBiometricAuthSuccess: true));
    return;
  }

  Future<void> _onCheckBiometricAvailable(
    CheckBiometricAvailable event,
    Emitter<SplashState> emit,
  ) async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (canAuthenticate && availableBiometrics.isNotEmpty) {
      emit(
        state.copyWith(isBiometricAvailable: true),
      );
      return;
    }

    emit(
      state.copyWith(isBiometricAvailable: false),
    );
    return;
  }
}
