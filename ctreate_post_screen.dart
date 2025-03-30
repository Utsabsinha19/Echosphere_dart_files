import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/ai_service.dart';
import '../services/wallet_service.dart';
import '../models/post_model.dart';
import '../constants.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isARPost = false;
  bool _isPublic = true;
  bool _isGeneratingSummary = false;
  String? _generatedSummary;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aiService = Provider.of<AIService>(context);
    final walletService = Provider.of<WalletService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'What would you like to share?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _isARPost,
                    onChanged: (value) => setState(() => _isARPost = value),
                  ),
                  const Text('AR Post'),
                  const Spacer(),
                  Switch(
                    value: _isPublic,
                    onChanged: (value) => setState(() => _isPublic = value),
                  ),
                  Text(_isPublic ? 'Public' : 'Private'),
                ],
              ),
              if (_generatedSummary != null) ...[
                const SizedBox(height: 16),
                Text(
                  'AI Summary: $_generatedSummary',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: _isGeneratingSummary
                    ? const CircularProgressIndicator()
                    : const FaIcon(FontAwesomeIcons.robot),
                label: const Text('Generate AI Summary'),
                onPressed: _isGeneratingSummary ? null : _generateSummary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateSummary() async {
    if (_contentController.text.isEmpty) return;

    setState(() => _isGeneratingSummary = true);
    final aiService = Provider.of<AIService>(context, listen: false);
    
    try {
      final summary = await aiService.generateSummary(_contentController.text);
      setState(() => _generatedSummary = summary);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate summary')),
      );
    } finally {
      setState(() => _isGeneratingSummary = false);
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    final aiService = Provider.of<AIService>(context, listen: false);
    final walletService = Provider.of<WalletService>(context, listen: false);

    try {
      // In a real app, this would post to blockchain/IPFS
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _contentController.text,
        author: walletService.currentAddress?.hex ?? 'Unknown',
        timestamp: DateTime.now(),
        summary: _generatedSummary,
        isAR: _isARPost,
      );

      // Navigate back to home screen
      if (mounted) {
        Navigator.of(context).pop(newPost);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create post')),
        );
      }
    }
  }
}
