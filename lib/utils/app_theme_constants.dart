

// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class AppThemeConstants {
  
  // Theme Constant Value Definitions
  static const APP_BG_DARK = Colors.black;
  static const APP_CARD_BG_DARK = Color.fromARGB(255, 26, 26, 26);
  static const APP_BASE_TEXT_COLOR = Colors.white;
  static const APP_BASE_TEXT_COLOR_DIM = Color.fromARGB(215, 157, 157, 157);
  static const APP_BASE_TEXT_COLOR_DIM_2 = Color.fromARGB(212, 234, 234, 234);
  
  static const APP_WIDGET_OVERLAY_BG_DARK = Color(0xff383548);

  // Global Application Theme Value Definitions
  static const Color APP_PRIMARY_COLOR = Color(0xff6246EA);

  // Gradient Value Definitions
  static const APP_CARD_GRADIENT = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.10, 0.6],
    colors: [
      Color.fromARGB(255, 139, 120, 231),
      AppThemeConstants.APP_PRIMARY_COLOR,
    ],
  );
  static const APP_CARD_GRADIENT_RED = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.10, 0.6],
    colors: [
      Color.fromARGB(255, 234, 99, 99),
      Color.fromARGB(255, 229, 56, 56),
    ],
  );
  static const APP_CARD_GRADIENT_INVERTED = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.10, 0.6],
    colors: [
      Color.fromARGB(255, 131, 144, 245),
      Color.fromARGB(255, 61, 82, 241),
    ],
  );

  // Applicaion Styling Definitions
  double APP_BUTTON_WIDE_BORDER_RADIUS = 38;
  double APP_BUTTON_STANDARD_BORDER_RADIUS = 26;
  double APP_BASE_CONTENT_PADDING = 20;
  double APP_TABLET_BASE_CONTENT_PADDING = 80;

  // Fonts
  static const PRIVVY_BRAND_FONT_FAMILY = 'MRO Regular';
  static const FONT_FAMILY_REGULAR = 'Poppins Regular';
  static const FONT_FAMILY_SEMIBOLD = 'Poppins SemiBold';
  static const FONT_FAMILY_EXTRABOLD = 'Poppins ExtraBold';


  // Global App Text Styles
  static const APP_SPLASH_TEXT = TextStyle(
    fontSize: 55, 
    color: Colors.white, 
    fontFamily: PRIVVY_BRAND_FONT_FAMILY,
    shadows: [Shadow(blurRadius: 60, color: Colors.white, offset: Offset(0, 2),),],
  );
  // --
  static const APP_SPLASH_TEXT_2 = TextStyle(
    color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal,
    fontFamily: AppThemeConstants.FONT_FAMILY_REGULAR, 
    shadows: [Shadow(blurRadius: 6, color: Colors.white, offset: Offset(0, 0),),], 
  );
  // --
  static const APP_BODY_TEXT_SMALL = TextStyle(color: APP_BASE_TEXT_COLOR, fontSize: 12);
  static const APP_BODY_TEXT_SMALL_DIM = TextStyle(fontFamily: FONT_FAMILY_REGULAR, fontSize: 12, color: APP_BASE_TEXT_COLOR_DIM);
  static const APP_BODY_TEXT_REGULAR = TextStyle(fontFamily: FONT_FAMILY_REGULAR, fontSize: 16, fontWeight: FontWeight.w500, color: APP_BASE_TEXT_COLOR_DIM_2);
  static const APP_BODY_TEXT_MEDIUM = TextStyle(fontFamily: FONT_FAMILY_SEMIBOLD, fontSize: 14, height: 2, fontWeight: FontWeight.w500, color: APP_BASE_TEXT_COLOR);
  static const APP_BODY_TEXT_MEDIUM_DIM = TextStyle(fontFamily: FONT_FAMILY_SEMIBOLD, fontSize: 14, height: 2, fontWeight: FontWeight.w500, color: APP_BASE_TEXT_COLOR_DIM);
  static const APP_BODY_TEXT_LARGE = TextStyle(fontFamily: FONT_FAMILY_SEMIBOLD, fontSize: 20, height: 1.5, fontWeight: FontWeight.w500, color: APP_BASE_TEXT_COLOR);
  static const APP_HEADING_TEXT_SMALL = TextStyle(fontFamily: FONT_FAMILY_EXTRABOLD, fontSize: 24, letterSpacing: 0.3, height: 1.5, fontWeight: FontWeight.normal, color: APP_BASE_TEXT_COLOR);
  static const APP_HEADING_TEXT_MEDIUM = TextStyle(fontFamily: FONT_FAMILY_EXTRABOLD, fontSize: 30, letterSpacing: 0.3, height: 1.5, fontWeight: FontWeight.normal, color: APP_BASE_TEXT_COLOR);
  static const APP_HEADING_TEXT = TextStyle(fontFamily: FONT_FAMILY_EXTRABOLD, fontSize: 40, height: 1.5, fontWeight: FontWeight.w700, color: APP_BASE_TEXT_COLOR);
  static const APP_HEADING_TEXT_2 = TextStyle(fontFamily: FONT_FAMILY_EXTRABOLD, fontSize: 48, height: 1.5, fontWeight: FontWeight.w700, color: APP_BASE_TEXT_COLOR);
  // --
  TextStyle APP_TEXTFIELD_HINT = TextStyle(fontFamily: FONT_FAMILY_REGULAR, fontSize: 14, height: 1.7, fontWeight: FontWeight.w400, color: const Color(0xffA9A3C6).withOpacity(0.7));
  static const TextStyle APP_TEXTFIELD_HINT_ACCENT_DARK = TextStyle(fontFamily: FONT_FAMILY_REGULAR, fontSize: 14, height: 1.7, fontWeight: FontWeight.w400, color: Color(0xffF6F6F9));
  static const APP_TEXTFIELD_DARK = TextStyle(fontFamily: FONT_FAMILY_REGULAR, fontSize: 14, fontWeight: FontWeight.w500, color: APP_BASE_TEXT_COLOR);
  // --
  static const APP_BOTTOM_NAV_TEXT = TextStyle(fontFamily: FONT_FAMILY_REGULAR, fontSize: 12, height: 2, fontWeight: FontWeight.w500, color: Color(0xff8D87A6));


  // Button Text Styles
  static const APP_BUTTON_TEXT_REGULAR = TextStyle(fontFamily: FONT_FAMILY_SEMIBOLD, fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF));
  static const APP_BUTTON_TEXT_REGULAR_ALTERNATE = TextStyle(fontFamily: FONT_FAMILY_SEMIBOLD, fontSize: 15, fontWeight: FontWeight.w500, color: APP_PRIMARY_COLOR);


  // Border Stylings
    static OutlineInputBorder APP_TEXTFIELD_OUTLINE_BORDER = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
        width: 0.5,
        color: Colors.grey,
        style: BorderStyle.solid,
      ),
    );

    static OutlineInputBorder APP_TEXTFIELD_FOCUSED_BORDER = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
        width: 2,
        color: AppThemeConstants.APP_PRIMARY_COLOR,
        style: BorderStyle.solid,
      ),
    );

    static BoxDecoration APP_CONTAINER_OUTLINE_BORDER = BoxDecoration(
      color: Colors.transparent,
      border: Border.all(
        color: Colors.grey.withOpacity(0.7),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(4))
    );

    static const ShapeBorder APP_BOTTOM_SHEETS_BORDER = RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16)));

}