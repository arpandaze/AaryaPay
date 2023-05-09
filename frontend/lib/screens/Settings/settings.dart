import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
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
          onTap: () =>
              Utils.mainAppNav.currentState!.pushNamed("/app/settings/account"),
          icon: SvgPicture.asset(
            "assets/icons/profile-line.svg",
            width: 20,
            height: 20,
          ),
          label: "Account Information",
          trailingWidget: const CustomArrowedButton(),
        ),
        MenuItemModal(
          onTap: () => Utils.mainAppNav.currentState!
              .pushNamed("/app/settings/password"),
          icon: SvgPicture.asset(
            "assets/icons/lock.svg",
            width: 20,
            height: 20,
          ),
          label: "Password & Security",
          trailingWidget: const CustomArrowedButton(),
        ),
        MenuItemModal(
          onTap: () => Utils.mainAppNav.currentState!
              .pushNamed("/app/settings/favorites"),
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
          onTap: () =>
              Utils.mainAppNav.currentState!.pushNamed("/app/settings/sync"),
          icon: SvgPicture.asset(
            "assets/icons/sync.svg",
            width: 20,
            height: 20,
          ),
          label: "Synchronization",
          trailingWidget: const CustomArrowedButton(),
        ),
        // MenuItemModal(
        //   onTap: () => Utils.mainAppNav.currentState!
        //       .pushNamed("/app/settings/language"),
        //     icon: SvgPicture.asset(
        //       "assets/icons/language.svg",
        //       width: 20,
        //       height: 20,
        //     ),
        //     label: "Language",
        //     trailingWidget: SizedBox(
        //       height: 50,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 12),
        //             child: Text(
        //               "English",
        //               textAlign: TextAlign.right,
        //               style: Theme.of(context).textTheme.bodyLarge,
        //             ),
        //           ),
        //           const CustomArrowedButton(),
        //         ],
        //       ),
        //   ),
        // ),
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
        return SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height * 0.72,
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                CustomMenuSelection(
                  itemList: itemList,
                ),
                CustomActionButton(
                  label: "Logout",
                  borderRadius: 10,
                  width: size.width * 0.5,
                  height: 45,
                  onClick: () => {
                    context.read<AuthenticationBloc>().add(LoggedOut()),
                  },
                )
              ],
            ),
          ),
        );
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
