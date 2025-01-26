
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivvyShoeStack extends StatefulWidget {
  final VoidCallback callback;
  const PrivvyShoeStack({super.key, required this.callback});

  @override
  State<PrivvyShoeStack> createState() => _PrivvyShoeStackState();
}

class _PrivvyShoeStackState extends State<PrivvyShoeStack> {

  final EdgeInsetsGeometry cardPaddings = const EdgeInsets.symmetric(vertical: 25, horizontal: 12);
  final Duration imagesFadeInDuration = const Duration(milliseconds: 170);


  @override
  Widget build(BuildContext context) {

    return Stack(      // ! --------------- PRIVVY SHOE ----------------------//
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topCenter,
      children: [
        Animate(
          delay: const Duration(seconds: 2),
          autoPlay: true,
          effects: const [FadeEffect(duration: Duration(seconds: 1)), ShimmerEffect(delay: Duration(seconds: 2))],
          child: Container(
            height: 255,
            padding: cardPaddings,
            // width: double.infinity,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: AppThemeConstants.APP_CARD_GRADIENT
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Wrap(
                    direction: Axis.vertical,
                    spacing: 5,
                    children: [
                      Text("Privvi-fy Shoes", textAlign: TextAlign.start, style: AppThemeConstants.APP_HEADING_TEXT_SMALL,),
                      Text("Recommend shoe variations", textAlign: TextAlign.start, style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
                    ],
                  ),
            
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: widget.callback,
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: const BoxDecoration(
                          gradient: AppThemeConstants.APP_CARD_GRADIENT_INVERTED,
                        ),
                        child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 32,)
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),

        Animate(
          delay: const Duration(seconds: 3),
          autoPlay: true,
          effects: [const FadeEffect(), SlideEffect(duration: imagesFadeInDuration)],
          child: Positioned(
            top: -155,
            left: Device.screenType == ScreenType.tablet ? -15 : -35,
            child: IgnorePointer(  // ignores it as a tappable widget
              child: Transform.rotate(
                angle: -0.08, 
                child: Image.asset("assets/images/nikeadapt1.png", width: 410, height: 410,)
              )
            )
          ),
        ),
      ],
    );
  }
}