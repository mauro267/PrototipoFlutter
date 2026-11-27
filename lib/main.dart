import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'screens/evidencias_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registro_screen.dart';
import 'services/auth_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Config.completa) {
    runApp(const ConfigFaltanteApp());
    return;
  }
  // Recupera la sesión guardada en el dispositivo antes de decidir la ruta inicial.
  await Supabase.initialize(url: Config.supabaseUrl, publishableKey: Config.supabaseKey);
  runApp(const RutaVivaApp());
}

/// Raíz de la app: tema, idioma es-CO y tabla de rutas nombradas.
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
      // F-01 CA-4: con sesión guardada se entra directo al panel.
      initialRoute: AuthService().haySesion() ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/home': (context) => const HomeScreen(),
        '/evidencias': (context) => const EvidenciasScreen(),
      },
    );
  }
}

/// Se muestra si la app se corrió sin env.json (AD-06), en lugar de fallar.
class ConfigFaltanteApp extends StatelessWidget {
  const ConfigFaltanteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Falta la configuración de Supabase.\n\n'
              'Copia env.example.json como env.json, pon la Project URL y la publishable key, '
              'y corre la app con:\n\nflutter run -d chrome --dart-define-from-file=env.json',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
