import 'package:flutter/material.dart';

class TemperatureState extends ChangeNotifier {
  double _inputTemperature = 0;
  double _result = 0;
  String _selectedFromUnit = 'Celsius';
  String _selectedToUnit = 'Fahrenheit';
  final TextEditingController temperatureController = TextEditingController();
  
  final List<String> temperatureUnits = [
    'Celsius',
    'Fahrenheit',
    'Kelvin',
    'Reamur'
  ];

  // Getters
  double get inputTemperature => _inputTemperature;
  double get result => _result;
  String get selectedFromUnit => _selectedFromUnit;
  String get selectedToUnit => _selectedToUnit;

  // Setters that notify listeners
  void setFromUnit(String unit) {
    _selectedFromUnit = unit;
    notifyListeners();
  }

  void setToUnit(String unit) {
    _selectedToUnit = unit;
    notifyListeners();
  }

  void calculateTemperature() {
    _inputTemperature = double.tryParse(temperatureController.text) ?? 0;
    
    // First convert to Celsius as base unit
    double tempInCelsius;
    
    switch (_selectedFromUnit) {
      case 'Celsius':
        tempInCelsius = _inputTemperature;
        break;
      case 'Fahrenheit':
        tempInCelsius = (_inputTemperature - 32) * 5 / 9;
        break;
      case 'Kelvin':
        tempInCelsius = _inputTemperature - 273.15;
        break;
      case 'Reamur':
        tempInCelsius = _inputTemperature * 5 / 4;
        break;
      default:
        tempInCelsius = _inputTemperature;
    }
    
    // Then convert from Celsius to target unit
    switch (_selectedToUnit) {
      case 'Celsius':
        _result = tempInCelsius;
        break;
      case 'Fahrenheit':
        _result = (tempInCelsius * 9 / 5) + 32;
        break;
      case 'Kelvin':
        _result = tempInCelsius + 273.15;
        break;
      case 'Reamur':
        _result = tempInCelsius * 4 / 5;
        break;
      default:
        _result = tempInCelsius;
    }
    
    notifyListeners();
  }

  String getFormula() {
    if (_selectedFromUnit == _selectedToUnit) {
      return 'Sama';
    }
    
    switch('${_selectedFromUnit}_$_selectedToUnit') {
      case 'Celsius_Fahrenheit':
        return '°F = (°C × 9/5) + 32';
      case 'Celsius_Kelvin':
        return 'K = °C + 273.15';
      case 'Celsius_Reamur':
        return '°R = °C × 4/5';
      case 'Fahrenheit_Celsius':
        return '°C = (°F - 32) × 5/9';
      case 'Fahrenheit_Kelvin':
        return 'K = (°F - 32) × 5/9 + 273.15';
      case 'Fahrenheit_Reamur':
        return '°R = (°F - 32) × 4/9';
      case 'Kelvin_Celsius':
        return '°C = K - 273.15';
      case 'Kelvin_Fahrenheit':
        return '°F = (K - 273.15) × 9/5 + 32';
      case 'Kelvin_Reamur':
        return '°R = (K - 273.15) × 4/5';
      case 'Reamur_Celsius':
        return '°C = °R × 5/4';
      case 'Reamur_Fahrenheit':
        return '°F = (°R × 9/4) + 32';
      case 'Reamur_Kelvin':
        return 'K = (°R × 5/4) + 273.15';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    temperatureController.dispose();
    super.dispose();
  }
}