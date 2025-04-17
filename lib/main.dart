import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'temperature_provider.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthState()),
        ChangeNotifierProvider(create: (context) => TemperatureState()),
      ],
      child: MaterialApp(
        title: 'Kalkulator Suhu',
        theme: ThemeData(
          primaryColor: const Color(0xFF4A4A4A),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFBF9456),
          ),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}