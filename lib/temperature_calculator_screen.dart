import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'temperature_provider.dart';
import 'login_page.dart';

class TemperatureCalculatorScreen extends StatefulWidget {
  const TemperatureCalculatorScreen({super.key});

  @override
  State<TemperatureCalculatorScreen> createState() => _TemperatureCalculatorScreenState();
}

class _TemperatureCalculatorScreenState extends State<TemperatureCalculatorScreen> {
  // Classic color palette
  final Color primaryColor = const Color(0xFF4A4A4A);
  final Color accentColor = const Color(0xFFBF9456);
  final Color backgroundLight = const Color(0xFFF8F5F2);
  final Color textDark = const Color(0xFF333333);
  final Color cardBg = Colors.white;

  // Get formula based on the selected units
  String _getFormula() {
    final temperatureState = Provider.of<TemperatureState>(context, listen: false);
    String fromUnit = temperatureState.selectedFromUnit;
    String toUnit = temperatureState.selectedToUnit;
    
    if (fromUnit == 'Celsius' && toUnit == 'Fahrenheit') {
      return '°F = °C × 9/5 + 32';
    } else if (fromUnit == 'Celsius' && toUnit == 'Kelvin') {
      return 'K = °C + 273.15';
    } else if (fromUnit == 'Fahrenheit' && toUnit == 'Celsius') {
      return '°C = (°F - 32) × 5/9';
    } else if (fromUnit == 'Fahrenheit' && toUnit == 'Kelvin') {
      return 'K = (°F - 32) × 5/9 + 273.15';
    } else if (fromUnit == 'Kelvin' && toUnit == 'Celsius') {
      return '°C = K - 273.15';
    } else if (fromUnit == 'Kelvin' && toUnit == 'Fahrenheit') {
      return '°F = (K - 273.15) × 9/5 + 32';
    } else {
      return 'No conversion needed';
    }
  }

  // Logout function
  void _logout(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Logout',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: TextStyle(
              color: accentColor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: accentColor.withOpacity(0.5)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Use the AuthState provider to logout
                Provider.of<AuthState>(context, listen: false).logout();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemperatureState>(
      builder: (context, temperatureState, child) {
        // Extracting values for the result section
        final double result = temperatureState.result ?? 0.0;
        final String selectedFromUnit = temperatureState.selectedFromUnit;
        final String selectedToUnit = temperatureState.selectedToUnit;
        final String inputTemperature = temperatureState.temperatureController.text.isEmpty 
            ? '0' 
            : temperatureState.temperatureController.text;

        return Scaffold(
          backgroundColor: backgroundLight,
          appBar: AppBar(
            title: const Text(
              'Kalkulator Suhu',
              style: TextStyle(
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
            backgroundColor: primaryColor,
            elevation: 0,
            actions: [
              // Logout button in app bar
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () => _logout(context),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: Container(
            color: backgroundLight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ornamental Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: primaryColor.withOpacity(0.3), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.thermostat, color: accentColor, size: 28),
                      ),
                      Expanded(child: Divider(color: primaryColor.withOpacity(0.3), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Input card
                  Card(
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: accentColor.withOpacity(0.5), width: 1),
                    ),
                    color: cardBg,
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Input Suhu',
                            style: TextStyle(
                              fontFamily: 'Serif',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Masukkan nilai yang ingin dikonversi',
                            style: TextStyle(
                              fontSize: 14,
                              color: textDark.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: temperatureState.temperatureController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 16,
                              color: textDark,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Nilai Suhu',
                              labelStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: accentColor, width: 2),
                              ),
                              filled: true,
                              fillColor: cardBg,
                              prefixIcon: Icon(Icons.science_outlined, color: accentColor),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Unit selection
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Dari', 
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      value: temperatureState.selectedFromUnit,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: accentColor, width: 2),
                                        ),
                                        filled: true,
                                        fillColor: cardBg,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      dropdownColor: cardBg,
                                      style: TextStyle(color: textDark, fontSize: 15),
                                      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                                      items: temperatureState.temperatureUnits.map((String unit) {
                                        return DropdownMenuItem<String>(
                                          value: unit,
                                          child: Text(unit),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          temperatureState.setFromUnit(newValue);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(
                                  Icons.compare_arrows,
                                  color: accentColor,
                                  size: 28
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Ke', 
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      value: temperatureState.selectedToUnit,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: accentColor, width: 2),
                                        ),
                                        filled: true,
                                        fillColor: cardBg,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      dropdownColor: cardBg,
                                      style: TextStyle(color: textDark, fontSize: 15),
                                      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                                      items: temperatureState.temperatureUnits.map((String unit) {
                                        return DropdownMenuItem<String>(
                                          value: unit,
                                          child: Text(unit),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          temperatureState.setToUnit(newValue);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          
                          // Convert button with classic styling
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: temperatureState.calculateTemperature,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: accentColor.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Konversi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Results card
                  Card(
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: accentColor.withOpacity(0.5), width: 1),
                    ),
                    color: cardBg,
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hasil Konversi',
                            style: TextStyle(
                              fontFamily: 'Serif',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Formula display
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primaryColor.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.functions, color: accentColor),
                                const SizedBox(width: 8),
                                Text(
                                  _getFormula(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Serif',
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Result display
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  accentColor.withOpacity(0.8),
                                  accentColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  result.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  selectedToUnit,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Additional information
                          Text(
                            'Hasil konversi dari $inputTemperature $selectedFromUnit ke $selectedToUnit.',
                            style: TextStyle(
                              fontSize: 14,
                              color: textDark.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24),

                          // Footer with ornamental divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: primaryColor.withOpacity(0.3), thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  '© 2025',
                                  style: TextStyle(
                                    color: primaryColor.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: 'Serif',
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: primaryColor.withOpacity(0.3), thickness: 1)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}