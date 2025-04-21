import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryYellow = Color(0xFFFACC15); // Prominent Yellow
  static const Color backgroundDark = Color(0xFF1F222A); // Main Dark Background
  static const Color cardDark = Color(0xFF2A2D36); // Slightly Lighter Card Background
  static const Color fieldDark = Color(0xFF363A45); // Dark Text Field Background
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFB0B0B0); // Lighter Grey for hints/subtitles
  static const Color iconGrey = Color(0xFF8A8A8F);
  static const Color divider = Color(0xFF41444E);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);
}

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primaryYellow,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryYellow,
      secondary: AppColors.primaryYellow, // Often same as primary or a variation
      background: AppColors.backgroundDark,
      surface: AppColors.cardDark, // Used for Cards, Dialogs, Sheets
      onPrimary: AppColors.backgroundDark, // Text/icons on primary color button
      onSecondary: AppColors.backgroundDark,
      onBackground: AppColors.textWhite,
      onSurface: AppColors.textWhite, // Text/icons on surface (cards)
      error: AppColors.errorRed,
      onError: AppColors.textWhite,
      brightness: Brightness.dark,
    ),

    // Text Theme using Google Fonts (Poppins)
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: GoogleFonts.poppins( // For Logo
          fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryYellow),
      headlineMedium: GoogleFonts.poppins( // For titles like "Welcome Back!"
          fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textWhite),
      titleLarge: GoogleFonts.poppins( // For AppBar Titles, Sheet Titles
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textWhite),
      titleMedium: GoogleFonts.poppins( // For card titles, list tiles
          fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textWhite),
       bodyLarge: GoogleFonts.poppins( // Regular body text, input text
           fontSize: 14, color: AppColors.textWhite),
      bodyMedium: GoogleFonts.poppins( // Slightly smaller text, like subtitles, links
          fontSize: 14, color: AppColors.textGrey),
       bodySmall: GoogleFonts.poppins( // Even smaller text
          fontSize: 12, color: AppColors.textGrey),
      labelLarge: GoogleFonts.poppins( // For button text
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.backgroundDark), // Text on yellow button
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark, // Match scaffold background
      elevation: 0, // Flat app bar
      centerTitle: false, // Titles usually aligned left in Figma
      iconTheme: const IconThemeData(color: AppColors.textWhite),
      titleTextStyle: GoogleFonts.poppins( // Re-apply in case needed directly
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textWhite),
    ),

    // Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldDark,
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
      hintStyle: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
      labelStyle: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 14),
      prefixIconColor: AppColors.iconGrey,
      suffixIconColor: AppColors.iconGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // No border by default
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryYellow, width: 1.5), // Highlight on focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
      ),
       errorStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.errorRed), // Validation message style
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: AppColors.backgroundDark, // Text color on button
        minimumSize: const Size(double.infinity, 52), // Full width, fixed height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins( // Re-apply for direct use
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
    ),
     textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryYellow, // Link color
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600, // Make links slightly bolder
        ),
      ),
    ),
     outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textWhite,
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: AppColors.divider), // Border color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)
        )
     ),

    // Card Theme
    cardTheme: CardTheme(
      color: AppColors.cardDark,
      elevation: 0, // Flat cards often look better in dark themes
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryYellow; // Selected color
        }
        return AppColors.fieldDark; // Unselected color (or textGrey)
      }),
      checkColor: MaterialStateProperty.all(AppColors.backgroundDark), // Check mark color
      side: BorderSide(color: AppColors.textGrey, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
       visualDensity: VisualDensity.compact, // Make it slightly smaller
    ),


    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryYellow,
      foregroundColor: AppColors.backgroundDark,
      elevation: 4,
       shape: CircleBorder(), // Ensure it's circular
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.cardDark, // Use card color for consistency
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      modalBackgroundColor: AppColors.cardDark,
      elevation: 5,
    ),

    // Dialog Theme
     dialogTheme: DialogTheme(
      backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    )),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 30, // Vertical space around divider
      indent: 20,
      endIndent: 20,
    ),

    // ListTile Theme
    listTileTheme: ListTileThemeData(
       iconColor: AppColors.iconGrey,
       textColor: AppColors.textWhite,
       subtitleTextStyle: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 12),
       dense: false, // Adjust density if needed
       contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Default padding
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.fieldDark, // Dark background
      contentTextStyle: GoogleFonts.poppins(color: AppColors.textWhite),
      actionTextColor: AppColors.primaryYellow,
      behavior: SnackBarBehavior.floating, // Floating style often looks good
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
     useMaterial3: true,
     brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryYellow, // Use yellow as seed
      brightness: Brightness.light,
      // Override specific colors if needed for better contrast
      surface: Colors.white,
      background: Colors.grey[50] ?? Colors.white,
    ),
     scaffoldBackgroundColor: Colors.grey[50],
     primaryColor: AppColors.primaryYellow,

     textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
       // Adjust text colors for light theme
       headlineLarge: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryYellow),
       headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
       titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
       titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
       bodyLarge: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
       bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
       bodySmall: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
       labelLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.backgroundDark),
     ),

    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.white, // White app bar
      foregroundColor: Colors.black87, // Icons/text on app bar
      elevation: 1, // Slight shadow
      titleTextStyle: GoogleFonts.poppins( // Re-apply
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
       iconTheme: IconThemeData(color: Colors.black87)
    ),

     floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryYellow,
      foregroundColor: AppColors.backgroundDark,
       shape: CircleBorder(),
    ),

      inputDecorationTheme: InputDecorationTheme(
       filled: true,
        fillColor: Colors.grey[100], // Lighter field background
       contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
       hintStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 14),
       labelStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
       prefixIconColor: Colors.grey[600],
       suffixIconColor: Colors.grey[600],
       border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
       ),
         enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
       focusedBorder: OutlineInputBorder(
         borderSide: const BorderSide(color: AppColors.primaryYellow, width: 1.5),
         borderRadius: BorderRadius.circular(12),
       ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        ),
        errorStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.red.shade700),
     ),

     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: AppColors.backgroundDark,
         minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
         textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)
      ),
    ),

     textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // Use primary color from color scheme for better consistency
        foregroundColor: AppColors.primaryYellow, // Or adjust if needed
         textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)
      ),
    ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87, // Text color for outlined button
          minimumSize: const Size(double.infinity, 50),
          side: BorderSide(color: Colors.grey.shade300), // Light border color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
           textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)
        )
     ),

     cardTheme: CardTheme(
       elevation: 1.5, // Slight elevation for light theme cards
       color: Colors.white, // White cards
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
     ),

      checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryYellow; // Selected color
        }
        return Colors.grey[300]; // Unselected color
      }),
      checkColor: MaterialStateProperty.all(AppColors.backgroundDark), // Check mark color
      side: BorderSide(color: Colors.grey.shade400, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
       visualDensity: VisualDensity.compact,
    ),


     bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        modalBackgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
     dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    )),
     dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
      space: 30,
      indent: 20,
      endIndent: 20,
    ),
     listTileTheme: ListTileThemeData(
       iconColor: Colors.grey[600],
       textColor: Colors.black87,
       subtitleTextStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
       contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),
     snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[800],
      contentTextStyle: GoogleFonts.poppins(color: Colors.white),
      actionTextColor: AppColors.primaryYellow,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
  
  static CheckboxListTileThemeData({required ListTileControlAffinity controlAffinity, required EdgeInsets contentPadding, required bool dense, required RoundedRectangleBorder checkboxShape, required Color activeColor}) {}
}