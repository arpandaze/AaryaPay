import 'dart:async';
import 'dart:convert';
import 'package:aaryapay/helper/utils.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:cryptography/cryptography.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:aaryapay/global/caching/profile.dart';
import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/global/caching/favorite.dart';
import 'package:libaaryapay/transaction/bkvc.dart';
import 'package:libaaryapay/transaction/utils.dart';
import 'package:aaryapay/constants.dart';
import 'package:libaaryapay/transaction/tvc.dart';
import 'package:libaaryapay/transaction/tam.dart';
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
  // final LocalAuthentication auth = LocalAuthentication();

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
        print("biometric auth failed");
      }
    } else {
      print("No biometric available!");
      add(BiometricAuthSuccess());
    }
  }

  Future<void> _onBiometricAuthSuccess(
    BiometricAuthSuccess event,
    Emitter<SplashState> emit,
  ) async {
    print(state);
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
