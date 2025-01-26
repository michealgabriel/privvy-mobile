import 'package:flutter/material.dart';

class ConstructionOverlayWidget extends StatelessWidget {
  const ConstructionOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          height: 255, // ! has to be same height as card
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black.withOpacity(0.85),
          ),
          width: double.infinity,
        ),

        Center(child: Image.asset("assets/images/progress.png", width: 80, height: 80)),
      ],
    );
  }
}