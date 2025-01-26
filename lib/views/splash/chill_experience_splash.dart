import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:privvy/utils/app_helper_handlers.dart';
import 'package:privvy/utils/app_shared_pref_handlers.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class ChillExperienceSplash extends StatefulWidget {
  const ChillExperienceSplash({Key? key}) : super(key: key);

  @override
  State<ChillExperienceSplash> createState() => _ChillExperienceSplashState();
}


class _ChillExperienceSplashState extends State<ChillExperienceSplash> {

  route() async {
    bool? hasCompletedOnboard = await AppSPHandlers().getBoolSP(AppSPHandlers.COMPLETED_ONBOARD);

    if(hasCompletedOnboard == true) 
    {
      if(mounted) await handleAppInitAutoLogin(context, mounted);
    }else {
      if(mounted) Navigator.pushReplacementNamed(context, '/onboard');
    }
  }

  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.APP_BG_DARK,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              backgroundColor: AppThemeConstants.APP_PRIMARY_COLOR,
              radius: 100,
              child: Lottie.asset('assets/lotties/headphone.json', animate: false),
            ),


            const SizedBox(height: 50,),


            Container(
              alignment: Alignment.center,
              height: 30,
              width: double.infinity,
              child: DefaultTextStyle(
                style: AppThemeConstants.APP_SPLASH_TEXT_2,
                child: AnimatedTextKit(
                  repeatForever: false,
                  // isRepeatingAnimation: true,
                  totalRepeatCount: 1,
                  animatedTexts: [
                    FadeAnimatedText('privvy chill experience on', textAlign: TextAlign.center),
                    FlickerAnimatedText('privvy chill experience on', textAlign: TextAlign.center),
                  ],
                  onFinished: () {
                    route();
                  },
                ),
              ),
            ),

            const SizedBox(height: 30,),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Iconsax.headphones, color: Colors.white,),
                SizedBox(width: 5,),
                Text("Recommended", style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
              ],
            ),

            const SizedBox(height: 30,),
            
          ],
        ),
      ),
    );
  }
  
}