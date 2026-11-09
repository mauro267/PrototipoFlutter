import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/login_screen.dart';
import 'theme.dart';

void main() => runApp(const RutaVivaApp());

class RutaVivaApp extends StatelessWidget {
  const RutaVivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RutaViva',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      // RNF-03: todo en español (Colombia).
      locale: const Locale('es', 'CO'),
      supportedLocales: const [Locale('es', 'CO')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginScreen(),
    );
  }
}
