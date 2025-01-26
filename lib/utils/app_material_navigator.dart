// ignore_for_file: non_constant_identifier_names

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:privvy/utils/app_theme_constants.dart';
import 'package:privvy/views/app_shared_widgets/others/app_toast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void appNavigate(BuildContext context, Widget widget,
    {bool isPushReplace = false}) {
  isPushReplace
      ? Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              fullscreenDialog: true, builder: (context) => widget))
      : Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true, builder: (context) => widget));
}

void launchFlexibleBottomSheet(BuildContext context, Widget sheetWidget) {
  showFlexibleBottomSheet(
    minHeight: 0,
    initHeight: 0.6,
    maxHeight: 0.8,
    context: context,
    isExpand: true,
    builder: (BuildContext context, ScrollController scrollController,
        double bottomSheetOffset) {
      return Material(
          color: Colors.transparent,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: SingleChildScrollView(
                child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                      color: AppThemeConstants.APP_BG_DARK,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Container(
                            height: 6,
                            width: 70,
                            margin: const EdgeInsets.only(top: 20, bottom: 40),
                            decoration: BoxDecoration(
                                color: const Color(0xffE5E3EE),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        sheetWidget,
                      ],
                    ))),
          ));
    },
  );
}

void launchBottomSheet(
    BuildContext context, Widget sheetWidget, bool isScrollControlled,
    {bool? displayNotch = true, double? fixedHeight}) {
  showModalBottomSheet<void>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => Container(
          height: fixedHeight,
          margin: const EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            color: AppThemeConstants.APP_BG_DARK,
          ),
          child: Column(
            children: [
              displayNotch != null && displayNotch == false
                  ? const SizedBox()
                  : SizedBox(
                      child: Container(
                        height: 6,
                        width: 70,
                        margin: const EdgeInsets.only(top: 20, bottom: 40),
                        decoration: BoxDecoration(
                            color: const Color(0xff545067),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
              Expanded(child: sheetWidget),
            ],
          )));
}

Future launchPopUp(BuildContext context, Widget popupWidget,
    {List<Widget>? actions, bool? dismissible}) async {
  bool isTablet = Device.screenType == ScreenType.tablet;

  await showDialog(
      context: context,
      barrierDismissible: dismissible ?? true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => dismissible ?? true,
          child: AlertDialog(
            scrollable: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            backgroundColor: AppThemeConstants.APP_CARD_BG_DARK,
            content: Container(
              // height: 420,
              // width: Device.screenType == ScreenType.tablet ? 300 : 90,
              padding: EdgeInsets.symmetric(
                  vertical: 20, horizontal: isTablet ? 20 : 0),
              child: Center(child: popupWidget),
            ),
            actions: actions,
          ),
        );
      });
}

void showAppToast(BuildContext context, String toastMessage, {bool? isError}) {
  showToastWidget(
    AppToast(
      message: toastMessage,
      isError: isError,
    ),
    context: context,
    isIgnoring: false,
    animation: StyledToastAnimation.slideFromTopFade,
    duration: isError != null && isError == true
        ? const Duration(seconds: 4)
        : const Duration(seconds: 4),
  );
}
