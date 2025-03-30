import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = Colors.blue;
  bool _is3DMode = false;
  String _currentMood = 'neutral';

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  bool get is3DMode => _is3DMode;
  String get currentMood => _currentMood;
  
  ThemeData get currentTheme {
    ColorScheme colorScheme;
    
    // Mood-based color schemes
    switch (_currentMood) {
      case 'happy':
        colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: _themeMode == ThemeMode.dark 
              ? Brightness.dark 
              : Brightness.light,
        );
        break;
      case 'sad':
        colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );
        break;
      case 'angry':
        colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        );
        break;
      default: // neutral
        colorScheme = ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: _themeMode == ThemeMode.dark 
              ? Brightness.dark 
              : Brightness.light,
        );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: _is3DMode ? 8 : 4,
        shadowColor: _is3DMode ? Colors.black54 : null,
      ),
    );
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void toggle3DMode() {
    _is3DMode = !_is3DMode;
    notifyListeners();
  }

  void setMood(String mood) {
    _currentMood = mood;
    notifyListeners();
  }

  static ThemeService of(BuildContext context) {
    return Provider.of<ThemeService>(context, listen: false);
  }
}
