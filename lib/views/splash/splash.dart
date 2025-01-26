import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showStableText = false;
  bool showFinalSplash = false;

  route() {
    Navigator.pushReplacementNamed(context, '/chill_experience');
  }

  startTime() async {
    Future.delayed(const Duration(seconds: 2), () {
      showFinalSplash = true;
      setState(() {});

      var duration = const Duration(seconds: 3);
      return Timer(duration, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemeConstants.APP_BG_DARK,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showFinalSplash == false
              ? Container(
                  alignment: Alignment.center,
                  width: 250,
                  child: DefaultTextStyle(
                    style: AppThemeConstants.APP_SPLASH_TEXT,
                    child: showStableText
                        ? const Text(
                            'PRIVVY',
                            textAlign: TextAlign.center,
                          )
                        : AnimatedTextKit(
                            repeatForever: false,
                            isRepeatingAnimation: false,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              FlickerAnimatedText('PRIVVY',
                                  textAlign: TextAlign.center),
                            ],
                            onFinished: () {
                              showStableText = true;
                              setState(() {});
                              startTime();
                            },
                          ),
                  ),
                )
              : Center(
                  child: Container(
                      color: Colors.transparent,
                      width: 350,
                      constraints:
                          const BoxConstraints(minWidth: 300, maxWidth: 350),
                      child: Image.asset(
                        "assets/images/splash.png",
                        fit: BoxFit.contain,
                      )),
                ),
        ],
      ),
    );
  }
}
