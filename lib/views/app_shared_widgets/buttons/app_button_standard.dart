import 'package:flutter/material.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class AppButtonStandard extends StatelessWidget {
  final String buttonText;
  final bool disabled;
  final VoidCallback callback;
  final bool alternateStyling;

  const AppButtonStandard({ Key? key, required this.buttonText, required this.callback, required this.disabled, this.alternateStyling = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: disabled ? null : callback,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: alternateStyling ? Colors.white : AppThemeConstants.APP_PRIMARY_COLOR,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemeConstants().APP_BUTTON_STANDARD_BORDER_RADIUS))),
          child: Text(buttonText, style: alternateStyling ? AppThemeConstants.APP_BUTTON_TEXT_REGULAR_ALTERNATE : AppThemeConstants.APP_BUTTON_TEXT_REGULAR,),
      ),
    );

  }
}
