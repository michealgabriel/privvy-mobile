import 'package:flutter/material.dart';
import 'package:privvy/utils/app_shared_pref_handlers.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/onboard/widgets/onboard_control_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;

  final List<List<dynamic>> onboardData = [
    [
      "onboard1.jpg",
      "PRIVVY 😍",
      "Let privvy generate the best color variations for you.",
      210.0
    ],
    [
      "onboard2.jpg",
      "CAPTURE 📸",
      "Or choose item image to experience magic.",
      210.0
    ],
    [
      "onboard4.jpg",
      "QUALITY 💯",
      "For best results, ensure shoe or item image is against a background or placed on a platform like a table or couch.",
      210.0
    ],
    [
      "onboard5.jpg",
      "ENJOY 👊",
      "Explore numerous color variations . Share . Save collections",
      210.0
    ],
  ];

  handleSlideTap(int indexToGo) async {
    if (indexToGo >= 0) {
      if (indexToGo > onboardData.length - 1) {
        // if at last onboard screen
        await AppSPHandlers()
            .setBoolSP(AppSPHandlers.COMPLETED_ONBOARD, true)
            .then((_) {
          if (mounted) Navigator.pushNamed(context, '/login');
        });
      } else {
        currentIndex = indexToGo;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _buildPage(
          onboardData[currentIndex][0],
          onboardData[currentIndex][1],
          onboardData[currentIndex][2],
          onboardData[currentIndex][3],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OnBoardControlButton(
                icon: Icons.arrow_back_ios_rounded,
                callback: () => handleSlideTap(currentIndex - 1)),
            const SizedBox(
              width: 20,
            ),
            OnBoardControlButton(
                icon: Icons.arrow_forward_ios_rounded,
                callback: () => handleSlideTap(currentIndex + 1)),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 60),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: onboardData.length,
              effect: const ExpandingDotsEffect(
                  expansionFactor: 5,
                  dotWidth: 6,
                  dotHeight: 6,
                  spacing: 5,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildPage(String imageAssetName, String headerText, String subText,
      double contentSpacingHeight) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Container(
              color: Colors.black,
              child: Image.asset('assets/images/$imageAssetName',
                  fit: BoxFit.cover)),
        ),
        Container(
          color: Colors.black.withOpacity(0.75),
        ),
        Center(
          child: Container(
            padding:
                EdgeInsets.all(AppThemeConstants().APP_BASE_CONTENT_PADDING),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  headerText,
                  style: AppThemeConstants.APP_HEADING_TEXT,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: AppThemeConstants.APP_BODY_TEXT_REGULAR,
                ),
                SizedBox(
                  height: contentSpacingHeight,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
