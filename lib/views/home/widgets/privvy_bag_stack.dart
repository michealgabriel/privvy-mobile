import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/home/widgets/construction_overlay_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivvyBagStack extends StatefulWidget {
  final VoidCallback callback;
  final bool inConstruction;
  const PrivvyBagStack({super.key, required this.inConstruction, required this.callback});

  @override
  State<PrivvyBagStack> createState() => _PrivvyBagStackState();
}

class _PrivvyBagStackState extends State<PrivvyBagStack> {
  @override
  Widget build(BuildContext context) {

    const EdgeInsetsGeometry cardPaddings = EdgeInsets.symmetric(vertical: 25, horizontal: 12);
    const Duration imagesFadeInDuration = Duration(milliseconds: 170);

    return Stack(      // ! --------------- PRIVVY BAGS ----------------------//
      // clipBehavior: inConstruction ? Clip.hardEdge : Clip.none,
      clipBehavior: Clip.none,
      children: [
        Animate(
          delay: const Duration(seconds: 4),
          autoPlay: true,
          effects: const [FadeEffect(duration: Duration(seconds: 1)), ShimmerEffect(delay: Duration(seconds: 1))],
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
                      Text("Privvi-fy Bags", textAlign: TextAlign.start, style: AppThemeConstants.APP_HEADING_TEXT_SMALL,),
                      Text("Recommend bag variations", textAlign: TextAlign.start, style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
                    ],
                  ),
            
                  GestureDetector(
                    onTap: widget.callback,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        decoration: const BoxDecoration(
                          gradient: AppThemeConstants.APP_CARD_GRADIENT_INVERTED,
                        ),
                        child: const Icon(Iconsax.shopping_bag5, color: Colors.white, size: 32,))
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        Animate(
          delay: const Duration(seconds: 4),
          autoPlay: true,
          effects: const [FadeEffect(), SlideEffect(duration: imagesFadeInDuration)],
          child: Positioned(
            top: -85,
            left: Device.screenType == ScreenType.tablet ? 60 : 40,
            child: IgnorePointer(
              child: Transform.rotate(angle: 0.01, child: Image.asset("assets/images/bag.png", width: 250, height: 250,))
            )
          ),
        ),

        // ! inconstruction overlay
        widget.inConstruction ? const ConstructionOverlayWidget() : const SizedBox(),

      ],
    );
  }
}