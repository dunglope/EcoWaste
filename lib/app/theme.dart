import 'package:flutter/material.dart';

const primary = Color(0xFF003F0A);
const primarySoft = Color(0xFFBFEFBE);
const background = Color(0xFFF9F9F8);
const surface = Color(0xFFFFFFFF);
const border = Color(0xFFD9DED2);
const textMuted = Color(0xFF4A5347);
const alert = Color(0xFFC5161D);
const alertSoft = Color(0xFFFFD8D2);
const purple = Color(0xFF7C3A55);

ThemeData buildEcoWasteTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: const Color(0xFF3E6842),
        surface: surface,
        error: alert,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w600, letterSpacing: 0),
        headlineMedium: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, letterSpacing: 0),
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0),
        titleMedium: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0),
        bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0),
      ),
    );
