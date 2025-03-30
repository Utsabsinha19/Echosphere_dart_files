import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../models/post.dart';
import '../services/web3_service.dart';
import '../services/ai_service.dart';
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
