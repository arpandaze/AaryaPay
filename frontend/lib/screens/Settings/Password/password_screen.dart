import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/repository/enable_two_fa.dart';
import 'package:aaryapay/screens/Settings/Password/TwoFABloc/two_fa_bloc.dart';
import 'package:aaryapay/screens/Settings/Password/change_password.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_first.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  final bool switchValue = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => TwoFaBloc(
          twoFARepo: TwoFARepository(
        token: context.read<AuthenticationBloc>().state.token,
      )),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: body(context, colorScheme, textTheme, size),
      ),
    );
  }

  Widget body(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, Size size) {
    List<MenuModal> itemList = [
      MenuModal("Password", [
        MenuItemModal(
            onTap: () => {
                  Utils.mainAppNav.currentState!.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ChangePassword(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final curve = CurvedAnimation(
                          parent: animation,
                          curve: Curves.decelerate,
                        );

                        return Stack(
                          children: [
                            FadeTransition(
                              opacity: Tween<double>(
                                begin: 1.0,
                                end: 0.0,
                              ).animate(curve),
                            ),
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 1.0),
                                end: Offset.zero,
                              ).animate(curve),
                              child: FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(curve),
                                child: const ChangePassword(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                },
            icon: SvgPicture.asset(
              "assets/icons/lock.svg",
              width: 20,
              height: 20,
            ),
            label: "Change Password",
            trailingWidget: const CustomArrowedButton()),
      ]),
      MenuModal("Additional Security", [
        MenuItemModal(
          icon: SvgPicture.asset(
            "assets/icons/2fa.svg",
            width: 20,
            height: 20,
          ),
          label: "Enable 2FA",
          trailingWidget: BlocConsumer<TwoFaBloc, TwoFaState>(
            listener: (context, state) => {
              if (state.enableCall)
                {
                  Utils.mainAppNav.currentState!.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const TwoFactorAuthFirst(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final curve = CurvedAnimation(
                          parent: animation,
                          curve: Curves.decelerate,
                        );

                        return Stack(
                          children: [
                            FadeTransition(
                              opacity: Tween<double>(
                                begin: 1.0,
                                end: 0.0,
                              ).animate(curve),
                            ),
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 1.0),
                                end: Offset.zero,
                              ).animate(curve),
                              child: FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(curve),
                                child: const TwoFactorAuthFirst(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                },
              if (state.disableCall)
                {
                  context.read<TwoFaBloc>().add(DisableTwoFA()),
                },
              if (state.msgType == MessageType.error ||
                  state.msgType == MessageType.success)
                {
                  SnackBarService.stopSnackBar(),
                  SnackBarService.showSnackBar(
                      content: state.errorText, msgType: state.msgType)
                }
            },
            builder: (context, state) {
              return CupertinoSwitch(
                  value: state.switchValue,
                  activeColor: colorScheme.surfaceVariant,
                  onChanged: (bool? value) {
                    context.read<TwoFaBloc>().add(ChangeSwitchValue(
                          currentValue: value,
                        ));
                  });
            },
          ),
        ),
        MenuItemModal(
          icon: SvgPicture.asset(
            "assets/icons/2fa.svg",
            width: 20,
            height: 20,
          ),
          label: "Enable Biometrics",
          trailingWidget: BlocConsumer<TwoFaBloc, TwoFaState>(
            listener: (context, state) => {},
            builder: (context, state) {
              return CupertinoSwitch(
                  value: state.switchValue,
                  activeColor: colorScheme.surfaceVariant,
                  onChanged: (bool? value) {
                    // context.read<TwoFaBloc>().add(ChangeSwitchValue(
                    //       currentValue: value,
                    //     ));
                  });
            },
          ),
        )
      ]),
    ];

    return SettingsWrapper(
      pageName: "Password & Security",
      children: Center(child: CustomMenuSelection(itemList: itemList)),
    );
  }
}
