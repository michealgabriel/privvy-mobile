import 'package:flutter/material.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class AppToast extends StatelessWidget {
  final String message;
  final bool? isError;
  const AppToast({Key? key, required this.message, this.isError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: isError != null && isError == true
            ? Colors.red
            : AppThemeConstants.APP_WIDGET_OVERLAY_BG_DARK,
      ),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          isError != null && isError == true
              ? const SizedBox()
              : const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
