import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/buttons/app_button_wide.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:privvy/views/authentication/login_mobile_otp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginWithMobile extends StatefulWidget {
  const LoginWithMobile({super.key});

  @override
  State<LoginWithMobile> createState() => _LoginWithMobileState();
}

class _LoginWithMobileState extends State<LoginWithMobile> {
  final _formKey = GlobalKey<FormState>();
  final _mobileFocus = FocusNode();
  String userPhoneNumber = "";

  handleMobileLogin() async {
    if (_formKey.currentState!.validate()) {
      _mobileFocus.unfocus();

      launchPopUp(context, const ContentLoadingWidget(), dismissible: false);

      await AuthService.sendOtp(
          phone: userPhoneNumber,
          errorStep: () {
            Navigator.pop(context);
            showAppToast(context, AppConstants.invalidPhoneNumber,
                isError: true);
          },
          // timeoutStep: () {
          //   print("timeoutStep:");
          //   Navigator.pop(context);
          //   showAppToast(context, AppConstants.otpTimeout, isError: true);
          // },
          nextStep: () {
            Navigator.pop(context);
            appNavigate(context, const LoginMobileOTP());
          });
    }
  }

  setUserPhoneNumber(String value) {
    userPhoneNumber = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Device.screenType == ScreenType.tablet
            ? AppThemeConstants().APP_TABLET_BASE_CONTENT_PADDING
            : AppThemeConstants().APP_BASE_CONTENT_PADDING),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Mobile Authentication",
                  style: AppThemeConstants.APP_HEADING_TEXT_MEDIUM,
                ),
              ),
            ),
            const Text('Phone number',
                style: AppThemeConstants.APP_BODY_TEXT_REGULAR),
            const SizedBox(
              height: 8,
            ),
            Form(
              key: _formKey,
              child: IntlPhoneField(
                focusNode: _mobileFocus,
                disableLengthCheck: true,
                decoration: InputDecoration(
                  border: AppThemeConstants.APP_TEXTFIELD_OUTLINE_BORDER,
                  focusedBorder: AppThemeConstants.APP_TEXTFIELD_FOCUSED_BORDER,
                ),
                style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                dropdownTextStyle: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                pickerDialogStyle: PickerDialogStyle(
                    backgroundColor: AppThemeConstants.APP_CARD_BG_DARK,
                    countryNameStyle: AppThemeConstants.APP_BODY_TEXT_SMALL,
                    countryCodeStyle: AppThemeConstants.APP_BODY_TEXT_SMALL_DIM,
                    searchFieldInputDecoration: InputDecoration(
                        border: AppThemeConstants.APP_TEXTFIELD_OUTLINE_BORDER,
                        focusedBorder:
                            AppThemeConstants.APP_TEXTFIELD_FOCUSED_BORDER,
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        hintStyle: AppThemeConstants.APP_BODY_TEXT_MEDIUM_DIM,
                        hintText: "Search Country",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15))),
                initialCountryCode: 'NG',
                onChanged: (phone) => setUserPhoneNumber(phone.completeNumber),
                validator: (value) {
                  if (value!.number.length < 8) {
                    return AppConstants.invalidPhoneNumber;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            AppButtonWide(
                buttonText: 'CONTINUE',
                disabled: false,
                callback: () => handleMobileLogin()),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
