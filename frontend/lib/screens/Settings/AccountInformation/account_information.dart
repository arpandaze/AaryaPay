import 'dart:io';
import 'package:aaryapay/components/CircularLoadingAnimation.dart';
import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/repository/edit_profile.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/bloc/account_information_bloc.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/components/ProfileDatePicker.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.background,
      child: BlocProvider(
        create: (context) => AccountInformationBloc(
          repository: EditProfileRepository(
              token: context.read<AuthenticationBloc>().state.token),
        ),
        child: body(size, colorScheme, context),
      ),
    );
  }

  Widget body(Size size, ColorScheme colorScheme, BuildContext context) {
    return BlocConsumer<AccountInformationBloc, AccountInformationState>(
      listener: (context, state) async {
        if (state.msgType == MessageType.error ||
            state.msgType == MessageType.warning ||
            state.msgType == MessageType.success) {
          SnackBarService.stopSnackBar();
          SnackBarService.showSnackBar(
            content: state.errorText,
            msgType: state.msgType,
          );
        }
        if (state.success) {
          Utils.mainAppNav.currentState!.popUntil(ModalRoute.withName('/app'));
        }
        if (state.imageSuccess) {
          Utils.mainAppNav.currentState!.popUntil(ModalRoute.withName('/app'));
          await Utils()
              .cacheManager
              .removeFile("$fileServerBase/${state.photoUrl}");
        }
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
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: false, type: FileType.image);

                          if (result != null) {
                            List<File> image = result.paths
                                .map(
                                  (path) => File(path!),
                                )
                                .toList();

                            // ignore: use_build_context_synchronously
                            context.read<AccountInformationBloc>().add(
                                  ImagePicked(
                                      image: image[0], paths: result.paths[0]),
                                );
                          }
                        },
                        child: getProfileImage(state),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => {
                            context
                                .read<AccountInformationBloc>()
                                .add(UploadPhoto())
                          },
                          child: CustomStatusButton(
                              color: colorScheme.primary,
                              width: 150,
                              borderRadius: 5,
                              widget: SvgPicture.asset(
                                "assets/icons/upload.svg",
                                width: 18,
                                height: 18,
                              ),
                              label: "Upload Photo"),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                        outlined: true,
                        topText: "First Name",
                        enableTopText: true,
                        placeHolder: state.tempFirstName,
                        onChanged: (value) => {
                              context
                                  .read<AccountInformationBloc>()
                                  .add(FirstNameChanged(firstname: value))
                            }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                      outlined: true,
                      topText: "Middle Name",
                      enableTopText: true,
                      placeHolder: state.tempMiddleName,
                      onChanged: (value) => {
                        context
                            .read<AccountInformationBloc>()
                            .add(MiddleNameChanged(middlename: value))
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                        outlined: true,
                        topText: "Last Name",
                        enableTopText: true,
                        placeHolder: state.tempLastName,
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
                          style: Theme.of(context).textTheme.bodySmall!.merge(
                              const TextStyle(fontWeight: FontWeight.w700))),
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

  Widget getProfileImage(AccountInformationState profileSnapshot) {
    final String profileUrl = profileSnapshot.photoUrl;
    if (profileSnapshot.image != null) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(profileSnapshot.image!),
          ),
        ),
      );
    } else if (profileUrl != "") {
      return imageLoader(
        imageUrl: profileUrl,
        shape: ImageType.circle,
        width: 120,
        height: 120,
        errorImage: Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(("assets/images/default-pfp.png")),
            ),
          ),
        ),
      );
    } else {
      return const CircularLoadingAnimation(width: 120, height: 120);
    }
  }
}
