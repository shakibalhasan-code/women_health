import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:women_health/utils/constant/app_constant.dart';

class AppTheme {
  static Color primaryColor = Color(0xffE05D43);
  static Color secondColor = Color(0xff298E5F);
  static Color secondTransColor = Color(0xffD2EFE2);
  static Color blue50 = Color(0xffEDF4FC);
  static Color black400 = Color(0xff585858);
  static Color blue = Color(0xff64B5F6);
  static Color bluebg = blue.withOpacity(0.2);
  static Color highListColor = Color(0xffD81B60);
  static Color foregroundColor = Colors.white;
  static Color? fillColor = Colors.grey[200];

  static Color blueCard = Color(0xffEDF4FCCC);
  static Color orangeCard = Color(0xffFFE9E3CC);
  static Color greenCard = Color(0xffBEE0D0);
  static Color yelloward = Color(0xffFCF6E8);

  static TextStyle titleSmall =
      GoogleFonts.poppins(fontSize: 14, color: primaryColor);
  static TextStyle titleMedium =
      GoogleFonts.poppins(fontSize: 18, color: primaryColor);
  static TextStyle titleLarge = GoogleFonts.poppins(
      fontSize: 26, color: primaryColor, fontWeight: FontWeight.w700);

  static double defaultRadius = 20;

  static PinTheme pinTheme = PinTheme(
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(10),
    fieldHeight: 50,
    fieldWidth: 40,
    activeColor: primaryColor,
    selectedColor: primaryColor,
    inactiveColor: Colors.black,
  );

  static var theme = ThemeData(
    textTheme: TextTheme(
      titleSmall: GoogleFonts.poppins(
        fontSize: 12,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 1,
      backgroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: foregroundColor,
            textStyle:
                titleMedium.copyWith(fontWeight: FontWeight.w400, fontSize: 18),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.defaultRadius)),
            side: BorderSide.none,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 8))),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, // Enable filling the background
      fillColor: Colors
          .grey[200], // Set the background color (light grey in this case)
      border: InputBorder.none, // Remove the default border
      enabledBorder:
          InputBorder.none, // Remove the border when the input is enabled
      focusedBorder:
          InputBorder.none, // Remove the border when the input is focused
      contentPadding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 16.0), // Add padding for better spacing
    ),
  );
}
