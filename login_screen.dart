import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletService>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'EchoSphere',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Voice, Amplified Intelligently',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            if (walletService.currentAddress != null)
              Text(
                'Connected: ${walletService.currentAddress!.hex.substring(0, 10)}...',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: walletService.isLoading ? null : () async {
                await walletService.connectWallet();
                if (walletService.currentAddress != null && mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
              child: walletService.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Connect Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
