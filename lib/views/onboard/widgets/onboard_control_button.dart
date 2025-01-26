import 'package:flutter/material.dart';

class OnBoardControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback callback;
  const OnBoardControlButton({super.key, required this.icon, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 120),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: callback,
          child: Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black
            ),
            child: Icon(icon, color: Colors.white, size: 22,),
          ),
        ),
      ),
    );
  }
}