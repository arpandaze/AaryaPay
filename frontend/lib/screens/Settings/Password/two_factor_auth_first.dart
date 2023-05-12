import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/repository/enable_two_fa.dart';
import 'package:aaryapay/screens/Settings/Password/TwoFABloc/two_fa_bloc.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_second.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TwoFactorAuthFirst extends StatelessWidget {
  const TwoFactorAuthFirst({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return Container(
      color: colorScheme.background,
      child: BlocProvider(
        create: (context) => TwoFaBloc(
            twoFARepo: TwoFARepository(
          token: context.read<AuthenticationBloc>().state.token,
        ))
          ..add(GetTwoFA()),
        child: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<TwoFaBloc, TwoFaState>(
      listener: (context, state) {
        if (state.msgType == MessageType.error ||
            state.msgType == MessageType.success ||
            state.msgType == MessageType.warning) {
          SnackBarService.stopSnackBar();
          SnackBarService.showSnackBar(
              content: state.errorText, msgType: state.msgType);
        }
      },
      builder: (context, state) {
        return SettingsWrapper(
          pageName: "Enable Two Factor Auth",
          children: Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //replace with new generated qr
                state.isLoaded!
                    ? QrImageView(
                        data: state.uri!,
                        size: 250,
                      )
                    : const CircularProgressIndicator(),
                Text(
                  "Please Scan the Code",
                  style: textTheme.headlineSmall!
                      .merge(const TextStyle(fontWeight: FontWeight.w700)),
                ),
                Text(
                  "Scan QR Code with a 3rd Party Authenticator Application of your choice to Enable Two Factor Authentication",
                  style: textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "OR",
                  style: textTheme.headlineSmall!.merge(
                    const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  "Enter this code manually:",
                  style: textTheme.titleSmall,
                ),
                state.isLoaded!
                    ? GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: "${state.secret}"));
                        },
                        child: Text(
                          "${state.secret}",
                          style: textTheme.titleSmall!.merge(
                            const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ))
                    : const CircularProgressIndicator(),

                CustomActionButton(
                  label: "Next",
                  onClick: () => Utils.mainAppNav.currentState!.push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          BlocProvider(
                        create: (context) => TwoFaBloc(
                          twoFARepo: TwoFARepository(
                              token: context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .token),
                        ),
                        child: const TwoFactorAuthSecond(),
                      ),
                    ),
                  ),
                  borderRadius: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
