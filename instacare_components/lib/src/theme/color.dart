import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // no instance

  /* =======================
   * Base Colors
   * ======================= */
  static const Color baseWhite = Color(0xFFFFFFFF);
  static const Color basePrimary = Color(0xFF34513A);
  static const Color baseSecondary = Color(0xFFDC9251);
  static const Color baseNatural = Color(0xFFA58E74);
  static const Color baseIvory = Color(0xFFFFEFCD);

  /* =======================
   * Primary Colors (100 → 1000)
   * ======================= */
  static const Color primary900 = Color(0xFF001F02); // 900
  static const Color primary800 = Color(0xFF17381E); // 800
  static const Color primary700 = Color(0xFF34513A); // 700
  static const Color primary600 = Color(0xFF516A56); // 600
  static const Color primary500 = Color(0xFF6E8372); // 500
  static const Color primary400 = Color(0xFF8B9C8E); // 400
  static const Color primary300 = Color(0xFFA8B4AB); // 300
  static const Color primary200 = Color(0xFFC5CDC7); // 200
  static const Color primary100 = Color(0xFFE2E6E3); // 100
  static const Color primary50 = Color(0xFFF1F3F1); // 50

  /* =======================
   * Secondary Colors
   * ======================= */
  static const Color secondary900 = Color(0xFFD2731F); // 900
  static const Color secondary800 = Color(0xFFD78238); // 800
  static const Color secondary700 = Color(0xFFDC9251); // 700
  static const Color secondary600 = Color(0xFFE1A26A); // 600
  static const Color secondary500 = Color(0xFFE6B183); // 500
  static const Color secondary400 = Color(0xFFEBC19C); // 400
  static const Color secondary300 = Color(0xFFF0D0B4); // 300 //backgroundcolor
  static const Color secondary200 = Color(0xFFF5E0CD); // 200
  static const Color secondary100 = Color(0xFFFAEFE6); // 100
  static const Color secondary50 = Color(0xFFFDF7F3); // 50

  /* =======================
   * Natural Colors
   * ======================= */
  static const Color natural900 = Color(0xFF8B6E4C); // 900
  static const Color natural800 = Color(0xFF987E60); // 800
  static const Color natural700 = Color(0xFFA58E74); // 700
  static const Color natural600 = Color(0xFFB29E88); // 600
  static const Color natural500 = Color(0xFFBFAE9C); // 500
  static const Color natural400 = Color(0xFFCCBEB0); // 400
  static const Color natural300 = Color(0xFFD8CFC3); // 300
  static const Color natural200 = Color(0xFFE5DFD7); // 200
  static const Color natural100 = Color(0xFFF2EFEB); // 100
  static const Color natural50 = Color(0xFFF9F7F5); // 50

  /* =======================
   * Ivory (Warm) Colors
   * ======================= */
  static const Color ivory900 = Color(0xFFFFEABF); // 900
  static const Color ivory800 = Color(0xFFFFEDC6); // 800
  static const Color ivory700 = Color(0xFFFFEFCD); // 700
  static const Color ivory600 = Color(0xFFFFF1D4); // 600
  static const Color ivory500 = Color(0xFFFFF4DB); // 500
  static const Color ivory400 = Color(0xFFFFF6E2); // 400
  static const Color ivory300 = Color(0xFFFFF8EA); // 300
  static const Color ivory200 = Color(0xFFFFFAF1); // 200
  static const Color ivory100 = Color(0xFFFFFDF8); // 100
  static const Color ivory50 = Color(0xFFFFFEFB); // 50

  /* =======================
   * Gray Colors
   * ======================= */
  static const Color gray900 = Color(0xFF000000); // 900
  static const Color gray800 = Color(0xFF201F20); // 800
  static const Color gray700 = Color(0xFF403F40); // 700
  static const Color gray600 = Color(0xFF605F60); // 600
  static const Color gray500 = Color(0xFF807F80); // 500
  static const Color gray400 = Color(0xFF9F9F9F); // 400  
  static const Color gray300 = Color(0xFFBFBFBF); // 300
  static const Color gray200 = Color(0xFFDFDFDF); // 200
  static const Color gray100 = Color(0xFFEFEFEF); // 100
  static const Color gray50 = Color(0xFFF8F8F8); // 50



  /* =======================
   * Error Colors
   * ======================= */
  static const Color error900 = Color(0xFFFB0000); // 900
  static const Color error800 = Color(0xFFFC0000); // 800
  static const Color error700 = Color(0xFFFC1C03); // 700
  static const Color error600 = Color(0xFFFC3C27); // 600
  static const Color error500 = Color(0xFFFD5D4B); // 500
  static const Color error400 = Color(0xFFFD7D6F); // 400
  static const Color error300 = Color(0xFFFE9E93); // 300
  static const Color error200 = Color(0xFFFEBEB7); // 200
  static const Color error100 = Color(0xFFFFDFDB); // 100
  static const Color error50 = Color(0xFFFFEFED); // 50

  /* =======================
   * Success Colors
   * ======================= */
  static const Color success900 = Color(0xFF00C400); // 900
  static const Color success800 = Color(0xFF15CA00); // 800
  static const Color success700 = Color(0xFF32D10A); // 700
  static const Color success600 = Color(0xFF4FD82D); // 600
  static const Color success500 = Color(0xFF6DDE50); // 500
  static const Color success400 = Color(0xFF8AE573); // 400
  static const Color success300 = Color(0xFFA7EB96); // 300
  static const Color success200 = Color(0xFFC4F2B9); // 200
  static const Color success100 = Color(0xFFE2F8DC); // 100
  static const Color success50 = Color(0xFFF0FCEE); // 50

  /* =======================
   * Semantic UI Colors
   * ======================= */
  static const Color infoBg = Color(0xFFEAF2FF);
  static const Color infoFg = Color(0xFF1D4ED8);
  static const Color warningBg = Color(0xFFFFF6E5);
  static const Color warningFg = Color(0xFF9A6700);
  static const Color errorBg = Color(0xFFFFECEC);
  static const Color errorFg = Color(0xFFB42318);
  static const Color successBg = Color(0xFFE8F7ED);
  static const Color successFg = Color(0xFF1E7F43);
  static const Color completedBg = Color(0xFFEDEBFF);
  static const Color completedFg = Color(0xFF5B21B6);

  /* =======================
   * Service Card Defaults
   * ======================= */
  static const Color serviceCardBackground = Color(0xFF6F8572);
  static const Color serviceCardTitle = Color(0xFFF2E4CB);
  static const Color serviceCardBody = Color(0xFFE6E9E2);
  static const Color serviceCardAccent = Color(0xFFAFC0A8);
}
