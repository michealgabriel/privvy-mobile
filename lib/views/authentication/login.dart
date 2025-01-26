import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:privvy/controllers/auth_service.dart';
import 'package:privvy/utils/app_helper_handlers.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_constants.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:custom_signin_buttons/custom_signin_buttons.dart';
import 'package:privvy/views/app_shared_widgets/others/content_loading_widget.dart';
import 'package:privvy/views/authentication/login_with_mobile.dart';
import 'package:video_player/video_player.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // init video ......
    _controller = VideoPlayerController.asset("assets/videos/bgvideo.mp4",
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        _controller.setLooping(true); // ! Loop control Here <---------------
        _controller.setVolume(0);
        _controller.play();
        setState(() {});
      });
  }

  handleRoute() {
    _controller.pause();
    appNavigate(context, const LoginWithMobile());
  }

  handleProviderAuth(bool isGoogle) async {
    launchPopUp(context, const ContentLoadingWidget(), dismissible: false);

    await AuthService.loginWithProvider(isGoogle: isGoogle).then((value) async {
      if (value == AppConstants.oauthSuccessMessageKey) {
        // ! should fetch using userid, their avatar and nickname. If they are null or no record,
        // ! route - AvatarSelection(isFreshSetup: true)  --->  else - route - Home() skipping the avatar selection
        await handleAfterAuthDecisionRoute(
            context, mounted); // popup is closed inside function
      } else if (value == AppConstants.oauthFailedMessageKey) {
        Navigator.pop(context);
        showAppToast(context, AppConstants.oauthLoginError, isError: true);
      } else {
        Navigator.pop(context);
        showAppToast(context, value, isError: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          !_controller.value.isInitialized
              ? Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                )
              : SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
          Container(
            color: Colors.black.withOpacity(0.65),
          ),
          Container(
            padding: EdgeInsets.all(Device.screenType == ScreenType.tablet
                ? 160
                : AppThemeConstants().APP_BASE_CONTENT_PADDING * 1.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Animate(
                  delay: const Duration(seconds: 2),
                  effects: const [FadeEffect(duration: Duration(seconds: 1))],
                  child: Row(
                    children: [
                      CustomSignInButton(
                        text: "Sign in with Apple",
                        borderRadius: 28,
                        customIcon: FontAwesomeIcons.apple,
                        buttonColor: Colors.black,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        onPressed: () => handleProviderAuth(false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Animate(
                  delay: const Duration(seconds: 3),
                  effects: const [FadeEffect(duration: Duration(seconds: 1))],
                  child: Row(
                    children: [
                      SignInButton(
                        button: Button.Google,
                        text: "Sign in with Google",
                        borderRadius: 28,
                        onPressed: () => handleProviderAuth(true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Animate(
                  delay: const Duration(seconds: 4),
                  effects: const [FadeEffect(duration: Duration(seconds: 1))],
                  child: Row(
                    children: [
                      CustomSignInButton(
                        text: "Sign in with Mobile",
                        borderRadius: 28,
                        customIcon: FontAwesomeIcons.mobileScreenButton,
                        buttonColor: AppThemeConstants.APP_PRIMARY_COLOR,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        // height: 42,
                        onPressed: () => handleRoute(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                DefaultTextStyle(
                  style: AppThemeConstants.APP_BODY_TEXT_SMALL_DIM,
                  child: AnimatedTextKit(
                    repeatForever: false,
                    // isRepeatingAnimation: true,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText(
                          'Authenticate with social providers. ${DateTime.now().year} Privvy. Terms & Conditions apply.',
                          textAlign: TextAlign.center,
                          textStyle: AppThemeConstants.APP_BODY_TEXT_SMALL_DIM),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
