import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomAnimationWidget.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/SplashScreen/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(),
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.isBiometricAuthSuccess == true) {
            Utils.mainAppNav.currentState!
                .pushNamedAndRemoveUntil("/app", (_) => false);
          }
        },
        builder: (context, state) {
          return BlocConsumer<DataBloc, DataState>(
            listener: (context, dataState) {
              if (dataState.isReady == true &&
                  dataState.isLoaded == false &&
                  dataState.profile == null) {
                Utils.mainAppNav.currentState!
                    .pushNamedAndRemoveUntil("/welcome", (_) => false);
              }
            },
            buildWhen: (previous, current) => previous != current,
            builder: (context, dataState) {
              print("IS ready");
              print(dataState.isReady);
              return SafeArea(
                top: false,
                bottom: true,
                left: true,
                right: true,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xfff6f4fa),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.3,
                            child: Utils.mainlogo,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              'AaryaPay',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .merge(const TextStyle(
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ],
                      ),
                      (dataState.isReady && dataState.profile != null)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<SplashBloc>()
                                        .add(InitiateBiometricAuth());
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: SvgPicture.asset(
                                      'assets/icons/fingerprint.svg',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                ),
                                Text("Tap to Login",
                                    style:
                                        Theme.of(context).textTheme.titleMedium)
                              ],
                            )
                          : const CustomAnimationWidget(
                              width: 50,
                              height: 50,
                              repeat: true,
                              assetSrc: "assets/animations/loading.json",
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
