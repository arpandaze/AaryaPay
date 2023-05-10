import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/bloc/account_information_bloc.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/components/ProfileDatePicker.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:aaryapay/screens/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.background,
      child: BlocProvider(
        create: (context) => AccountInformationBloc(),
        child: body(size, colorScheme, context),
      ),
    );
  }

  Widget body(Size size, ColorScheme colorScheme, BuildContext context) {
    return BlocConsumer<AccountInformationBloc, AccountInformationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SettingsWrapper(
          pageName: "Account Information",
          children: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage("assets/images/default-pfp.png"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomStatusButton(
                            width: 150,
                            borderRadius: 5,
                            widget: SvgPicture.asset(
                              "assets/icons/upload.svg",
                              width: 18,
                              height: 18,
                            ),
                            label: "Upload Photo"),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                        outlined: true,
                        topText: "First Name",
                        enableTopText: true,
                        onChanged: (value) => {
                              context
                                  .read<AccountInformationBloc>()
                                  .add(FirstNameChanged(firstname: value))
                            }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                      outlined: true,
                      topText: "Middle Name",
                      enableTopText: true,
                      onChanged: (value) => {
                        context
                            .read<AccountInformationBloc>()
                            .add(MiddleNameChanged(middlename: value))
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                        outlined: true,
                        topText: "Last Name",
                        enableTopText: true,
                        onChanged: (value) => {
                              context
                                  .read<AccountInformationBloc>()
                                  .add(LastNameChanged(lastname: value))
                            }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Date of Birth",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .merge(TextStyle(fontWeight: FontWeight.w700))),
                    ),
                  ),
                  ProfileDateField(
                    dateTime: (DateTime date) {
                      context
                          .read<AccountInformationBloc>()
                          .add(DateChanged(dob: date));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: CustomActionButton(
                        label: "Save",
                        borderRadius: 10,
                        width: size.width * 0.78,
                        onClick: () => {
                              context
                                  .read<AccountInformationBloc>()
                                  .add(EditPersonal())
                            }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
