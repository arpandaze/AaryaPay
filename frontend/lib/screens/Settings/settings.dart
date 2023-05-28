import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Home/components/favourites.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/account_information.dart';
import 'package:aaryapay/screens/Settings/Favourites/favourites_screen.dart';
import 'package:aaryapay/screens/Settings/Password/password_screen.dart';
import 'package:aaryapay/screens/Settings/Synchronization/synchronization_screen.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<MenuModal> itemList = [
      MenuModal("Account", [
        MenuItemModal(
          onTap: () => {
            Utils.mainAppNav.currentState!.push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AccountInformation(),
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
                          child: const AccountInformation(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          },
          icon: SvgPicture.asset(
            "assets/icons/profile-line.svg",
            width: 20,
            height: 20,
          ),
          label: "Account Information",
          trailingWidget: const CustomArrowedButton(),
        ),
        MenuItemModal(
          onTap: () => {
            Utils.mainAppNav.currentState!.push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const PasswordScreen(),
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
                          child: const PasswordScreen(),
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
          label: "Password & Security",
          trailingWidget: const CustomArrowedButton(),
        ),
        MenuItemModal(
          onTap: () => {
            Utils.mainAppNav.currentState!.push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const FavouritesScreen(),
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
                          child: const FavouritesScreen(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          },
          icon: SvgPicture.asset(
            "assets/icons/star.svg",
            width: 20,
            height: 20,
          ),
          label: "Favourites",
          trailingWidget: const CustomArrowedButton(),
        ),
      ]),
      MenuModal("General", [
        MenuItemModal(
          onTap: () => {
            Utils.mainAppNav.currentState!.push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SynchronizationScreen(),
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
                          child: const SynchronizationScreen(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          },
          icon: SvgPicture.asset(
            "assets/icons/sync.svg",
            width: 20,
            height: 20,
          ),
          label: "Synchronization",
          trailingWidget: const CustomArrowedButton(),
        ),
      ]),
    ];

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) => {
        if (state.status == AuthenticationStatus.logOut)
          {
            Utils.mainAppNav.currentState!
                .pushNamedAndRemoveUntil("/welcome", (route) => false)
          },
      },
      builder: (context, state) {
        return Container(
          clipBehavior: Clip.hardEdge,
          width: size.width,
          height: size.height * 0.72,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
            color: Color(0xfff4f6f4),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CustomMenuSelection(
                    itemList: itemList,
                  ),
                  button(context, size),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget button(BuildContext context, Size size) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.error) {
          SnackBarService.stopSnackBar();
          SnackBarService.showSnackBar(
              content: state.errorText, msgType: MessageType.error);
        }
      },
      builder: (context, state) {
        if (state.status != AuthenticationStatus.onLogOutProcess) {
          return CustomActionButton(
            label: "Logout",
            borderRadius: 10,
            width: size.width * 0.5,
            height: 45,
            onClick: () => {
              context.read<AuthenticationBloc>().add(LoggedOut()),
            },
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                child: const CircularProgressIndicator(),
              )
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: body(context),
    );
  }
}
