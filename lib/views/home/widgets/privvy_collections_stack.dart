import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:privvy/utils/app_material_navigator.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/buttons/app_button_standard.dart';
import 'package:privvy/views/collections/collections.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivvyCollectionsStack extends StatelessWidget {
  const PrivvyCollectionsStack({super.key});

  @override
  Widget build(BuildContext context) {
    const EdgeInsetsGeometry cardPaddings =
        EdgeInsets.symmetric(vertical: 25, horizontal: 12);
    const EdgeInsetsGeometry tabletCardPaddings =
        EdgeInsets.symmetric(vertical: 50, horizontal: 25);
    const Duration imagesFadeInDuration = Duration(milliseconds: 170);
    const double shoeImageWH = 365;
    const double tabletShoeImageWH = 500;

    handleCollectionsNavigate() {
      appNavigate(context, const Collections());
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Animate(
          delay: const Duration(seconds: 1),
          autoPlay: true,
          effects: const [
            FadeEffect(duration: Duration(seconds: 1)),
            ShimmerEffect(delay: Duration(seconds: 1))
          ],
          child: Container(
            padding: Device.screenType == ScreenType.tablet
                ? tabletCardPaddings
                : cardPaddings,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: AppThemeConstants.APP_CARD_GRADIENT),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      "Your Exclusive",
                      textAlign: TextAlign.start,
                      style: AppThemeConstants.APP_HEADING_TEXT_SMALL,
                    ),
                    Text(
                      "Collection Awaits",
                      textAlign: TextAlign.start,
                      style: AppThemeConstants.APP_HEADING_TEXT_SMALL,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    width: 110,
                    child: AppButtonStandard(
                      buttonText: "Explore",
                      disabled: false,
                      callback: () => handleCollectionsNavigate(),
                      alternateStyling: true,
                    ))
              ],
            ),
          ),
        ),
        Animate(
          delay: const Duration(seconds: 2),
          autoPlay: true,
          effects: const [
            FadeEffect(),
            SlideEffect(duration: imagesFadeInDuration)
          ],
          child: Positioned(
              right: Device.screenType == ScreenType.tablet ? -130 : -110,
              bottom: Device.screenType == ScreenType.tablet ? -135 : -105,
              child: IgnorePointer(
                  child: Transform.rotate(
                      angle: -0.1,
                      child: Image.asset(
                        "assets/images/nike2a.png",
                        width: Device.screenType == ScreenType.tablet
                            ? tabletShoeImageWH
                            : shoeImageWH,
                        height: Device.screenType == ScreenType.tablet
                            ? tabletShoeImageWH
                            : shoeImageWH,
                      )))),
        ),
      ],
    );
  }
}
