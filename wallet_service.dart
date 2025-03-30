import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletService extends ChangeNotifier {
  final Web3Client _web3client = Web3Client(
    'https://goerli.infura.io/v3/YOUR_INFURA_KEY', 
    Client()
  );
  final _storage = const FlutterSecureStorage();
  
  EthereumAddress? _currentAddress;
  Credentials? _credentials;
  bool _isLoading = false;

  EthereumAddress? get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;

  Future<void> connectWallet() async {
    try {
      _isLoading = true;
      notifyListeners();

      // In a real app, this would connect to MetaMask or similar
      // For demo, we'll use a test wallet
      final credentials = await _web3client.credentialsFromPrivateKey(
        '0xYOUR_TEST_PRIVATE_KEY'
      );
      
      _credentials = credentials;
      _currentAddress = await credentials.extractAddress();
      
      await _storage.write(
        key: 'walletAddress',
        value: _currentAddress?.hex,
      );
      
    } catch (e) {
      debugPrint('Wallet connection error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> init() async {
    final storedAddress = await _storage.read(key: 'walletAddress');
    if (storedAddress != null) {
      _currentAddress = EthereumAddress.fromHex(storedAddress);
      notifyListeners();
    }
  }
}
