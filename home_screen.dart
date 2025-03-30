import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/wallet_service.dart';
import '../services/ai_service.dart';
import '../utils/theme_service.dart';
import '../models/post_model.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Post> _publicPosts = [];
  List<Post> _privatePosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final aiService = Provider.of<AIService>(context, listen: false);
    final walletService = Provider.of<WalletService>(context, listen: false);
    
    try {
      setState(() => _isLoading = true);
      
      // Load public posts (would be from blockchain in production)
      _publicPosts = await aiService.getPublicPosts();
      
      // Load personalized private feed
      _privatePosts = await aiService.getPersonalizedFeed(
        walletService.currentAddress?.hex ?? ''
      );
      
    } catch (e) {
      debugPrint('Error loading posts: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('EchoSphere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () => themeService.toggleTheme(),
          ),
          IconButton(
            icon: FaIcon(themeService.is3DMode 
              ? FontAwesomeIcons.cube 
              : FontAwesomeIcons.solidSquare
            ),
            onPressed: () => themeService.toggle3DMode(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Public Feed'),
            Tab(text: 'Private Feed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeed(_publicPosts, isPublic: true),
          _buildFeed(_privatePosts, isPublic: false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeed(List<Post> posts, {required bool isPublic}) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          elevation: Provider.of<ThemeService>(context).is3DMode ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                if (post.summary != null)
                  Text(
                    'AI Summary: ${post.summary}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.voice_chat),
                      onPressed: () => _startVoiceReply(post.id),
                    ),
                    const Spacer(),
                    Text(
                      '${post.emotionScore}% ${post.emotionType}',
                      style: TextStyle(
                        color: _getEmotionColor(post.emotionType),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getEmotionColor(String emotion) {
    return AppConstants.moodColors[emotion.toLowerCase()] ?? Colors.grey;
  }

  void _showCreatePostDialog() {
    // Will implement post creation UI
  }

  void _startVoiceReply(String postId) {
    // Will implement voice reply functionality
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
