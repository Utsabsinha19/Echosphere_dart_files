import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/web3dart.dart';

import 'screens/login_screen.dart';
import 'services/wallet_service.dart';
import 'utils/theme_service.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme service with default values
  final themeService = ThemeService();
  await themeService.setMood('neutral'); // Default mood
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletService()),
        ChangeNotifierProvider(create: (_) => themeService),
      ],
      child: const EchoSphereApp(),
    ),
  );
}

class EchoSphereApp extends StatelessWidget {
  const EchoSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    
    return MaterialApp(
      title: 'EchoSphere',
      debugShowCheckedModeBanner: false,
      theme: themeService.currentTheme,
      home: const LoginScreen(),
    );
  }
}
