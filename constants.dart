class AppConstants {
  static const String appName = 'EchoSphere';
  static const String appTagline = 'Your Voice, Amplified Intelligently';
  
  // Mood settings
  static const Map<String, Color> moodColors = {
    'happy': Colors.yellow,
    'sad': Colors.blue,
    'angry': Colors.red,
    'neutral': Colors.grey,
  };

  // AI Service Constants
  static const String openAIKey = 'YOUR_OPENAI_KEY';
  static const String sentimentAnalysisEndpoint = 'https://api.example.com/sentiment';
  
  // Blockchain Constants
  static const String infuraUrl = 'https://goerli.infura.io/v3/YOUR_INFURA_KEY';
  static const String contractAddress = '0xYOUR_CONTRACT_ADDRESS';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonHeight = 48.0;
}
