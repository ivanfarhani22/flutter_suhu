import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'temperature_calculator_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Classic color palette
  final Color primaryColor = const Color(0xFF4A4A4A);
  final Color accentColor = const Color(0xFFBF9456);
  final Color backgroundLight = const Color(0xFFF8F5F2);
  final Color textDark = const Color(0xFF333333);
  final Color cardBg = Colors.white;

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthState>(context, listen: false);
      if (authProvider.login()) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TemperatureCalculatorScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {
        return Scaffold(
          backgroundColor: backgroundLight,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo atau Icon
                      Icon(
                        Icons.thermostat,
                        size: 80,
                        color: accentColor,
                      ),
                      const SizedBox(height: 24),
                      
                      // Judul
                      Text(
                        'Kalkulator Suhu',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        'Silakan login untuk melanjutkan',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Username field
                      TextFormField(
                        controller: authState.usernameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: primaryColor),
                          prefixIcon: Icon(Icons.person, color: accentColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor, width: 2),
                          ),
                          filled: true,
                          fillColor: cardBg,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          // Regex untuk username: hanya huruf, angka, dan underscore, minimal 3 karakter
                          final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,}$');
                          if (!usernameRegex.hasMatch(value)) {
                            return 'Username hanya boleh huruf, angka, dan underscore (min. 3 karakter)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Password field
                      TextFormField(
                        controller: authState.passwordController,
                        style: const TextStyle(color: Colors.black),
                        obscureText: !authState.isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: primaryColor),
                          prefixIcon: Icon(Icons.lock, color: accentColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authState.isPasswordVisible 
                                ? Icons.visibility_off 
                                : Icons.visibility,
                              color: accentColor,
                            ),
                            onPressed: () {
                              authState.togglePasswordVisibility();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor, width: 2),
                          ),
                          filled: true,
                          fillColor: cardBg,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          // Regex untuk password: minimal 8 karakter, setidaknya 1 huruf dan 1 angka
                          final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password min. 8 karakter dengan min. 1 huruf dan 1 angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Remember me checkbox
                      Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return accentColor;
                                  }
                                  return Colors.transparent;
                                }),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(color: accentColor),
                              ),
                            ),
                            child: Checkbox(
                              value: authState.rememberMe,
                              onChanged: (value) {
                                authState.toggleRememberMe(value!);
                              },
                            ),
                          ),
                          Text('Ingat saya', style: TextStyle(color: textDark)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Fungsi lupa password
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur lupa password belum tersedia'),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: accentColor,
                            ),
                            child: const Text('Lupa Password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Login button
                      ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Register button
                      OutlinedButton(
                        onPressed: () {
                          // Fungsi register
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur register belum tersedia'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: accentColor,
                            width: 1.5,
                          ),
                          foregroundColor: accentColor,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}