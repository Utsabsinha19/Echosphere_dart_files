import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/post.dart';

class Web3Service with ChangeNotifier {
  final Web3Client _client;
  final storage = const FlutterSecureStorage();
  late Credentials _credentials;
  bool _isLoading = false;
  String _error = '';

  List<Post> posts = [];
  bool get isLoading => _isLoading;
  String get error => _error;

  Web3Service() : _client = Web3Client('https://mainnet.infura.io/v3/YOUR_INFURA_KEY', Client());

  Future<void> connectWallet() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // In a real app, this would connect to MetaMask or other wallet
      await Future.delayed(const Duration(seconds: 2));
      
      _credentials = EthPrivateKey.fromHex('0x...');
      await storage.write(key: 'wallet', value: _credentials.address.hex);
      
      await loadPosts();
      _error = '';
    } catch (e) {
      _error = 'Failed to connect wallet: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> createPost(String content, String emotion) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // In a real app, this would create a blockchain transaction
      await Future.delayed(const Duration(seconds: 2));
      
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        author: 'User${_credentials.address.hex.substring(0, 6)}',
        timestamp: DateTime.now(),
        emotion: emotion,
      );
      
      posts.insert(0, newPost);
      _error = '';
      return 'Post created successfully';
    } catch (e) {
      _error = 'Failed to create post: $e';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate loading from blockchain
      await Future.delayed(const Duration(seconds: 1));
      
      posts = [
        Post(
          id: '1',
          content: 'Welcome to EchoSphere! The future of decentralized social media.',
          author: 'Admin',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          tags: ['welcome', 'introduction'],
          emotion: 'positive',
        ),
      ];
      _error = '';
    } catch (e) {
      _error = 'Failed to load posts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
