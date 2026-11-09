import 'package:flutter/material.dart';

class Pal {
  static const azul = Color(0xFF0B57D0);
  static const azulBg = Color(0xFFE6EEFC);
  static const fondo = Color(0xFFF3F6FC);
  static const borde = Color(0xFFE1E7F2);
  static const texto = Color(0xFF0F172A);
  static const suave = Color(0xFF64748B);
  static const verde = Color(0xFF0E9F6E);
  static const verdeBg = Color(0xFFE3F6EE);
  static const rojo = Color(0xFFD92D20);
  static const rojoBg = Color(0xFFFDECEA);
  static const ambar = Color(0xFFB45309);
  static const ambarBg = Color(0xFFFEF3C7);
  static const gris = Color(0xFF64748B);
  static const grisBg = Color(0xFFEEF1F6);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Pal.azul),
    scaffoldBackgroundColor: Pal.fondo,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Pal.texto,
      elevation: 0,
    ),
  );
}
