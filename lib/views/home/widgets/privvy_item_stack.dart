import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/home/widgets/construction_overlay_widget.dart';

class PrivvyItemStack extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final String imagePath;
  final double imageWH;
  final double imagePositionedTopValue;
  final double imagePositionedLeftValue;
  final double imageRotatedAngle;
  final int cardAnimationDelay;
  final int imageAnimationDelay;
  final VoidCallback callback;
  final bool inConstruction;
  const PrivvyItemStack({super.key, required this.title, required this.subtitle, required this.iconData, required this.imagePath, required this.imageWH, required this.imagePositionedTopValue, required this.imagePositionedLeftValue, required this.imageRotatedAngle, required this.cardAnimationDelay, required this.imageAnimationDelay, required this.callback, required this.inConstruction});

  @override
  State<PrivvyItemStack> createState() => _PrivvyItemStackState();
}

class _PrivvyItemStackState extends State<PrivvyItemStack> {
  @override
  Widget build(BuildContext context) {

    const EdgeInsetsGeometry cardPaddings = EdgeInsets.symmetric(vertical: 25, horizontal: 12);
    const Duration imagesFadeInDuration = Duration(milliseconds: 170);

    return Stack(      // ! --------------- PRIVVY ITEM ----------------------//
      // clipBehavior: inConstruction ? Clip.hardEdge : Clip.none,
      clipBehavior: Clip.none,
      children: [
        Animate(
          delay: Duration(seconds: widget.cardAnimationDelay),
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
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 5,
                    children: [
                      Text(widget.title, textAlign: TextAlign.start, style: AppThemeConstants.APP_HEADING_TEXT_SMALL,),
                      Text(widget.subtitle, textAlign: TextAlign.start, style: AppThemeConstants.APP_BODY_TEXT_REGULAR,),
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
                        child: Icon(widget.iconData, color: Colors.white, size: 32,))
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        Animate(
          delay: Duration(seconds: widget.imageAnimationDelay),
          autoPlay: true,
          effects: const [FadeEffect(), SlideEffect(duration: imagesFadeInDuration)],
          child: Positioned(
            top: widget.imagePositionedTopValue,
            left: widget.imagePositionedLeftValue,
            child: IgnorePointer(  // ignores it as a tappable widget
              child: Transform.rotate(
                angle: widget.imageRotatedAngle, 
                child: Image.asset(widget.imagePath, width: widget.imageWH, height: widget.imageWH,)
              )
            )
          ),
        ),

        // ! inconstruction overlay
        widget.inConstruction ? const ConstructionOverlayWidget() : const SizedBox(),

      ],
    );
  }
}