import 'package:novo_flashMart/features/splash/controllers/splash_controller.dart';
import 'package:novo_flashMart/features/profile/controllers/profile_controller.dart';
import 'package:novo_flashMart/common/models/response_model.dart';
import 'package:novo_flashMart/features/profile/domain/models/userinfo_model.dart';
import 'package:novo_flashMart/features/auth/controllers/auth_controller.dart';
import 'package:novo_flashMart/helper/auth_helper.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_button.dart';
import 'package:novo_flashMart/common/widgets/custom_snackbar.dart';
import 'package:novo_flashMart/common/widgets/footer_view.dart';
import 'package:novo_flashMart/common/widgets/image_picker_widget.dart';
import 'package:novo_flashMart/common/widgets/menu_drawer.dart';
import 'package:novo_flashMart/common/widgets/my_text_field.dart';
import 'package:novo_flashMart/common/widgets/not_logged_in_screen.dart';
import 'package:novo_flashMart/common/widgets/web_menu_bar.dart';
import 'package:novo_flashMart/features/profile/widgets/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  // final FocusNode _lastNameFocus = FocusNode();
  // final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  List<String> gender = <String>["Male", "Female", "Other"];
  String dropdownValue ="";

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn() &&
        Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    Get.find<ProfileController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<ProfileController>(builder: (profileController) {
        bool isLoggedIn = AuthHelper.isLoggedIn();
        if (profileController.userInfoModel != null &&
            _phoneController.text.isEmpty) {
          _firstNameController.text =
              profileController.userInfoModel!.name ?? '';
          // _lastNameController.text =
          //     profileController.userInfoModel!.lName ?? '';
          _phoneController.text = profileController.userInfoModel!.phone ?? '';
          _gender.text = profileController.userInfoModel!.gender ?? '';
          // _emailController.text = profileController.userInfoModel!.email ?? '';
        }

        return isLoggedIn
            ? profileController.userInfoModel != null
                ? ProfileBgWidget(
                    backButton: true,
                    circularImage: ImagePickerWidget(
                      image:
                          '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${profileController.userInfoModel!.image}',
                      onTap: () => profileController.pickImage(),
                      rawFile: profileController.rawFile,
                    ),
                    mainWidget: Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: ResponsiveHelper.isDesktop(context)
                            ? EdgeInsets.zero
                            : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Center(
                            child: FooterView(
                          minHeight: 0.45,
                          child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name'.tr,
                                      style: figTreeRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    MyTextField(
                                      hintText: 'first_name'.tr,
                                      controller: _firstNameController,
                                      focusNode: _firstNameFocus,
                                      // nextFocus: _lastNameFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                    ),
                                    // const SizedBox(
                                    //     height: Dimensions.paddingSizeLarge),

                                    // Text(
                                    //   'last_name'.tr,
                                    //   style: figTreeRegular.copyWith(
                                    //       fontSize: Dimensions.fontSizeSmall,
                                    //       color:
                                    //           Theme.of(context).disabledColor),
                                    // ),
                                    // const SizedBox(
                                    //     height:
                                    //         Dimensions.paddingSizeExtraSmall),
                                    // MyTextField(
                                    //   hintText: 'last_name'.tr,
                                    //   controller: _lastNameController,
                                    //   focusNode: _lastNameFocus,
                                    //   nextFocus: _emailFocus,
                                    //   inputType: TextInputType.name,
                                    //   capitalization: TextCapitalization.words,
                                    // ),
                                    // const SizedBox(
                                    //     height: Dimensions.paddingSizeLarge),

                                    // Text(
                                    //   'email'.tr,
                                    //   style: figTreeRegular.copyWith(
                                    //       fontSize: Dimensions.fontSizeSmall,
                                    //       color:
                                    //           Theme.of(context).disabledColor),
                                    // ),
                                    // const SizedBox(
                                    //     height:
                                    //         Dimensions.paddingSizeExtraSmall),
                                    // MyTextField(
                                    //   hintText: 'email'.tr,
                                    //   controller: _emailController,
                                    //   focusNode: _emailFocus,
                                    //   inputAction: TextInputAction.done,
                                    //   inputType: TextInputType.emailAddress,
                                    // ),
                                    // const SizedBox(
                                    //     height: Dimensions.paddingSizeLarge),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Select Gender'.tr,
                                          style: figTreeRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault)),
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    DropdownMenu<String>(
                                      initialSelection: _gender.text,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                      // color: grey
                                                      ))),
                                      menuStyle: MenuStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Theme.of(context).cardColor),
                                          shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  side: const BorderSide(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)))),
                                      trailingIcon: const Icon(
                                        Icons.expand_more,
                                        size: 24,
                                      ),
                                      hintText: _gender.text,
                                      textStyle: figTreeRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      onSelected: (String? value) async {
                                        setState(() {
                                          dropdownValue = value!;
                                          _gender.text = dropdownValue;
                                          debugPrint("Gender $dropdownValue");
                                        });
                                      },
                                      dropdownMenuEntries: gender
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value, label: value);
                                      }).toList(),
                                    ),
                                    Row(children: [
                                      Text(
                                        'phone'.tr,
                                        style: figTreeRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .disabledColor),
                                      ),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text('(${'non_changeable'.tr})',
                                          style: figTreeRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          )),
                                    ]),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    MyTextField(
                                      hintText: 'phone'.tr,
                                      controller: _phoneController,
                                      focusNode: _phoneFocus,
                                      inputType: TextInputType.phone,
                                      isEnabled: false,
                                    ),
                                    ResponsiveHelper.isDesktop(context)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeLarge),
                                            child: UpdateProfileButton(
                                                isLoading:
                                                    profileController.isLoading,
                                                onPressed: () {
                                                  return _updateProfile(
                                                      profileController);
                                                }),
                                          )
                                        : const SizedBox.shrink(),
                                  ])),
                        )),
                      )),
                      ResponsiveHelper.isDesktop(context)
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(
                                  bottom: GetPlatform.isIOS
                                      ? Dimensions.paddingSizeLarge
                                      : 0),
                              child: UpdateProfileButton(
                                  isLoading: profileController.isLoading,
                                  onPressed: () =>
                                      _updateProfile(profileController)),
                            ),
                    ]),
                  )
                : const Center(child: CircularProgressIndicator())
            : NotLoggedInScreen(callBack: (value) {
                initCall();
                setState(() {});
              });
      }),
    );
  }

  void _updateProfile(ProfileController profileController) async {
    String firstName = _firstNameController.text.trim();
    // String lastName = _lastNameController.text.trim();
    // String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String gender = _gender.text.trim();
    if (profileController.userInfoModel!.name == firstName &&
        // profileController.userInfoModel!.lName == lastName &&
        profileController.userInfoModel!.phone == phoneNumber &&
        // profileController.userInfoModel!.email == _emailController.text &&
        profileController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    } else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (gender.isEmpty) {
      showCustomSnackBar('Select your gender'.tr);
    }
    // else if (email.isEmpty) {
    //   showCustomSnackBar('enter_email_address'.tr);
    // }
    // else if (!GetUtils.isEmail(email)) {
    //   showCustomSnackBar('enter_a_valid_email_address'.tr);
    // }
    else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UserInfoModel updatedUser =
          UserInfoModel(name: firstName, gender: gender, phone: phoneNumber);
      ResponseModel responseModel = await profileController.updateUserInfo(
          updatedUser, Get.find<AuthController>().getUserToken());
      if (responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      } else {
        showCustomSnackBar(responseModel.message);
      }
    }
  }
}

class UpdateProfileButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  const UpdateProfileButton(
      {super.key, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? CustomButton(
            onPressed: onPressed,
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            buttonText: 'update'.tr,
          )
        : const Center(child: CircularProgressIndicator());
  }
}
