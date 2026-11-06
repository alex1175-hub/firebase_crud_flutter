import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/add_usuario_page.dart';
import 'pages/edit_usuario_page.dart';
import 'pages/home_page.dart';

const _colorPrimario = Color(0xFF264653);
const _colorFondo = Color(0xFFF4F1DE);
const _colorAcento = Color(0xFFE76F51);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _colorPrimario,
          surface: _colorFondo,
        ).copyWith(
          primary: _colorPrimario,
          secondary: _colorAcento,
          tertiary: _colorAcento,
          error: _colorAcento,
        );

    return MaterialApp(
      title: 'Usuarios',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: _colorFondo,
        appBarTheme: const AppBarTheme(
          backgroundColor: _colorPrimario,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _colorAcento,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _colorPrimario,
            foregroundColor: Colors.white,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: _colorPrimario,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/add': (context) => const AddUsuario(),
        '/edit': (context) => const EditUsuario(),
      },
    );
  }
}
