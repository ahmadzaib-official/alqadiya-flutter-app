import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeInfo {
  static double get borderRadius => 6.0;

  static ThemeData get themeData {
    var primaryColor = const MaterialColor(0xFF29397E, {
      50: Color(0xFFE5E7F3),
      100: Color(0xFFBFC5E1),
      200: Color(0xFF99A3CF),
      300: Color(0xFF7381BD),
      400: Color(0xFF4D5FAB),
      500: Color(0xFF29397E), // Your dark blue color
      600: Color(0xFF23306B),
      700: Color(0xFF1D2758),
      800: Color(0xFF171E45),
      900: Color(0xFF111532),
    });

    var baseTheme = ThemeData(
      useMaterial3: true, // Disabling Material 3
      scaffoldBackgroundColor: MyColors.backgroundColor,
      // inputDecorationTheme: InputDecorationTheme(
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
      //   ),
      //   filled: false,
      //   fillColor: MyColors.lightGray,
      //   contentPadding: const EdgeInsets.symmetric(
      //     vertical: 10.0,
      //     horizontal: 12,
      //   ),
      // ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppThemeInfo.borderRadius),
          ),
        ),
      ),
      cardTheme: const CardThemeData(elevation: 0),

      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColors.white,
        iconTheme: const IconThemeData(color: Colors.black, size: 18),
        titleTextStyle: AppTextStyles.labelMedium14().copyWith(
          color: Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MyColors.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColors.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      fontFamily: 'Cairo',

      textTheme: GoogleFonts.cairoTextTheme(),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          side: const BorderSide(color: MyColors.backgroundColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MyColors.backgroundColor,
        selectionHandleColor: MyColors.backgroundColor,
        // ignore: deprecated_member_use
        selectionColor: MyColors.backgroundColor.withValues(alpha: 0.5),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: const TextStyle(fontSize: 16.0),
        unselectedLabelStyle: const TextStyle(fontSize: 16.0),
        labelColor: MyColors.backgroundColor,
        unselectedLabelColor: MyColors.gray,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: MyColors.backgroundColor, width: 2.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeInfo.borderRadius),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: Colors.transparent,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MyColors.backgroundColor;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MyColors.backgroundColor;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MyColors.backgroundColor;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            // ignore: deprecated_member_use
            return MyColors.backgroundColor.withValues(alpha: 0.5);
          }
          return null;
        }),
      ),
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        accentColor: MyColors.backgroundColor,
        backgroundColor: Colors.white,
      ).copyWith(secondary: MyColors.backgroundColor),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.openSansTextTheme(baseTheme.textTheme),
    );
  }
}
