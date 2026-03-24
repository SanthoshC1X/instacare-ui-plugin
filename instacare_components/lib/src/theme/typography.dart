import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InstaCareTypography {
  InstaCareTypography._();

  /// -------------------------------
  /// FONT FAMILIES
  /// -------------------------------
  static const String headingFont = 'Crimson Pro';
  static const String bodyFont = 'Figtree';

  /// -------------------------------
  /// PAGE TITLE (h1)
  /// -------------------------------
  static final TextStyle h1 = GoogleFonts.crimsonPro(
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// SECTION TITLE (h2)
  /// -------------------------------
  static final TextStyle h2 = GoogleFonts.crimsonPro(
    fontSize: 20,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// SECTION INNER TITLE (h3)
  /// -------------------------------
  static final TextStyle h3 = GoogleFonts.crimsonPro(
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// SMALL TITLE (h4)
  /// -------------------------------
  static final TextStyle h4 = GoogleFonts.crimsonPro(
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0,
    height: 1.0,
  );
  
  //h5
  static final TextStyle h5 = GoogleFonts.figtree(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// BODY TEXT (p)
  /// -------------------------------
  static final TextStyle p = GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0,
    height: 1.0,
  );

  static final TextStyle body = p;

  /// -------------------------------
  /// ONE LINER - REGULAR (r)
  /// -------------------------------
  static final TextStyle r = GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// ONE LINER - MEDIUM (m)
  /// -------------------------------
  static final TextStyle m = GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// SMALL - REGULAR (s)
  /// -------------------------------
  static final TextStyle s = GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// SMALL - MEDIUM (sm)
  /// -------------------------------
  static final TextStyle sm = GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0,
    height: 1.0,
  );

  /// -------------------------------
  /// EXTRA SMALL - MEDIUM (xs)
  /// -------------------------------
  static final TextStyle xs = GoogleFonts.figtree(
    fontSize: 10,
    fontWeight: FontWeight.w500, // Medium
    letterSpacing: 0,
    height: 1.0,
  );
}
