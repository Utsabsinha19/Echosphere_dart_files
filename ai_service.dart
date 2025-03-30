import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../constants.dart';

class AIService {
  final _client = http.Client();

  Future<List<Post>> getPublicPosts() async {
    // In a real app, this would fetch from blockchain/IPFS
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return [
      Post(
        id: '1',
        content: 'Just discovered this amazing new decentralized social platform!',
        author: '0xUser123',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        summary: 'Excited about new decentralized social media',
        emotionType: 'happy',
        emotionScore: 85,
      ),
      Post(
        id: '2',
        content: 'How do I set up my AR profile on EchoSphere?',
        author: '0xAREnthusiast',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        emotionType: 'neutral',
        emotionScore: 50,
        isAR: true,
      ),
    ];
  }

  Future<List<Post>> getPersonalizedFeed(String walletAddress) async {
    // In a real app, this would use AI to curate based on user's history
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return [
      Post(
        id: '3',
        content: 'Based on your interests in Web3, you might like this article...',
        author: 'EchoSphere AI',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        summary: 'Suggested content about Web3 trends',
        emotionType: 'happy',
        emotionScore: 75,
      ),
      Post(
        id: '4',
        content: 'Your network is discussing AR interfaces today',
        author: 'EchoSphere AI',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        emotionType: 'excited',
        emotionScore: 90,
      ),
    ];
  }

  Future<String> generateSummary(String content) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Authorization': 'Bearer ${AppConstants.openAIKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': 'Summarize this post in one sentence: $content',
          'max_tokens': 60,
          'temperature': 0.7,
        }),
      );

      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } catch (e) {
      debugPrint('AI summary error: $e');
      return 'AI summary unavailable';
    }
  }

  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    try {
      final response = await _client.post(
        Uri.parse(AppConstants.sentimentAnalysisEndpoint),
        body: jsonEncode({'text': text}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('Sentiment analysis error: $e');
      return {'emotion': 'neutral', 'score': 50};
    }
  }

  Future<String> generateVoiceReply(String context) async {
    // Would use voice synthesis API in production
    return 'This is an AI-generated voice reply';
  }

  Future<String> convertToBlogPost(String content) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Authorization': 'Bearer ${AppConstants.openAIKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': 'Convert this social media post into a blog article: $content',
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } catch (e) {
      debugPrint('Blog conversion error: $e');
      return 'Failed to generate blog post';
    }
  }
}
