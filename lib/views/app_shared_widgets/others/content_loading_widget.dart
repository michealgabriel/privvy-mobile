import 'package:flutter/material.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class ContentLoadingWidget extends StatelessWidget {
  const ContentLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // padding: const EdgeInsets.only(top: 50),
        child: const CircularProgressIndicator(color: AppThemeConstants.APP_PRIMARY_COLOR,)
      ),
    );
  }
}