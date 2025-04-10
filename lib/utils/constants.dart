import 'package:flutter/material.dart';

// All color constants
class AppColors {
  static const Color primaryColor = Color(0xFF9C6767);
  static const Color buttonColor = Color(0xFFCC8A8A);
  static const Color borderColor = Color(0xFF174666);
  static const Color textColor = Color(0xFF174666);
  static const Color backgroundColor = Colors.white;
  static const Color blackWithOpacity = Color(0x99000000);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color primaryPink = Color(0xFFCC8A8A);
  static const Color shadowColor = Color(0x40000000);
}

// All text styles
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: 'Montserrat',
  );

  static const TextStyle inputText = TextStyle(
    color: AppColors.textColor,
    fontSize: 14,
    fontFamily: 'Montserrat',
  );

  static const TextStyle buttonText = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    letterSpacing: 0.24,
    height: 1.5,
  );

  static const TextStyle accountText = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'Montserrat',
    // opacity is not a TextStyle property, use with Opacity widget if needed
  );

  static const TextStyle loginText = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontFamily: 'Montserrat',
  );
}

// Input decoration configuration
class AppInputDecorations {
  static InputDecoration authInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.inputText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 0.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 0.5,
        ),
      ),
    );
  }
}
