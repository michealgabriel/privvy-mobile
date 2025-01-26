import 'package:flutter/material.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/utils/app_helper_handlers.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/buttons/app_button_wide.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginMobileOTP extends StatefulWidget {
  const LoginMobileOTP({super.key});

  @override
  State<LoginMobileOTP> createState() => _LoginMobileOTPState();
}

class _LoginMobileOTPState extends State<LoginMobileOTP> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final _otpFocus = FocusNode();


  handleOtpSubmit() async {
    if(_formKey.currentState!.validate()) 
    {
      _otpFocus.unfocus();

      launchPopUp(context, const ContentLoadingWidget(), dismissible: false);

      await AuthService.loginWithOtp(otp: _otpController.text).then((value) async {
        if(value == AppConstants.otpSuccessMessageKey) 
        {
          // ! should fetch using userid, their avatar and nickname. If they are null or no record,
          // ! route - AvatarSelection(isFreshSetup: true)  --->  else - route - Home() skipping the avatar selection
          await handleAfterAuthDecisionRoute(context, mounted);  // popup is closed inside function
        }
        else if(value == AppConstants.otpFailedMessageKey) 
        {
          Navigator.pop(context);
          showAppToast(context, AppConstants.otpCodeWrong, isError: true);
        }
        else {
          Navigator.pop(context);
          showAppToast(context, value, isError: true);
        }
      });
    }
  }

  handleOtpValidation(String value) {
    if(value.length != 6) {
      return "should be equal to six characters";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(Device.screenType == ScreenType.tablet ? AppThemeConstants().APP_TABLET_BASE_CONTENT_PADDING : AppThemeConstants().APP_BASE_CONTENT_PADDING),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 50,),
      
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: const Align(
                alignment: Alignment.center,
                child: Text("We sent an OTP", style: AppThemeConstants.APP_HEADING_TEXT,),
              ),
            ),
      
            const Text('Code', style: AppThemeConstants.APP_BODY_TEXT_REGULAR),
            const SizedBox(height: 8,),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _otpController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                maxLength: 6,
                focusNode: _otpFocus,
                decoration: InputDecoration(
                  border: AppThemeConstants.APP_TEXTFIELD_OUTLINE_BORDER,
                  focusedBorder: AppThemeConstants.APP_TEXTFIELD_FOCUSED_BORDER,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  hintText: '312465',
                  hintStyle: AppThemeConstants().APP_TEXTFIELD_HINT,
                ),
                cursorColor: AppThemeConstants.APP_PRIMARY_COLOR,
                style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                validator: (value) => handleOtpValidation(value.toString()),
              ),
            ),
        
            const SizedBox(height: 40,),
        
            AppButtonWide(buttonText: 'CONTINUE', disabled: false, callback: () => handleOtpSubmit()),
            
            const SizedBox(height: 120,),

          ],
        ),
      ),
    );
  }
}