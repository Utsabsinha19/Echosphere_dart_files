import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';

import 'screens/home_screen.dart';
import 'screens/ar_viewer.dart';
import 'services/web3_service.dart';
import 'services/ai_service.dart';
import 'models/post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize 3D model loader
  Flutter3dObj.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Web3Service()..loadPosts()),
        ChangeNotifierProvider(create: (_) => AIService()),
      ],
      child: const EchoSphereApp(),
    ),
  );
}

class EchoSphereApp extends StatelessWidget {
  const EchoSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoSphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/ar-viewer': (context) {
          final post = ModalRoute.of(context)!.settings.arguments as Post;
          return ARViewerScreen(postContent: post.content);
        },
      },
    );
  }
}
