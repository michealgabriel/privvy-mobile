import 'package:flutter/material.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class AppButtonWide extends StatelessWidget {
  final String buttonText;
  final bool disabled;
  final VoidCallback callback;

  const AppButtonWide({required this.buttonText, required this.disabled, required this.callback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 55,
      child: ElevatedButton(
        onPressed: disabled ? null : callback,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppThemeConstants.APP_PRIMARY_COLOR,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemeConstants().APP_BUTTON_WIDE_BORDER_RADIUS))),
          child: Text(buttonText, style: AppThemeConstants.APP_BUTTON_TEXT_REGULAR,),
      ),
    );

  }
}
