import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../models/post.dart';
import '../services/web3_service.dart';
import '../services/ai_service.dart';import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AIService with ChangeNotifier {
  final String _apiKey = 'YOUR_OPENAI_API_KEY';
  bool _isAnalyzing = false;

  bool get isAnalyzing => _isAnalyzing;

  Future<String> analyzeSentiment(String text) async {
    _isAnalyzing = true;
    notifyListeners();
    
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'Analyze the sentiment of this text and return only one word: positive, negative, or neutral.'
            },
            {'role': 'user', 'content': text}
          ],
          'max_tokens': 10,
        }),
      );

      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim().toLowerCase();
    } catch (e) {
      return 'neutral';
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<String> generateSummary(String text) async {
    _isAnalyzing = true;
    notifyListeners();
    
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'Summarize this text in 1-2 sentences while preserving key points.'
            },
            {'role': 'user', 'content': text}
          ],
          'max_tokens': 100,
        }),
      );

      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } catch (e) {
      return text.length > 100 ? '${text.substring(0, 100)}...' : text;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }
}
import '../widgets/post_card.dart';
import 'ar_viewer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _postController = TextEditingController();
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EchoSphere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () => Provider.of<Web3Service>(context, listen: false).connectWallet(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Web3Service>(
              builder: (context, web3, child) {
                return ListView.builder(
                  itemCount: web3.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: web3.posts[index],
                      onTap: () => _viewPostDetails(web3.posts[index]),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind?',
                      suffixIcon: IconButton(
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        onPressed: _listen,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _createPost,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _postController.text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _createPost() async {
    if (_postController.text.isEmpty) return;
    
    final web3 = Provider.of<Web3Service>(context, listen: false);
    final ai = Provider.of<AIService>(context, listen: false);
    
    final emotion = await ai.analyzeSentiment(_postController.text);
    final result = await web3.createPost(_postController.text, emotion);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
    );
    
    _postController.clear();
  }

  void _viewPostDetails(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ARViewerScreen(postContent: post.content),
      ),
    );
  }
}
